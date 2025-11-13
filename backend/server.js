const express = require('express');
const cloudinary = require('cloudinary').v2;
const dotenv = require('dotenv');

dotenv.config();

// Validate required env vars early
const {
  CLOUDINARY_CLOUD_NAME,
  CLOUDINARY_API_KEY,
  CLOUDINARY_API_SECRET,
} = process.env;

if (!CLOUDINARY_CLOUD_NAME || !CLOUDINARY_API_KEY || !CLOUDINARY_API_SECRET) {
  console.error(
    'Missing Cloudinary environment variables. Please set CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, and CLOUDINARY_API_SECRET.'
  );
  process.exit(1);
}

cloudinary.config({
  cloud_name: CLOUDINARY_CLOUD_NAME,
  api_key: CLOUDINARY_API_KEY,
  api_secret: CLOUDINARY_API_SECRET,
});

// Use a Map to maintain insertion order for simple eviction
const imageCache = new Map();
const MAX_CACHE_ENTRIES = 200; // adjust as needed

// Provide a fetch fallback for Node < 18 if node-fetch@2 is installed
let fetchFn = global.fetch;
if (!fetchFn) {
  try {
    // If you use node-fetch v2 you can require it in CommonJS
    // npm install node-fetch@2
    fetchFn = require('node-fetch');
    // if node-fetch returns the function as default or named import, normalize:
    if (fetchFn && fetchFn.default) fetchFn = fetchFn.default;
  } catch (err) {
    console.error(
      'No global fetch available and node-fetch not installed. Use Node 18+ or install node-fetch@2: npm i node-fetch@2'
    );
    process.exit(1);
  }
}

// Use wildcard route so public_id with slashes works: /image/<public_id-with-slashes>
const app = express();
app.get('/image/*', async (req, res) => {
  // req.params[0] contains the wildcard match
  const id = req.params[0];

  // Basic sanitization: allow letters, numbers, - _ . / and avoid '..'
  if (!id || /(\.\.)/.test(id) || !/^[A-Za-z0-9\-_.\/]+$/.test(id)) {
    return res.status(400).send('Invalid image id');
  }

  if (imageCache.has(id)) {
    console.log(`[Cache] HIT: ${id}`);
    const cached = imageCache.get(id);
    res.setHeader('Content-Type', cached.type);
    res.setHeader('Content-Length', String(cached.buffer.length));
    // Set a Cache-Control header so clients may cache
    res.setHeader('Cache-Control', 'public, max-age=86400');
    return res.send(cached.buffer);
  }

  try {
    console.log(`[Cloudinary] FETCH: ${id}`);
    // fetch resource metadata from Cloudinary
    const image = await cloudinary.api.resource(id);
    const imageUrl = image.secure_url;
    if (!imageUrl) throw new Error('No secure_url returned from Cloudinary');

    const response = await fetchFn(imageUrl);
    if (!response.ok) {
      throw new Error(`Failed to fetch image URL: ${response.status}`);
    }
    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);
    const type = response.headers.get('content-type') || 'application/octet-stream';

    // Simple cache insertion with eviction
    imageCache.set(id, { buffer, type });
    if (imageCache.size > MAX_CACHE_ENTRIES) {
      // delete oldest entry
      const oldestKey = imageCache.keys().next().value;
      imageCache.delete(oldestKey);
    }

    res.setHeader('Content-Type', type);
    res.setHeader('Content-Length', String(buffer.length));
    res.setHeader('Cache-Control', 'public, max-age=86400');
    res.send(buffer);
  } catch (error) {
    console.error(error);
    // If Cloudinary reports a 404-like error, respond 404
    return res.status(404).send('Image not found');
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

# Backend Server for Cloudinary Image Serving

This backend server serves images from Cloudinary.

## Prerequisites

- Node.js and npm installed
- A Cloudinary account

## Installation

1.  Clone the repository.
2.  Navigate to the `backend` directory.
3.  Install the dependencies:
    ```bash
    npm install
    ```
4.  Create a `.env` file in the `backend` directory and add your Cloudinary credentials:
    ```
    CLOUDINARY_CLOUD_NAME=<your_cloud_name>
    CLOUDINARY_API_KEY=<your_api_key>
    CLOUDINARY_API_SECRET=<your_api_secret>
    ```

## Usage

1.  Start the server:
    ```bash
    npm start
    ```
2.  The server will be running on `http://localhost:3000`.

## API

### GET /image/:id

This endpoint fetches an image from Cloudinary by its public ID.

-   `:id` (required): The public ID of the image in Cloudinary.

**Example:**

```
http://localhost:3000/image/sample
```

This will fetch the image with the public ID `sample` from your Cloudinary account.

## Additional Features

### Caching

The server implements an in-memory cache to reduce the number of requests to Cloudinary. When an image is requested for the first time, it is fetched from Cloudinary and stored in the cache. Subsequent requests for the same image will be served from the cache.

### Logging

The server logs requests and errors to the console.

-   Cache hits are logged with the prefix `[Cache]`.
-   Cloudinary fetches are logged with the prefix `[Cloudinary]`.
-   Errors are logged with `console.error`.

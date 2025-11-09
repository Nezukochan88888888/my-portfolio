# Images Directory

This directory is for storing your portfolio images.

## Current Setup

The portfolio currently uses placeholder images from [Picsum Photos](https://picsum.photos/id/237/200/300/) for demonstration purposes.

## Replacing Placeholder Images

To replace placeholder images with your own:

1. **Hero Background Image**: Replace the URL in `index.html` line ~85 (hero-background class)
   - Current: `https://picsum.photos/1600/900?random=1`
   - Recommended size: 1600x900px or larger

2. **About Portrait**: Replace the URL in `index.html` line ~97 (about-image)
   - Current: `https://picsum.photos/400/400?random=2`
   - Recommended size: 400x400px or square format

3. **Gallery Images**: Replace URLs in `index.html` gallery section (lines ~127-215)
   - Current: `https://picsum.photos/800/600?random=X`
   - Recommended size: 800x600px or larger
   - For lightbox display, the script will try to use larger versions (1600x1200)

## Image Optimization Tips

- Compress images before uploading (use tools like TinyPNG or Squoosh)
- Use WebP format for better compression (with fallbacks)
- Maintain consistent aspect ratios for gallery images
- Use descriptive alt text for accessibility

## Organizing Your Images

You can organize images in subdirectories like:
- `images/gallery/` - for portfolio/gallery images
- `images/about/` - for portrait/about section images
- `images/hero/` - for hero section background images

Then update the paths in `index.html` accordingly.


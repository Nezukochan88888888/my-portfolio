# 🧪 Testing Guide for Portfolio Website

## Quick Test (Already Opened)
The website should have opened in your browser automatically. If not, **double-click `index.html`** or **right-click → Open with → Browser**.

## ✅ Checklist of Features to Test

### 1. **Basic Display**
- [ ] Website loads without errors
- [ ] All sections are visible (Hero, About, Gallery, Services, Testimonials, Contact, Footer)
- [ ] Images load (they're from picsum.photos, so they may take a moment)
- [ ] Fonts load correctly (Poppins for headings, Lora for body)

### 2. **Navigation**
- [ ] Click navigation links - they should smooth scroll to sections
- [ ] Navbar stays fixed at top when scrolling
- [ ] Active section highlighting works (as you scroll)

### 3. **Dark Mode Toggle**
- [ ] Click the moon/sun icon in navbar
- [ ] Theme switches between light and dark
- [ ] Theme preference saves (refresh page - it should remember your choice)

### 4. **Mobile Menu** (Test on Mobile or Resize Browser)
- [ ] Resize browser to mobile width (< 768px)
- [ ] Hamburger menu (☰) appears in navbar
- [ ] Click hamburger - menu opens/closes
- [ ] Click menu links - menu closes automatically

### 5. **Gallery & Lightbox**
- [ ] Click any gallery image
- [ ] Lightbox opens with larger image
- [ ] Click X or outside to close
- [ ] Use Arrow keys (← →) to navigate between images
- [ ] Use Escape key to close lightbox
- [ ] Click Next/Previous buttons work

### 6. **Testimonials Carousel**
- [ ] Testimonials auto-rotate every 5 seconds
- [ ] Click dots below testimonials to switch manually
- [ ] Hover over testimonials section - rotation pauses

### 7. **Contact Form**
- [ ] Try submitting empty form - should show validation errors
- [ ] Enter invalid email - should show error
- [ ] Enter valid info - should show success message (green notification)
- [ ] Form resets after successful submission

### 8. **Back to Top Button**
- [ ] Scroll down page
- [ ] Back to top button appears (bottom right)
- [ ] Click button - smoothly scrolls to top
- [ ] Button disappears when at top

### 9. **Responsive Design**
Test at different screen sizes:
- [ ] Desktop (1200px+) - 3 column gallery
- [ ] Tablet (768px - 968px) - 2 column gallery
- [ ] Mobile (< 768px) - 1 column gallery, hamburger menu

### 10. **Scroll Animations**
- [ ] Scroll down slowly
- [ ] Sections fade in as they enter viewport

### 11. **Social Links**
- [ ] Hover over social icons - they should highlight and lift
- [ ] Click icons - opens in new tab (check they work)

### 12. **Services Section**
- [ ] Hover over service cards - they lift up
- [ ] Click "Contact Me" buttons - scrolls to contact form

## 🐛 Troubleshooting

### If images don't load:
- Check internet connection (images are from picsum.photos)
- Wait a few seconds - images load lazily
- Check browser console (F12) for errors

### If styles don't load:
- Check `css/style.css` exists and path is correct
- Open browser DevTools (F12) → Console tab
- Look for "404" errors for style.css

### If JavaScript doesn't work:
- Check `js/script.js` exists and path is correct
- Open browser DevTools (F12) → Console tab
- Look for JavaScript errors (red messages)

### If fonts don't load:
- Check internet connection (fonts from Google Fonts)
- Fonts should load automatically via CDN

## 🖥️ Testing with Local Server (Optional)

If you want to test with a local server (recommended for production):

### Python (if installed):
```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```
Then visit: `http://localhost:8000`

### Node.js (if installed):
```bash
npx http-server -p 8000
```
Then visit: `http://localhost:8000`

### VS Code:
- Install "Live Server" extension
- Right-click `index.html` → "Open with Live Server"

## 🌐 Browser Compatibility

Tested and works on:
- ✅ Chrome (latest)
- ✅ Firefox (latest)
- ✅ Edge (latest)
- ✅ Safari (latest)
- ✅ Mobile browsers

## 📱 Mobile Testing

**Option 1: Browser DevTools**
1. Press `F12` (or Right-click → Inspect)
2. Click device icon (toggle device toolbar)
3. Select mobile device or set custom width

**Option 2: Real Device**
1. Connect phone to same WiFi as computer
2. Find your computer's local IP (run `ipconfig` in terminal)
3. Visit: `http://[your-ip]:8000` (if using local server)
   OR use a service like ngrok to share your local server

## ✅ All Features Working?

If everything checks out, you're ready to customize with your own content!

---

**Need help?** Check the Editing Guide at the bottom of `index.html` or see `README.md` for customization instructions.


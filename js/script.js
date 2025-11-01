/* ============================================
   🎨 PORTFOLIO JAVASCRIPT
   ============================================
   
   This file handles all interactive features:
   - Dark mode toggle
   - Mobile menu toggle
   - Smooth scrolling
   - Lightbox gallery
   - Form validation
   - Testimonials carousel
   - Back to top button
   - Scroll animations
   
   ============================================ */

// ============================================
// DOM ELEMENTS
// ============================================
const themeToggle = document.getElementById('themeToggle');
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');
const navLinks = document.querySelectorAll('.nav-link');
const backToTop = document.getElementById('backToTop');
const contactForm = document.getElementById('contactForm');
const lightbox = document.getElementById('lightbox');
const lightboxClose = document.getElementById('lightboxClose');
const lightboxImage = document.getElementById('lightboxImage');
const lightboxTitle = document.getElementById('lightboxTitle');
const lightboxDescription = document.getElementById('lightboxDescription');
const lightboxPrev = document.getElementById('lightboxPrev');
const lightboxNext = document.getElementById('lightboxNext');
const galleryItems = document.querySelectorAll('.gallery-item');
const testimonialSlides = document.querySelectorAll('.testimonial-slide');
const testimonialButtons = document.querySelectorAll('.testimonial-btn');

// ============================================
// INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    initializeTheme();
    initializeYear();
    initializeScrollAnimations();
    initializeLazyLoading();
    initializeImageErrorHandling();
});

// ============================================
// DARK MODE TOGGLE
// ============================================
function initializeTheme() {
    // Check for saved theme preference or default to light mode
    const savedTheme = localStorage.getItem('theme') || 'light';
    const html = document.documentElement;
    
    if (savedTheme === 'dark') {
        html.setAttribute('data-theme', 'dark');
        themeToggle.querySelector('.theme-icon').textContent = '☀️';
    } else {
        html.setAttribute('data-theme', 'light');
        themeToggle.querySelector('.theme-icon').textContent = '🌙';
    }
    
    // Toggle theme on button click
    themeToggle.addEventListener('click', () => {
        const currentTheme = html.getAttribute('data-theme');
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        
        html.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        
        // Update icon
        themeToggle.querySelector('.theme-icon').textContent = 
            newTheme === 'dark' ? '☀️' : '🌙';
    });
}

// ============================================
// MOBILE MENU TOGGLE
// ============================================
menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
    menuToggle.classList.toggle('active');
});

// Close menu when clicking on a link
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        navMenu.classList.remove('active');
        menuToggle.classList.remove('active');
    });
});

// Close menu when clicking outside
document.addEventListener('click', (e) => {
    if (!navMenu.contains(e.target) && !menuToggle.contains(e.target)) {
        navMenu.classList.remove('active');
        menuToggle.classList.remove('active');
    }
});

// ============================================
// SMOOTH SCROLLING FOR ANCHOR LINKS
// ============================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        
        // Skip empty hash
        if (href === '#' || href === '#!') {
            e.preventDefault();
            return;
        }
        
        const target = document.querySelector(href);
        
        if (target) {
            e.preventDefault();
            const navHeight = document.querySelector('.navbar').offsetHeight;
            const targetPosition = target.offsetTop - navHeight;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// ============================================
// NAVBAR SCROLL EFFECT
// ============================================
let lastScroll = 0;
const navbar = document.getElementById('navbar');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    // Add shadow on scroll
    if (currentScroll > 50) {
        navbar.style.boxShadow = '0 4px 6px -1px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.boxShadow = '0 1px 2px 0 rgba(0, 0, 0, 0.05)';
    }
    
    lastScroll = currentScroll;
    
    // Show/hide back to top button
    if (currentScroll > 300) {
        backToTop.classList.add('visible');
    } else {
        backToTop.classList.remove('visible');
    }
});

// ============================================
// BACK TO TOP BUTTON
// ============================================
backToTop.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});

// ============================================
// LIGHTBOX GALLERY
// ============================================
let currentImageIndex = 0;
const galleryImages = Array.from(galleryItems);

// Open lightbox when clicking gallery item
galleryItems.forEach((item, index) => {
    item.addEventListener('click', () => {
        openLightbox(index);
    });
});

function openLightbox(index) {
    currentImageIndex = index;
    const item = galleryItems[index];
    const img = item.querySelector('img');
    const title = item.getAttribute('data-title');
    const description = item.getAttribute('data-description');
    
    lightboxImage.src = img.src.replace('800/600', '1600/1200'); // Use larger image
    lightboxImage.alt = img.alt;
    lightboxTitle.textContent = title || '';
    lightboxDescription.textContent = description || '';
    
    lightbox.classList.add('active');
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
    
    updateLightboxNavigation();
}

function closeLightbox() {
    lightbox.classList.remove('active');
    document.body.style.overflow = ''; // Restore scrolling
}

function showNextImage() {
    currentImageIndex = (currentImageIndex + 1) % galleryImages.length;
    openLightbox(currentImageIndex);
}

function showPrevImage() {
    currentImageIndex = (currentImageIndex - 1 + galleryImages.length) % galleryImages.length;
    openLightbox(currentImageIndex);
}

function updateLightboxNavigation() {
    // Update prev/next button visibility if needed
    if (galleryImages.length <= 1) {
        lightboxPrev.style.display = 'none';
        lightboxNext.style.display = 'none';
    } else {
        lightboxPrev.style.display = 'flex';
        lightboxNext.style.display = 'flex';
    }
}

// Lightbox event listeners
lightboxClose.addEventListener('click', closeLightbox);
lightboxNext.addEventListener('click', showNextImage);
lightboxPrev.addEventListener('click', showPrevImage);

// Close lightbox on overlay click
lightbox.addEventListener('click', (e) => {
    if (e.target === lightbox) {
        closeLightbox();
    }
});

// Keyboard navigation
document.addEventListener('keydown', (e) => {
    if (lightbox.classList.contains('active')) {
        if (e.key === 'Escape') {
            closeLightbox();
        } else if (e.key === 'ArrowRight') {
            showNextImage();
        } else if (e.key === 'ArrowLeft') {
            showPrevImage();
        }
    }
});

// ============================================
// CONTACT FORM VALIDATION
// ============================================
contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const message = document.getElementById('message').value.trim();
    
    let isValid = true;
    
    // Reset error messages
    clearErrors();
    
    // Validate name
    if (name === '') {
        showError('name', 'Name is required');
        isValid = false;
    } else if (name.length < 2) {
        showError('name', 'Name must be at least 2 characters');
        isValid = false;
    }
    
    // Validate email
    if (email === '') {
        showError('email', 'Email is required');
        isValid = false;
    } else if (!isValidEmail(email)) {
        showError('email', 'Please enter a valid email address');
        isValid = false;
    }
    
    // Validate message
    if (message === '') {
        showError('message', 'Message is required');
        isValid = false;
    } else if (message.length < 10) {
        showError('message', 'Message must be at least 10 characters');
        isValid = false;
    }
    
    // If valid, show success message (you can replace this with actual form submission)
    if (isValid) {
        showSuccessMessage();
        contactForm.reset();
    }
});

function showError(fieldId, message) {
    const errorElement = document.getElementById(`${fieldId}Error`);
    if (errorElement) {
        errorElement.textContent = message;
    }
    
    const input = document.getElementById(fieldId);
    if (input) {
        input.style.borderColor = '#ef4444';
    }
}

function clearErrors() {
    document.querySelectorAll('.error-message').forEach(error => {
        error.textContent = '';
    });
    
    document.querySelectorAll('.form-group input, .form-group textarea').forEach(input => {
        input.style.borderColor = '';
    });
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function showSuccessMessage() {
    // Create a temporary success message
    const successDiv = document.createElement('div');
    successDiv.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        background-color: #10b981;
        color: white;
        padding: 1rem 2rem;
        border-radius: 8px;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        z-index: 3000;
        animation: slideIn 0.3s ease;
    `;
    successDiv.textContent = 'Message sent successfully!';
    
    document.body.appendChild(successDiv);
    
    // Remove after 3 seconds
    setTimeout(() => {
        successDiv.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            document.body.removeChild(successDiv);
        }, 300);
    }, 3000);
}

// Add CSS for success message animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// ============================================
// TESTIMONIALS CAROUSEL
// ============================================
let currentTestimonial = 0;
let testimonialInterval;

function showTestimonial(index) {
    testimonialSlides.forEach((slide, i) => {
        slide.classList.toggle('active', i === index);
    });
    
    testimonialButtons.forEach((btn, i) => {
        btn.classList.toggle('active', i === index);
    });
    
    currentTestimonial = index;
}

function nextTestimonial() {
    const next = (currentTestimonial + 1) % testimonialSlides.length;
    showTestimonial(next);
}

function startTestimonialCarousel() {
    // Auto-advance testimonials every 5 seconds
    testimonialInterval = setInterval(nextTestimonial, 5000);
}

function stopTestimonialCarousel() {
    if (testimonialInterval) {
        clearInterval(testimonialInterval);
    }
}

// Manual testimonial navigation
testimonialButtons.forEach((btn, index) => {
    btn.addEventListener('click', () => {
        stopTestimonialCarousel();
        showTestimonial(index);
        startTestimonialCarousel();
    });
});

// Pause on hover
const testimonialsSection = document.querySelector('.testimonials-carousel');
if (testimonialsSection) {
    testimonialsSection.addEventListener('mouseenter', stopTestimonialCarousel);
    testimonialsSection.addEventListener('mouseleave', startTestimonialCarousel);
}

// Initialize testimonials
if (testimonialSlides.length > 0) {
    showTestimonial(0);
    startTestimonialCarousel();
}

// ============================================
// SCROLL ANIMATIONS
// ============================================
function initializeScrollAnimations() {
    // Check if IntersectionObserver is supported
    if (!('IntersectionObserver' in window)) {
        // Fallback: Make all sections visible immediately
        document.querySelectorAll('section').forEach(section => {
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        });
        return;
    }
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                // Ensure element is visible
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Add fade-in-on-scroll to sections (but keep them visible by default)
    document.querySelectorAll('section').forEach((section, index) => {
        // Hero section (#home) should always be visible
        if (section.id === 'home') {
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
            return;
        }
        
        section.classList.add('fade-in-on-scroll');
        observer.observe(section);
        
        // Check if section is already in viewport on page load
        const rect = section.getBoundingClientRect();
        const isInViewport = rect.top < window.innerHeight && rect.bottom > 0;
        
        if (isInViewport) {
            // Section is visible on load, make it visible immediately
            section.classList.add('visible');
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }
    });
    
    // Observe elements with fade-in-on-scroll class
    document.querySelectorAll('.fade-in-on-scroll').forEach(el => {
        observer.observe(el);
    });
}

// ============================================
// LAZY LOADING FOR IMAGES
// ============================================
function initializeLazyLoading() {
    // Check if browser supports Intersection Observer
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                        imageObserver.unobserve(img);
                    }
                }
            });
        });
        
        // Observe images with data-src attribute
        document.querySelectorAll('img[data-src]').forEach(img => {
            imageObserver.observe(img);
        });
    }
}

// ============================================
// AUTO-UPDATE YEAR IN FOOTER
// ============================================
function initializeYear() {
    const yearElement = document.getElementById('currentYear');
    if (yearElement) {
        yearElement.textContent = new Date().getFullYear();
    }
}

// ============================================
// ACTIVE NAV LINK ON SCROLL
// ============================================
window.addEventListener('scroll', () => {
    const sections = document.querySelectorAll('section[id]');
    const scrollY = window.pageYOffset;
    const navHeight = navbar.offsetHeight;
    
    sections.forEach(section => {
        const sectionHeight = section.offsetHeight;
        const sectionTop = section.offsetTop - navHeight - 100;
        const sectionId = section.getAttribute('id');
        
        if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${sectionId}`) {
                    link.classList.add('active');
                }
            });
        }
    });
});

// ============================================
// PERFORMANCE OPTIMIZATION
// ============================================
// Throttle scroll events for better performance
function throttle(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Apply throttling to scroll events if needed
// window.addEventListener('scroll', throttle(handleScroll, 100));

// ============================================
// IMAGE ERROR HANDLING
// ============================================
function initializeImageErrorHandling() {
    // Handle images that fail to load
    const images = document.querySelectorAll('img');
    
    images.forEach(img => {
        // If image fails to load, show a placeholder or hide gracefully
        img.addEventListener('error', function() {
            // Create a placeholder SVG data URI
            const placeholder = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="400" height="300"%3E%3Crect fill="%23e5e7eb" width="400" height="300"/%3E%3Ctext fill="%239ca3af" font-family="sans-serif" font-size="18" dy="10.5" font-weight="bold" x="50%25" y="50%25" text-anchor="middle"%3EImage Placeholder%3C/text%3E%3C/svg%3E';
            
            // For gallery images, use a gradient placeholder
            if (this.closest('.gallery-item') || this.classList.contains('gallery-item')) {
                this.style.background = 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%)';
                this.style.display = 'flex';
                this.style.alignItems = 'center';
                this.style.justifyContent = 'center';
                this.style.minHeight = '300px';
                this.alt = 'Image failed to load';
            } else {
                this.src = placeholder;
            }
        });
        
        // Add loading placeholder for better UX
        if (!img.complete) {
            img.style.opacity = '0.7';
            img.style.transition = 'opacity 0.3s ease';
            
            img.addEventListener('load', function() {
                this.style.opacity = '1';
            });
        }
    });
}


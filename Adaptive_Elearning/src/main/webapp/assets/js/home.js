// Home Page Optimized JavaScript

// Cart functionality
class CartManager {
    constructor() {
        this.cartIcon = document.querySelector('.cart-icon');
        this.cartBadge = document.querySelector('.cart-badge');
        this.init();
    }

    init() {
        this.updateCartBadge();
        this.bindEvents();
    }

    bindEvents() {
        // Handle both cart button and card click in one listener
        document.addEventListener('click', (e) => {
            // Check if clicking on add to cart button first
            const addToCartBtn = e.target.closest('.add-to-cart-btn');
            if (addToCartBtn) {
                e.preventDefault();
                e.stopPropagation();
                this.handleAddToCart(addToCartBtn);
                return;
            }

            // Check if clicking on enroll button or any link
            if (e.target.closest('.enroll-btn, a')) {
                return; // Let default behavior happen
            }

            // Then check for course card click
            const courseCard = e.target.closest('.course-card');
            if (courseCard && courseCard.hasAttribute('data-course-id')) {
                const courseId = courseCard.getAttribute('data-course-id');
                window.location.href = `/Adaptive_Elearning/detail?id=${courseId}`;
            }
        });
    }

    async handleAddToCart(button) {
        const courseId = button.getAttribute('data-course-id');
        
        // Prevent multiple clicks
        if (button.classList.contains('loading')) return;
        
        button.classList.add('loading');
        const originalText = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';

        try {
            const response = await fetch('/Adaptive_Elearning/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=add&courseId=${courseId}`
            });

            const result = await response.json();

            if (result.success) {
                this.showNotification('Đã thêm khóa học vào giỏ hàng!', 'success');
                button.classList.add('added');
                button.innerHTML = '<i class="fas fa-check"></i> Đã thêm';
                this.updateCartBadge();
                
                setTimeout(() => {
                    button.classList.remove('added');
                    button.innerHTML = originalText;
                }, 2000);
            } else {
                this.showNotification(result.message || 'Có lỗi xảy ra!', 'error');
            }
        } catch (error) {
            console.error('Error adding to cart:', error);
            this.showNotification('Có lỗi xảy ra khi thêm vào giỏ hàng!', 'error');
        } finally {
            button.classList.remove('loading');
            if (!button.classList.contains('added')) {
                button.innerHTML = originalText;
            }
        }
    }

    async updateCartBadge() {
        try {
            const response = await fetch('/Adaptive_Elearning/cart?action=count');
            const result = await response.json();
            
            if (result.success && result.cartCount !== undefined) {
                if (result.cartCount > 0) {
                    this.cartBadge.textContent = result.cartCount;
                    this.cartBadge.style.display = 'flex';
                } else {
                    this.cartBadge.style.display = 'none';
                }
            } else {
                this.cartBadge.style.display = 'none';
            }
        } catch (error) {
            console.error('Error updating cart badge:', error);
        }
    }

    showNotification(message, type = 'info') {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(n => n.remove());

        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        
        const iconMap = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };

        notification.innerHTML = `
            <div class="notification-content">
                <i class="${iconMap[type] || iconMap.info}"></i>
                <span>${message}</span>
                <button class="notification-close">&times;</button>
            </div>
        `;

        document.body.appendChild(notification);

        // Auto remove after 3 seconds
        setTimeout(() => {
            notification.remove();
        }, 3000);

        // Close button
        notification.querySelector('.notification-close').addEventListener('click', () => {
            notification.remove();
        });
    }
}

// Lazy loading for images
class LazyImageLoader {
    constructor() {
        this.images = document.querySelectorAll('img[data-src]');
        this.init();
    }

    init() {
        if ('IntersectionObserver' in window) {
            this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
                threshold: 0.1,
                rootMargin: '50px'
            });
            this.images.forEach(img => this.observer.observe(img));
        } else {
            // Fallback for browsers without IntersectionObserver
            this.images.forEach(this.loadImage);
        }
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.loadImage(entry.target);
                this.observer.unobserve(entry.target);
            }
        });
    }

    loadImage(img) {
        if (img.dataset.src) {
            img.src = img.dataset.src;
            img.classList.add('loaded');
            
            // Add loading animation
            img.addEventListener('load', () => {
                img.style.opacity = '1';
            });
        }
    }
}

// Course card animations
class CourseAnimations {
    constructor() {
        this.cards = document.querySelectorAll('.course-card');
        this.init();
    }

    init() {
        this.observeCards();
    }

    observeCards() {
        if ('IntersectionObserver' in window) {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach((entry, index) => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            entry.target.classList.add('loaded');
                        }, index * 100); // Stagger animation
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });

            this.cards.forEach(card => {
                observer.observe(card);
            });
        } else {
            // Fallback: show all cards immediately
            this.cards.forEach(card => {
                card.classList.add('loaded');
            });
        }
    }
}

// Smooth scrolling for navigation links
class SmoothScroll {
    constructor() {
        this.init();
    }

    init() {
        document.addEventListener('click', (e) => {
            if (e.target.matches('a[href^="#"]')) {
                e.preventDefault();
                const target = document.querySelector(e.target.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    }
}

// Search functionality enhancement
class SearchManager {
    constructor() {
        this.searchForm = document.querySelector('.search-form');
        this.searchInput = document.querySelector('.search-input');
        this.init();
    }

    init() {
        this.bindEvents();
    }

    bindEvents() {
        if (this.searchForm) {
            this.searchForm.addEventListener('submit', this.handleSearch.bind(this));
        }

        if (this.searchInput) {
            // Auto-focus on search input when pressing '/' key
            document.addEventListener('keydown', (e) => {
                if (e.key === '/' && !e.target.matches('input, textarea')) {
                    e.preventDefault();
                    this.searchInput.focus();
                }
            });
        }
    }

    handleSearch(e) {
        const query = this.searchInput.value.trim();
        
        if (!query) {
            e.preventDefault();
            this.showSearchError('Vui lòng nhập từ khóa tìm kiếm');
            return;
        }

        // Let the form submit naturally
    }

    showSearchError(message) {
        // Create temporary error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'search-error';
        errorDiv.textContent = message;
        errorDiv.style.cssText = `
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #fef2f2;
            color: #dc2626;
            padding: 0.5rem 1rem;
            border-radius: 0 0 0.5rem 0.5rem;
            font-size: 0.875rem;
            border: 1px solid #fecaca;
            border-top: none;
            z-index: 10;
        `;

        this.searchForm.style.position = 'relative';
        this.searchForm.appendChild(errorDiv);

        setTimeout(() => {
            errorDiv.remove();
        }, 3000);
    }
}

// User Dropdown Menu Manager
class UserDropdownManager {
    constructor() {
        this.dropdown = document.querySelector('.user-dropdown');
        this.menuBtn = document.querySelector('.user-menu-btn');
        this.dropdownMenu = document.querySelector('.dropdown-menu');
        this.init();
    }

    init() {
        if (this.dropdown && this.menuBtn) {
            this.bindEvents();
        }
    }

    bindEvents() {
        // Toggle dropdown on button click
        this.menuBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            this.toggleDropdown();
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (!this.dropdown.contains(e.target)) {
                this.closeDropdown();
            }
        });

        // Close dropdown on escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeDropdown();
            }
        });

        // Handle dropdown item clicks
        if (this.dropdownMenu) {
            this.dropdownMenu.addEventListener('click', (e) => {
                const item = e.target.closest('.dropdown-item');
                if (item && item.href) {
                    // Add loading state for navigation
                    item.style.opacity = '0.7';
                    setTimeout(() => {
                        if (item.style) item.style.opacity = '1';
                    }, 1000);
                }
            });
        }
    }

    toggleDropdown() {
        const isActive = this.dropdown.classList.contains('active');
        if (isActive) {
            this.closeDropdown();
        } else {
            this.openDropdown();
        }
    }

    openDropdown() {
        this.dropdown.classList.add('active');
        
        // Add focus trap
        this.trapFocus();
        
        // Animate menu items
        this.animateMenuItems();
    }

    closeDropdown() {
        this.dropdown.classList.remove('active');
    }

    trapFocus() {
        const focusableElements = this.dropdownMenu.querySelectorAll(
            'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])'
        );
        
        if (focusableElements.length > 0) {
            focusableElements[0].focus();
        }
    }

    animateMenuItems() {
        const items = this.dropdownMenu.querySelectorAll('.dropdown-item');
        items.forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(-10px)';
            setTimeout(() => {
                item.style.transition = 'opacity 0.2s ease, transform 0.2s ease';
                item.style.opacity = '1';
                item.style.transform = 'translateX(0)';
            }, index * 50);
        });
    }
}

// Performance monitoring (development only)
class PerformanceMonitor {
    constructor() {
        this.init();
    }

    init() {
        if (window.location.hostname !== 'localhost') return;

        // Monitor page load time
        window.addEventListener('load', () => {
            const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
            console.log(`📊 Page loaded in ${loadTime}ms`);
            
            // Monitor LCP (Largest Contentful Paint)
            if ('PerformanceObserver' in window) {
                const observer = new PerformanceObserver((list) => {
                    const entries = list.getEntries();
                    const lastEntry = entries[entries.length - 1];
                    console.log(`🎯 LCP: ${lastEntry.startTime}ms`);
                });
                observer.observe({ entryTypes: ['largest-contentful-paint'] });
            }
        });

        // Monitor cart operations
        this.monitorFetchRequests();
    }

    monitorFetchRequests() {
        const originalFetch = window.fetch;
        window.fetch = function(...args) {
            const start = performance.now();
            return originalFetch.apply(this, args).then(response => {
                const end = performance.now();
                console.log(`🌐 Fetch request took ${(end - start).toFixed(2)}ms`);
                return response;
            });
        };
    }
}

// Error handling
window.addEventListener('error', (e) => {
    console.error('JavaScript Error:', e.error);
    // In production, you might want to send this to an error tracking service
});

// Initialize all components when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    try {
        // Initialize cart manager
        window.cartManager = new CartManager();
        
        // Initialize user dropdown
        window.userDropdown = new UserDropdownManager();
        
        // Initialize lazy loading
        window.lazyLoader = new LazyImageLoader();
        
        // Initialize animations
        window.courseAnimations = new CourseAnimations();
        
        // Initialize smooth scrolling
        window.smoothScroll = new SmoothScroll();
        
        // Initialize search
        window.searchManager = new SearchManager();
        
        // Initialize performance monitoring in development
        if (window.location.hostname === 'localhost') {
            window.performanceMonitor = new PerformanceMonitor();
        }

        console.log('✅ Home page initialized successfully');
    } catch (error) {
        console.error('❌ Error initializing home page:', error);
    }
});

// Expose for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        CartManager,
        UserDropdownManager,
        LazyImageLoader,
        CourseAnimations,
        SmoothScroll,
        SearchManager,
        PerformanceMonitor
    };
}
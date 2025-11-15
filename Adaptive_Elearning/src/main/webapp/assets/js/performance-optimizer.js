/**
 * Performance Optimizer for Dashboard
 */

class PerformanceOptimizer {
    constructor() {
        this.init();
    }

    init() {
        this.optimizeImages();
        this.enableLazyLoading();
        this.prefetchCriticalResources();
        this.optimizeAnimations();
    }

    optimizeImages() {
        // Lazy load images
        const images = document.querySelectorAll('img[data-src]');
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));
    }

    enableLazyLoading() {
        // Lazy load heavy components
        const lazyElements = document.querySelectorAll('[data-lazy]');
        const elementObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const element = entry.target;
                    const componentName = element.dataset.lazy;
                    this.loadComponent(componentName, element);
                    elementObserver.unobserve(element);
                }
            });
        }, { threshold: 0.1 });

        lazyElements.forEach(el => elementObserver.observe(el));
    }

    loadComponent(componentName, element) {
        switch(componentName) {
            case 'chart':
                this.loadChart(element);
                break;
            case 'table':
                this.loadTable(element);
                break;
            case 'activity':
                this.loadActivity(element);
                break;
        }
    }

    loadChart(element) {
        // Simulate chart loading
        element.innerHTML = '<canvas id="dynamicChart"></canvas>';
        // Initialize chart here
    }

    loadTable(element) {
        // Load table data asynchronously
        setTimeout(() => {
            if (typeof populateCourseTable === 'function') {
                populateCourseTable();
            }
        }, 100);
    }

    loadActivity(element) {
        // Load recent activity
        element.innerHTML = `
            <div class="activity-item">
                <i class="fas fa-user-plus text-success"></i>
                <span>Học viên mới đăng ký khóa học React</span>
                <small>2 phút trước</small>
            </div>
            <div class="activity-item">
                <i class="fas fa-comment text-info"></i>
                <span>Bình luận mới trong thảo luận</span>
                <small>5 phút trước</small>
            </div>
        `;
    }

    prefetchCriticalResources() {
        // Prefetch critical CSS
        const criticalCSS = [
            '/Adaptive_Elearning/assets/css/instructor-dashboard-modern.css'
        ];

        criticalCSS.forEach(href => {
            const link = document.createElement('link');
            link.rel = 'prefetch';
            link.href = href;
            document.head.appendChild(link);
        });
    }

    optimizeAnimations() {
        // Reduce animations on low-end devices
        if (this.isLowEndDevice()) {
            document.body.classList.add('reduced-motion');
        }

        // Use CSS containment for better performance
        const containers = document.querySelectorAll('.stat-card, .chart-container, .sidebar');
        containers.forEach(container => {
            container.style.contain = 'layout style paint';
        });
    }

    isLowEndDevice() {
        // Detect low-end devices
        const connection = navigator.connection || navigator.mozConnection || navigator.webkitConnection;
        const cores = navigator.hardwareConcurrency || 1;
        const memory = navigator.deviceMemory || 1;

        return (
            cores <= 2 ||
            memory <= 2 ||
            (connection && connection.effectiveType && connection.effectiveType.includes('2g'))
        );
    }

    // Debounce function for performance
    static debounce(func, wait) {
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

    // Throttle function for scroll events
    static throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
}

// Initialize performance optimizer
document.addEventListener('DOMContentLoaded', () => {
    new PerformanceOptimizer();
});

// Export for use in other modules
window.PerformanceOptimizer = PerformanceOptimizer;
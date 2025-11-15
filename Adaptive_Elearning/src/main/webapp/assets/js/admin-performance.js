/**
 * Admin Performance Optimization JavaScript
 * Tối ưu performance cho admin panel
 * Author: AI Assistant
 * Date: Nov 1, 2025
 */

(function() {
    'use strict';

    // ========================================
    // PERFORMANCE MODE TOGGLE
    // ========================================
    
    const AdminPerformance = {
        // Check if user prefers reduced motion
        prefersReducedMotion: window.matchMedia('(prefers-reduced-motion: reduce)').matches,
        
        // Check device capabilities
        isLowEndDevice: function() {
            // Check RAM (if available)
            const memory = navigator.deviceMemory;
            if (memory && memory < 4) return true;
            
            // Check CPU cores
            const cores = navigator.hardwareConcurrency;
            if (cores && cores < 4) return true;
            
            return false;
        },
        
        // Initialize performance mode
        init: function() {
            // Auto-enable performance mode for low-end devices
            if (this.isLowEndDevice() || this.prefersReducedMotion) {
                this.enablePerformanceMode();
            }
            
            // Load saved preference
            const savedMode = localStorage.getItem('admin_performance_mode');
            if (savedMode === 'true') {
                this.enablePerformanceMode();
            }
            
            // Add toggle button
            this.addToggleButton();
            
            // Optimize on load
            this.optimizeOnLoad();
        },
        
        // Enable performance mode
        enablePerformanceMode: function() {
            document.body.classList.add('performance-mode');
            localStorage.setItem('admin_performance_mode', 'true');
            
            // Disable particle effects
            this.disableParticleEffects();
            
            // Optimize tables
            this.optimizeTables();
            
            console.log('⚡ Performance mode enabled');
        },
        
        // Disable performance mode
        disablePerformanceMode: function() {
            document.body.classList.remove('performance-mode');
            localStorage.setItem('admin_performance_mode', 'false');
            console.log('✨ Standard mode enabled');
        },
        
        // Toggle performance mode
        toggle: function() {
            if (document.body.classList.contains('performance-mode')) {
                this.disablePerformanceMode();
            } else {
                this.enablePerformanceMode();
            }
        },
        
        // Add toggle button to UI
        addToggleButton: function() {
            const button = document.createElement('button');
            button.id = 'performance-toggle';
            button.className = 'performance-toggle-btn';
            button.innerHTML = '<i class="fas fa-bolt"></i>';
            button.title = 'Toggle Performance Mode';
            button.setAttribute('aria-label', 'Toggle Performance Mode');
            
            button.addEventListener('click', () => this.toggle());
            
            // Add styles
            const style = document.createElement('style');
            style.textContent = `
                .performance-toggle-btn {
                    position: fixed;
                    bottom: 20px;
                    right: 20px;
                    width: 50px;
                    height: 50px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    color: white;
                    font-size: 20px;
                    cursor: pointer;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                    z-index: 9999;
                    transition: transform 0.2s ease, box-shadow 0.2s ease;
                }
                .performance-toggle-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 16px rgba(0,0,0,0.3);
                }
                .performance-toggle-btn:active {
                    transform: translateY(0);
                }
                body.performance-mode .performance-toggle-btn {
                    background: #28a745;
                }
                @media (max-width: 768px) {
                    .performance-toggle-btn {
                        bottom: 15px;
                        right: 15px;
                        width: 45px;
                        height: 45px;
                        font-size: 18px;
                    }
                }
            `;
            
            document.head.appendChild(style);
            document.body.appendChild(button);
        },
        
        // Disable particle effects
        disableParticleEffects: function() {
            // Remove existing particles
            document.querySelectorAll('.particle, .ripple-effect, .click-effect').forEach(el => {
                el.remove();
            });
            
            // Prevent new particles from being created
            if (window.createParticle) {
                window.createParticle = function() { return null; };
            }
            if (window.addRippleEffect) {
                window.addRippleEffect = function() { return null; };
            }
        },
        
        // Optimize tables
        optimizeTables: function() {
            const tables = document.querySelectorAll('table');
            tables.forEach(table => {
                // Use CSS containment
                table.style.contain = 'layout style';
                
                // Disable hover transforms on rows
                const rows = table.querySelectorAll('tr');
                rows.forEach(row => {
                    row.addEventListener('mouseenter', function(e) {
                        e.target.style.transform = 'none';
                    });
                });
            });
        },
        
        // Optimize on page load
        optimizeOnLoad: function() {
            // Defer non-critical resources
            this.deferNonCriticalCSS();
            
            // Lazy load images
            this.lazyLoadImages();
            
            // Debounce resize events
            this.optimizeResizeEvents();
            
            // Optimize scroll events
            this.optimizeScrollEvents();
        },
        
        // Defer non-critical CSS
        deferNonCriticalCSS: function() {
            const links = document.querySelectorAll('link[rel="stylesheet"][data-defer]');
            links.forEach(link => {
                link.setAttribute('media', 'print');
                link.onload = function() {
                    this.media = 'all';
                };
            });
        },
        
        // Lazy load images
        lazyLoadImages: function() {
            if ('IntersectionObserver' in window) {
                const imageObserver = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const img = entry.target;
                            if (img.dataset.src) {
                                img.src = img.dataset.src;
                                img.removeAttribute('data-src');
                                observer.unobserve(img);
                            }
                        }
                    });
                }, {
                    rootMargin: '50px'
                });
                
                document.querySelectorAll('img[data-src]').forEach(img => {
                    imageObserver.observe(img);
                });
            } else {
                // Fallback for browsers without IntersectionObserver
                document.querySelectorAll('img[data-src]').forEach(img => {
                    img.src = img.dataset.src;
                });
            }
        },
        
        // Optimize resize events with debounce
        optimizeResizeEvents: function() {
            let resizeTimer;
            const originalResize = window.onresize;
            
            window.onresize = function(e) {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function() {
                    if (originalResize) originalResize(e);
                }, 250);
            };
        },
        
        // Optimize scroll events with throttle
        optimizeScrollEvents: function() {
            let isScrolling = false;
            const originalScroll = window.onscroll;
            
            window.addEventListener('scroll', function(e) {
                if (!isScrolling) {
                    window.requestAnimationFrame(function() {
                        if (originalScroll) originalScroll(e);
                        isScrolling = false;
                    });
                    isScrolling = true;
                }
            }, { passive: true });
        }
    };
    
    // ========================================
    // TABLE VIRTUALIZATION (for large tables)
    // ========================================
    
    const TableVirtualization = {
        init: function() {
            const largeTables = document.querySelectorAll('table tbody');
            largeTables.forEach(tbody => {
                const rows = tbody.querySelectorAll('tr');
                if (rows.length > 50) {
                    this.virtualize(tbody, rows);
                }
            });
        },
        
        virtualize: function(tbody, rows) {
            const rowHeight = 50; // Approximate row height
            const viewportHeight = window.innerHeight;
            const visibleRows = Math.ceil(viewportHeight / rowHeight) + 5; // Buffer
            
            let currentIndex = 0;
            
            // Hide rows initially
            rows.forEach((row, index) => {
                if (index > visibleRows) {
                    row.style.display = 'none';
                }
            });
            
            // Show rows on scroll
            const table = tbody.closest('table');
            const container = table.parentElement;
            
            container.addEventListener('scroll', () => {
                const scrollTop = container.scrollTop;
                const startIndex = Math.floor(scrollTop / rowHeight);
                const endIndex = startIndex + visibleRows;
                
                rows.forEach((row, index) => {
                    if (index >= startIndex && index <= endIndex) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }, { passive: true });
        }
    };
    
    // ========================================
    // INITIALIZE ON DOM READY
    // ========================================
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            AdminPerformance.init();
            TableVirtualization.init();
        });
    } else {
        AdminPerformance.init();
        TableVirtualization.init();
    }
    
    // Make it globally accessible
    window.AdminPerformance = AdminPerformance;
    
    // Log performance info
    console.log('🚀 Admin Performance Optimizer loaded');
    console.log('Device RAM:', navigator.deviceMemory, 'GB');
    console.log('CPU Cores:', navigator.hardwareConcurrency);
    console.log('Reduced Motion:', window.matchMedia('(prefers-reduced-motion: reduce)').matches);

})();

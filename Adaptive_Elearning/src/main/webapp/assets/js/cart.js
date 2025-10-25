/**
 * JavaScript for Add to Cart functionality
 * Handles AJAX requests and UI updates for shopping cart
 */

// Cart management object
const CartManager = {
    // Add course to cart
    addToCart: function(courseId, buttonElement) {
        // Disable button to prevent double clicks
        if (buttonElement) {
            buttonElement.disabled = true;
            buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';
        }
        
        // Send AJAX request
        fetch('/Adaptive_Elearning/add-to-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'courseId=' + encodeURIComponent(courseId)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Show success message
                this.showNotification(data.message, 'success');
                
                // Update cart counter in navbar
                this.updateCartCounter(data.cartItemCount);
                
                // Update button state to "Added to Cart"
                if (buttonElement) {
                    buttonElement.innerHTML = '<i class="fas fa-check"></i> Đã thêm vào giỏ hàng';
                    buttonElement.classList.remove('btn-primary');
                    buttonElement.classList.add('btn-success');
                    buttonElement.disabled = true;
                }
                
                // Optionally show mini cart preview
                this.showMiniCartPreview(data.course);
                
            } else {
                // Show error message
                this.showNotification(data.message, 'error');
                
                // Check if need to redirect to login
                if (data.redirect) {
                    setTimeout(() => {
                        window.location.href = data.redirect;
                    }, 2000);
                }
                
                // Re-enable button
                if (buttonElement) {
                    buttonElement.disabled = false;
                    buttonElement.innerHTML = '<i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng';
                }
            }
        })
        .catch(error => {
            console.error('Error adding to cart:', error);
            this.showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
            
            // Re-enable button
            if (buttonElement) {
                buttonElement.disabled = false;
                buttonElement.innerHTML = '<i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng';
            }
        });
    },
    
    // Update cart counter in navigation
    updateCartCounter: function(count) {
        const cartCounter = document.querySelector('.cart-counter');
        const cartBadge = document.querySelector('.cart-badge');
        
        if (cartCounter) {
            cartCounter.textContent = count;
            cartCounter.style.display = count > 0 ? 'inline' : 'none';
        }
        
        if (cartBadge) {
            cartBadge.textContent = count;
            cartBadge.style.display = count > 0 ? 'inline' : 'none';
        }
    },
    
    // Show notification message
    showNotification: function(message, type = 'info') {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.cart-notification');
        existingNotifications.forEach(notification => notification.remove());
        
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `cart-notification alert alert-${type === 'success' ? 'success' : 'danger'} alert-dismissible fade show`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            max-width: 500px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        `;
        
        notification.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        // Add to document
        document.body.appendChild(notification);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    },
    
    // Show mini cart preview (optional)
    showMiniCartPreview: function(course) {
        if (!course) return;
        
        const miniCart = document.createElement('div');
        miniCart.className = 'mini-cart-preview';
        miniCart.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 9998;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            min-width: 280px;
            border-left: 4px solid #28a745;
        `;
        
        miniCart.innerHTML = `
            <div class="d-flex align-items-start">
                <i class="fas fa-shopping-cart text-success me-2 mt-1"></i>
                <div class="flex-grow-1">
                    <small class="text-muted">Đã thêm vào giỏ hàng:</small>
                    <div class="fw-bold text-truncate">${course.title}</div>
                    <div class="text-success">${formatPrice(course.price)}</div>
                    <div class="mt-2">
                        <a href="/Adaptive_Elearning/cart" class="btn btn-sm btn-outline-primary">
                            Xem giỏ hàng
                        </a>
                    </div>
                </div>
                <button type="button" class="btn-close" onclick="this.parentElement.parentElement.remove()"></button>
            </div>
        `;
        
        document.body.appendChild(miniCart);
        
        // Auto remove after 8 seconds
        setTimeout(() => {
            if (miniCart.parentNode) {
                miniCart.remove();
            }
        }, 8000);
    },
    
    // Initialize cart counter on page load
    initializeCartCounter: function() {
        fetch('/Adaptive_Elearning/add-to-cart', {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.updateCartCounter(data.cartItemCount);
            }
        })
        .catch(error => {
            console.error('Error loading cart counter:', error);
        });
    }
};

// Utility function to format price
function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(price);
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize cart counter
    CartManager.initializeCartCounter();
    
    // Add event listeners to all "Add to Cart" buttons
    const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            const courseId = this.getAttribute('data-course-id');
            if (courseId) {
                CartManager.addToCart(courseId, this);
            } else {
                console.error('Course ID not found');
            }
        });
    });
});

// Export for global access
window.CartManager = CartManager;
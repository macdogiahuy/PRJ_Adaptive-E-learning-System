// Dashboard JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {

    // Add click functionality to cards
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.addEventListener('click', function() {
            const cardTitle = this.querySelector('h3').textContent;
            console.log(`Clicked on: ${cardTitle}`);

            // Add visual feedback
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = 'translateY(-5px)';
            }, 150);
        });
    });

    // Add hover effects to navigation items
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'translateX(5px)';
            }
        });

        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0)';
        });
    });

    // Animate chart bars on load
    const chartBars = document.querySelectorAll('.bar');
    chartBars.forEach((bar, index) => {
        setTimeout(() => {
            bar.style.animation = 'barGrow 1s ease forwards';
        }, index * 200);
    });

    // Add smooth scrolling for any internal links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Add loading animation for cards
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe all cards for scroll animations
    cards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});

// Add CSS animation for chart bars
const style = document.createElement('style');
style.textContent = `
    @keyframes barGrow {
        from {
            height: 0;
        }
        to {
            height: var(--bar-height);
        }
    }

    .bar {
        --bar-height: attr(data-height);
    }
`;
document.head.appendChild(style);
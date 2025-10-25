// course-detail.js - Modern UI interactions for course detail page

document.addEventListener('DOMContentLoaded', function() {
    // Buy button ripple effect
    const buyBtn = document.querySelector('.buy-btn');
    if (buyBtn) {
        buyBtn.addEventListener('click', function(e) {
            buyBtn.classList.add('clicked');
            setTimeout(() => buyBtn.classList.remove('clicked'), 300);
        });
    }
    // Smooth scroll for more courses
    const moreCourses = document.querySelector('.more-courses');
    if (moreCourses) {
        moreCourses.addEventListener('wheel', function(e) {
            if (e.deltaY !== 0) {
                e.preventDefault();
                moreCourses.scrollLeft += e.deltaY;
            }
        }, { passive: false });
    }
});
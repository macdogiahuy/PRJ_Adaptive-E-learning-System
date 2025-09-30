// ==============================
// Course Marketplace Functions
// ==============================

// Global state
let currentPage = 1;
let itemsPerPage = 8;

// Hiển thị trang
function showPage(page) {
    let cards = document.querySelectorAll(".course-card");
    let start = (page - 1) * itemsPerPage;
    let end = start + itemsPerPage;

    cards.forEach((card, index) => {
        card.style.display = (index >= start && index < end) ? "block" : "none";
    });

    document.querySelectorAll(".pagination a").forEach((btn, index) => {
        btn.classList.toggle("active", (index + 1) === page);
    });

    currentPage = page;
}

// Tìm kiếm khóa học
function searchCourses() {
    let keyword = document.getElementById("searchBox").value.toLowerCase();
    let cards = document.querySelectorAll(".course-card");

    cards.forEach(card => {
        let title = card.querySelector("h4").innerText.toLowerCase();
        let instructor = card.querySelector("p").innerText.toLowerCase();
        if (title.includes(keyword) || instructor.includes(keyword)) {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    });
}

// Sắp xếp khóa học
function sortCourses(type) {
    let container = document.querySelector(".course-grid");
    let cards = Array.from(container.querySelectorAll(".course-card"));

    cards.sort((a, b) => {
        if (type === "price") {
            let priceA = parseFloat(a.querySelector(".new-price").innerText.replace(/[^\d]/g, ""));
            let priceB = parseFloat(b.querySelector(".new-price").innerText.replace(/[^\d]/g, ""));
            return priceA - priceB;
        }
        if (type === "rating") {
            let ratingA = parseFloat(a.querySelector(".rating").innerText);
            let ratingB = parseFloat(b.querySelector(".rating").innerText);
            return ratingB - ratingA;
        }
        if (type === "newest") {
            let dateA = new Date(a.getAttribute("data-createdat"));
            let dateB = new Date(b.getAttribute("data-createdat"));
            return dateB - dateA;
        }
        if (type === "discount") {
            let oldA = a.querySelector(".old-price");
            let oldB = b.querySelector(".old-price");
            return (oldB ? 1 : 0) - (oldA ? 1 : 0);
        }
        return 0;
    });

    container.innerHTML = "";
    cards.forEach(card => container.appendChild(card));

    showPage(1);
}

// Hover effect
function enableHoverEffect() {
    document.querySelectorAll(".course-card").forEach(card => {
        card.addEventListener("mouseenter", () => {
            card.style.boxShadow = "0px 4px 12px rgba(0,0,0,0.3)";
        });
        card.addEventListener("mouseleave", () => {
            card.style.boxShadow = "0px 2px 5px rgba(0,0,0,0.1)";
        });
    });
}

// Lọc theo category
function filterByCategory(category) {
    let cards = document.querySelectorAll(".course-card");
    cards.forEach(card => {
        let cardCat = card.getAttribute("data-category");
        if (category === "All" || cardCat === category) {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    });
}

// Khởi tạo
document.addEventListener("DOMContentLoaded", () => {
    const searchBox = document.getElementById("searchBox");
    if (searchBox) {
        searchBox.addEventListener("keyup", searchCourses);
    }

    document.querySelectorAll(".sort-bar a").forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            let type = this.getAttribute("data-sort");
            sortCourses(type);
        });
    });

    document.querySelectorAll(".pagination a").forEach((btn, index) => {
        btn.addEventListener("click", (e) => {
            e.preventDefault();
            showPage(index + 1);
        });
    });

    document.querySelectorAll(".sidebar a").forEach(link => {
        link.addEventListener("click", function (e) {
            e.preventDefault();
            let cat = this.getAttribute("data-category");
            filterByCategory(cat);
        });
    });

    enableHoverEffect();
    showPage(1);
});

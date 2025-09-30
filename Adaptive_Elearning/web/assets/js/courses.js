/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", function () {
    console.log("Courses page loaded!");

    const searchInput = document.getElementById("courseSearch");
    const tableRows = document.querySelectorAll(".course-table tbody tr");

    if (searchInput) {
        searchInput.addEventListener("keyup", function () {
            const filter = searchInput.value.toLowerCase();
            tableRows.forEach(row => {
                const titleCell = row.querySelector("td:first-child a");
                if (titleCell && titleCell.textContent.toLowerCase().includes(filter)) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        });
    }

    // Fade-in animation for rows
    tableRows.forEach((row, index) => {
        row.style.opacity = 0;
        setTimeout(() => {
            row.style.transition = "opacity 0.5s ease";
            row.style.opacity = 1;
        }, index * 100);
    });
});


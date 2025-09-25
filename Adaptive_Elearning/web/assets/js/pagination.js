document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on a page with pagination-enabled table
    const table = document.querySelector('#reportedGroupsTable') || document.querySelector('table');

    if (!table) {
        console.log('No table found for pagination');
        return;
    }

    const itemsPerPage = 7; // Show 7 items per page
    const tbody = table.querySelector('tbody');
    if (!tbody) {
        console.log('No tbody found in table');
        return;
    }

    const rows = tbody.querySelectorAll('tr:not(.no-data)');
    if (rows.length === 0) {
        console.log('No data rows found for pagination');
        return;
    }

    const totalPages = Math.ceil(rows.length / itemsPerPage);

    // If there's only 1 page or no data, don't create pagination
    if (totalPages <= 1) {
        // Just show the info without pagination controls
        const paginationContainer = document.createElement('div');
        paginationContainer.className = 'pagination-container';
        table.parentNode.insertBefore(paginationContainer, table.nextSibling);

        const paginationInfo = document.createElement('div');
        paginationInfo.className = 'pagination-info';
        paginationInfo.textContent = `Showing 1 to ${rows.length} of ${rows.length} entries`;
        paginationContainer.appendChild(paginationInfo);
        return;
    }

    // Add data-page attribute to each row
    rows.forEach((row, index) => {
        const pageNumber = Math.floor(index / itemsPerPage) + 1;
        row.setAttribute('data-page', pageNumber);
    });

    // Create pagination container
    const paginationContainer = document.createElement('div');
    paginationContainer.className = 'pagination-container';
    table.parentNode.insertBefore(paginationContainer, table.nextSibling);

    // Create pagination info
    const paginationInfo = document.createElement('div');
    paginationInfo.className = 'pagination-info';

    // Create pagination
    const pagination = document.createElement('div');
    pagination.className = 'pagination';

    // Update pagination container
    paginationContainer.appendChild(paginationInfo);
    paginationContainer.appendChild(pagination);

    function updatePagination(currentPage) {
        // Update rows visibility
        rows.forEach(row => {
            if (row.getAttribute('data-page') === currentPage.toString()) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });

        // Update pagination info
        const startIndex = (currentPage - 1) * itemsPerPage + 1;
        const endIndex = Math.min(currentPage * itemsPerPage, rows.length);
        paginationInfo.textContent = `Showing ${startIndex} to ${endIndex} of ${rows.length} entries`;

        // Update pagination buttons
        pagination.innerHTML = '';
        
        // Previous button
        const prevButton = document.createElement('button');
        prevButton.className = `page-link prev ${currentPage === 1 ? 'disabled' : ''}`;
        prevButton.innerHTML = '←';
        prevButton.onclick = () => {
            if (currentPage > 1) {
                // Get current URL and update page parameter
                const url = new URL(window.location);
                url.searchParams.set('page', currentPage - 1);
                window.location.href = url.toString();
            }
        };
        pagination.appendChild(prevButton);

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            const pageButton = document.createElement('button');
            pageButton.className = 'page-link';
            if (i === currentPage) {
                pageButton.classList.add('active');
            }
            pageButton.textContent = i;
            pageButton.onclick = () => {
                // Get current URL and update page parameter
                const url = new URL(window.location);
                url.searchParams.set('page', i);
                window.location.href = url.toString();
            };
            pagination.appendChild(pageButton);
        }

        // Next button
        const nextButton = document.createElement('button');
        nextButton.className = `page-link next ${currentPage === totalPages ? 'disabled' : ''}`;
        nextButton.innerHTML = '→';
        nextButton.onclick = () => {
            if (currentPage < totalPages) {
                // Get current URL and update page parameter
                const url = new URL(window.location);
                url.searchParams.set('page', currentPage + 1);
                window.location.href = url.toString();
            }
        };
        pagination.appendChild(nextButton);
    }

    // Initialize pagination
    updatePagination(1);
});
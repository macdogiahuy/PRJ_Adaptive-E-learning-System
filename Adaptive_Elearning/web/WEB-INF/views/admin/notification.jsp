<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thông báo - Hệ thống Quản trị</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard_clean.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Enhanced Notification Page Styles */
        .notification-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }

        .notification-hero::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="2"/></svg>');
            opacity: 0.3;
        }

        .notification-hero h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .notification-hero p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin: 0;
        }

        .notification-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #8898aa;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
        }

        .modern-table-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .modern-table-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modern-table-header h3 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .table-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .modern-search {
            position: relative;
            display: flex;
            align-items: center;
        }

        .modern-search input {
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid rgba(255,255,255,0.2);
            border-radius: 25px;
            background: rgba(255,255,255,0.1);
            color: white;
            font-size: 0.9rem;
            width: 300px;
            transition: all 0.3s ease;
        }

        .modern-search input::placeholder {
            color: rgba(255,255,255,0.7);
        }

        .modern-search input:focus {
            outline: none;
            border-color: rgba(255,255,255,0.4);
            background: rgba(255,255,255,0.2);
        }

        .modern-search i {
            position: absolute;
            left: 1rem;
            color: rgba(255,255,255,0.8);
            z-index: 2;
        }

        .refresh-btn {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
        }

        .refresh-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        .notification-grid {
            display: grid;
            gap: 1.5rem;
            padding: 2rem;
        }

        .notification-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .notification-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .notification-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .notification-type {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: #495057;
        }

        .notification-type i {
            color: #667eea;
            font-size: 1.1rem;
        }

        .notification-status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-approved {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .status-dismissed {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .status-none {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }

        .status-pending {
            background: linear-gradient(135deg, #17a2b8 0%, #20c997 100%);
            color: white;
        }

        .notification-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .notification-field {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .field-label {
            font-size: 0.8rem;
            color: #8898aa;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .field-value {
            font-size: 0.95rem;
            color: #495057;
            font-weight: 500;
            word-break: break-all;
        }

        .notification-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: flex-end;
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-approve {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .btn-dismiss {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }

        .btn-dismiss:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .no-notifications {
            text-align: center;
            padding: 4rem 2rem;
            color: #8898aa;
        }

        .no-notifications i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .no-notifications h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: #495057;
        }

        .modern-pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            padding: 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-top: 2rem;
        }

        .page-numbers {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .pagination-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #e9ecef;
            background: white;
            color: #495057;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pagination-btn:hover:not(.disabled) {
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-2px);
        }

        .pagination-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }

        .pagination-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .pagination-info {
            color: #8898aa;
            font-weight: 500;
            margin: 0 1rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .notification-hero {
                padding: 1.5rem;
                text-align: center;
            }

            .notification-hero h1 {
                font-size: 2rem;
            }

            .notification-stats {
                grid-template-columns: 1fr;
            }

            .modern-search input {
                width: 250px;
            }

            .table-controls {
                flex-direction: column;
                gap: 1rem;
            }

            .notification-content {
                grid-template-columns: 1fr;
            }

            .notification-actions {
                justify-content: center;
            }

            .modern-pagination {
                flex-wrap: wrap;
                gap: 0.5rem;
            }
        }

        @media (max-width: 480px) {
            .notification-hero h1 {
                font-size: 1.5rem;
            }

            .modern-search input {
                width: 200px;
            }

            .notification-grid {
                padding: 1rem;
            }

            .notification-card {
                padding: 1rem;
            }

            .action-btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar - Kept exactly as original -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/accountmanagement" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Account Management</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/createadmin" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        <span>Create Admin</span>
                    </a>
                </li>
                  <li class="nav-item active">
                    <a href="${pageContext.request.contextPath}/notification" class="nav-link">
                        <i class="fas fa-bell"></i>
                        <span>Notification Management</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link active">
                        <i class="fas fa-flag"></i>
                        <span>Reported Groups</span>
                    </a>
                </li>

                <li class="nav-item ">
                    <a href="${pageContext.request.contextPath}/reportedcourse" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Reported Courses</span>
                    </a>
                </li>
                 <li class="nav-item ">
                    <a href="" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Leaner View</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Sign Out</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content - Redesigned -->
        <main class="main-content">
            <!-- Hero Section -->
            <div class="notification-hero">
                <h1><i class="fas fa-bell"></i> Notification Management</h1>
                <p>Perfect Notification Management Systems</p>
            </div>

            <!-- Statistics Cards -->
            <div class="notification-stats">
                <div class="stat-card">
                    <div class="stat-number">${totalNotifications}</div>
                    <div class="stat-label">Tổng số thông báo</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${pendingNotifications}</div>
                    <div class="stat-label">Chờ xử lý</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${approvedNotifications}</div>
                    <div class="stat-label">Đã duyệt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${dismissedNotifications}</div>
                    <div class="stat-label">Đã từ chối</div>
                </div>
            </div>

            <!-- Modern Table Container -->
            <div class="modern-table-container">
                <div class="modern-table-header">
                    <h3><i class="fas fa-list"></i> Danh sách Thông báo</h3>
                    <div class="table-controls">
                        <div class="modern-search">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Tìm kiếm thông báo..." class="search-input">
                        </div>
                        <button class="refresh-btn" onclick="refreshTable()">
                            <i class="fas fa-sync-alt"></i>
                            Làm mới
                        </button>
                    </div>
                </div>

                <div class="notification-grid">
                    <c:choose>
                        <c:when test="${not empty reportedGroups}">
                            <c:forEach var="group" items="${reportedGroups}">
                                <div class="notification-card">
                                    <div class="notification-header">
                                        <div class="notification-type">
                                            <i class="fas fa-tag"></i>
                                            <span>${group.type}</span>
                                        </div>
                                        <div class="notification-status ${group.status == 'Approved' ? 'status-approved' : group.status == 'Dismissed' ? 'status-dismissed' : group.status == 'None' ? 'status-none' : 'status-pending'}">
                                            <i class="fas fa-circle"></i>
                                            <c:choose>
                                                <c:when test="${group.status == 'Approved'}">Đã duyệt</c:when>
                                                <c:when test="${group.status == 'Dismissed'}">Đã từ chối</c:when>
                                                <c:when test="${group.status == 'None'}">Chờ xử lý</c:when>
                                                <c:otherwise>${group.status}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="notification-content">
                                        <div class="notification-field">
                                            <div class="field-label">Mã người tạo</div>
                                            <div class="field-value" title="${group.creatorId}">${group.creatorId}</div>
                                        </div>
                                        <div class="notification-field">
                                            <div class="field-label">Thời gian tạo</div>
                                            <div class="field-value">${group.creationTime}</div>
                                        </div>
                                    </div>

                                    <div class="notification-actions">
                                        <c:if test="${group.status == 'None'}">
                                            <button class="action-btn btn-approve" onclick="approveRequest('${group.id}')" title="Duyệt thông báo">
                                                <i class="fas fa-check"></i>
                                                Duyệt
                                            </button>
                                            <button class="action-btn btn-dismiss" onclick="dismissRequest('${group.id}')" title="Từ chối thông báo">
                                                <i class="fas fa-times"></i>
                                                Từ chối
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-notifications">
                                <i class="fas fa-inbox"></i>
                                <h3>Không có thông báo nào</h3>
                                <p>Hiện tại không có thông báo nào cần xử lý</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Modern Pagination -->
            <div class="modern-pagination">
                <button class="pagination-btn" onclick="changePage('prev')" id="prevBtn">
                    <i class="fas fa-chevron-left"></i>
                </button>
               
                <div class="page-numbers" id="pageNumbers">
                    <button class="pagination-btn active">1</button>
                    <button class="pagination-btn">2</button>
                    <button class="pagination-btn">3</button>
                </div>
                <button class="pagination-btn" onclick="changePage('next')" id="nextBtn">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const tableRows = document.querySelectorAll('#reportedGroupsTable tbody tr');

            tableRows.forEach(row => {
                if (row.classList.contains('no-data')) {
                    return; // Skip the "no data" row
                }

                const text = row.textContent.toLowerCase();
                const isVisible = text.includes(searchTerm);

                if (isVisible) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            // Update pagination info after search
            updatePaginationInfo();
        });

        // Function to update pagination info after search
        function updatePaginationInfo() {
            const visibleRows = document.querySelectorAll('#reportedGroupsTable tbody tr[data-page]:not([style*="display: none"])');
            const paginationInfo = document.querySelector('.pagination-info');

            if (paginationInfo && visibleRows.length > 0) {
                const currentPage = visibleRows[0].getAttribute('data-page');
                const startIndex = (parseInt(currentPage) - 1) * itemsPerPage + 1;
                const endIndex = Math.min(parseInt(currentPage) * itemsPerPage, visibleRows.length);
                paginationInfo.textContent = `Hiển thị ${startIndex} đến ${endIndex} của ${visibleRows.length} mục (đã lọc)`;
            }
        }

        // Sort table
        function sortTable(column) {
            const table = document.getElementById('reportedGroupsTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));

            rows.sort((a, b) => {
                const aText = a.cells[getColumnIndex(column)].textContent.trim();
                const bText = b.cells[getColumnIndex(column)].textContent.trim();

                if (column === 'creationTime') {
                    return new Date(aText) - new Date(bText);
                }

                return aText.localeCompare(bText);
            });

            rows.forEach(row => tbody.appendChild(row));
        }

        function getColumnIndex(column) {
            const headers = ['type', 'creatorId', 'creationTime', 'status', 'action'];
            return headers.indexOf(column);
        }

        // Copy to clipboard
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                showNotification('ID copied to clipboard!', 'success');
            }).catch(() => {
                showNotification('Failed to copy ID', 'error');
            });
        }

        // View details
        function viewDetails(id) {
            showNotification(`Viewing details for ID: ${id}`, 'info');
            // TODO: Implement view details functionality
        }

        // Approve request
        function approveRequest(id) {
            if (confirm('Are you sure you want to approve this request?')) {
                showNotification(`Request ${id} approved successfully!`, 'success');
                // TODO: Implement approve functionality
            }
        }

        // Dismiss request
        function dismissRequest(id) {
            if (confirm('Are you sure you want to dismiss this request?')) {
                showNotification(`Request ${id} dismissed successfully!`, 'warning');
                // TODO: Implement dismiss functionality
            }
        }

        // Refresh table
        function refreshTable() {
            showNotification('Table refreshed!', 'info');
            location.reload(); // Reload page to refresh data
        }

        // Show notification
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `notification notification-${type}`;
            notification.textContent = message;

            document.body.appendChild(notification);

            setTimeout(() => {
                notification.remove();
            }, 3000);
        }

        // Pagination variables
        let currentPage = 1;
        let itemsPerPage = 7; // Default to 7 items per page
        let totalPages = 0;
        let allRows = [];

        // Initialize pagination when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializePagination();
        });

        // Initialize pagination
        function initializePagination() {
            const table = document.getElementById('reportedGroupsTable');
            if (!table) return;

            const tbody = table.querySelector('tbody');
            if (!tbody) return;

            // Get all data rows (excluding no-data row)
            allRows = Array.from(tbody.querySelectorAll('tr:not(.no-data)'));
            totalPages = Math.ceil(allRows.length / itemsPerPage);

            // If there's only 1 page or no data, don't create pagination
            if (totalPages <= 1) {
                updatePaginationInfo();
                return;
            }

            // Add data-page attribute to each row
            allRows.forEach((row, index) => {
                const pageNumber = Math.floor(index / itemsPerPage) + 1;
                row.setAttribute('data-page', pageNumber);
            });

            // Show first page
            showPage(1);
            updatePaginationControls();
        }

        // Show specific page
        function showPage(page) {
            // Hide all rows
            allRows.forEach(row => {
                row.style.display = 'none';
            });

            // Show rows for current page
            const startIndex = (page - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const rowsToShow = allRows.slice(startIndex, endIndex);

            rowsToShow.forEach(row => {
                row.style.display = '';
            });

            currentPage = page;
            updatePaginationInfo();
            updatePaginationControls();
        }

        // Update pagination info
        function updatePaginationInfo() {
            const startIndex = (currentPage - 1) * itemsPerPage + 1;
            const endIndex = Math.min(currentPage * itemsPerPage, allRows.length);
            const infoElement = document.querySelector('.pagination-info');

            if (infoElement) {
                if (itemsPerPage >= allRows.length) {
                    // Show all items
                    infoElement.textContent = `Hiển thị 1 đến ${allRows.length} của ${allRows.length} mục`;
                } else {
                    // Show paginated view
                    infoElement.textContent = `Hiển thị ${startIndex} đến ${endIndex} của ${allRows.length} mục`;
                }
            }
        }

        // Update pagination controls
        function updatePaginationControls() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const paginationControls = document.querySelector('.pagination-controls');
            const pageNumbers = document.querySelectorAll('.page-number');

            // Hide pagination controls when showing all items
            if (itemsPerPage >= allRows.length) {
                if (paginationControls) {
                    paginationControls.style.display = 'none';
                }
                return;
            }

            // Show pagination controls for paginated view
            if (paginationControls) {
                paginationControls.style.display = 'flex';
            }

            // Update page numbers
            pageNumbers.forEach((btn, index) => {
                const pageNum = index + 1;
                if (pageNum === currentPage) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });

            // Update prev/next buttons
            if (prevBtn) {
                prevBtn.classList.toggle('disabled', currentPage === 1);
            }

            if (nextBtn) {
                nextBtn.classList.toggle('disabled', currentPage === totalPages);
            }
        }

        // Change page
        function changePage(direction) {
            if (direction === 'prev' && currentPage > 1) {
                showPage(currentPage - 1);
            } else if (direction === 'next' && currentPage < totalPages) {
                showPage(currentPage + 1);
            }
        }

        // Change items per page
        function changeItemsPerPage(value) {
            itemsPerPage = parseInt(value);
            currentPage = 1;
            totalPages = Math.ceil(allRows.length / itemsPerPage);

            // Re-initialize pagination with new items per page
            allRows.forEach((row, index) => {
                const pageNumber = Math.floor(index / itemsPerPage) + 1;
                row.setAttribute('data-page', pageNumber);
            });

            showPage(1);
            updatePaginationControls();
        }

        // Mobile responsiveness
        function handleMobileView() {
            const table = document.querySelector('.data-table');
            const headers = table.querySelectorAll('th');

            if (window.innerWidth <= 768) {
                headers.forEach((header, index) => {
                    if (index > 2) { // Hide columns after CreationTime on mobile
                        header.style.display = 'none';
                    }
                });

                const rows = table.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const cells = row.querySelectorAll('td');
                    cells.forEach((cell, index) => {
                        if (index > 2) {
                            cell.style.display = 'none';
                        }
                    });
                });
            } else {
                // Show all columns on larger screens
                headers.forEach(header => header.style.display = '');
                const rows = table.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const cells = row.querySelectorAll('td');
                    cells.forEach(cell => cell.style.display = '');
                });
            }
        }

        // Initialize
        window.addEventListener('load', handleMobileView);
        window.addEventListener('resize', handleMobileView);
    </script>

    <!-- Pagination Script -->
    <script src="${pageContext.request.contextPath}/assets/js/pagination.js"></script>
</body>
</html>

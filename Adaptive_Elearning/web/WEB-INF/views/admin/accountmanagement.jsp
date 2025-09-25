<%@page import="model.Users"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Management - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard_clean.css">
   
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3>Account Management</h3>
            </div>
            <ul class="nav-menu">
                <li class="nav-item ">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item active ">
                    <a href="${pageContext.request.contextPath}/accountmanagement" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Account Management</span>
                    </a>
                </li>
                <li class="nav-item ">
                    <a href="${pageContext.request.contextPath}/createadmin" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Create Admin</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/notification" class="nav-link">
                        <i class="fas fa-bell"></i>
                        <span>Notification Management</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-flag"></i>
                        <span>Reported Groups</span>
                    </a>
                </li>
                <li class="nav-item">
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

<!-- Main Content -->
<main class="main-content">
    <div class="content-header">
        <div class="header-left">
            <h1>Account Management</h1>
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input type="text" id="searchInput" placeholder="Search users..." onkeyup="searchUsers()">
            </div>
        </div>
        <div class="header-right">
                <button class="btn-action btn-unblock" onclick="blockSelectedUsers()">
                <i class="fas fa-check"></i>
                Unban
            </button>
            <button class="btn-action btn-block" onclick="blockSelectedUsers()">
                <i class="fas fa-user-slash"></i>
                Ban
            </button>
        </div>
    </div>

        <div class="table-container">
            <div class="table-responsive">
                <table class="data-table" id="accountManagementTable">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="selectAll" onclick="toggleSelectAll()">
                            </th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Enrollment Count</th>
                            <th>Phone</th>
                            <th>Role</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Users> users = (List<Users>) request.getAttribute("users");
                            SimpleDateFormat dateFormat = (SimpleDateFormat) request.getAttribute("dateFormat");
                            if (users != null && !users.isEmpty()) {
                                for (Users user : users) {
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" class="user-select" value="<%= user.getId() %>">
                            </td>
                            <td><%= user.getUserName() != null ? user.getUserName() : "" %></td>
                            <td><%= user.getEmail() != null ? user.getEmail() : "" %></td>
                            <td><%= user.getEnrollmentCount() %></td>
                            <td><%= user.getPhone() != null ? user.getPhone() : "" %></td>
                            <td><%= user.getRole() != null ? user.getRole() : "" %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr class="no-data">
                            <td colspan="6" style="text-align: center; padding: 20px;">No users found</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination Container -->
            <div class="pagination-container">
                <div class="pagination-info">
                    Hiển thị 1 đến <%= users != null ? Math.min(7, users.size()) : 0 %> trong tổng số <%= users != null ? users.size() : 0 %> mục
                </div>
                <div class="pagination">
                    <button class="page-link prev disabled" onclick="changePage('prev')" id="prevBtn">←</button>

                    <div class="items-per-page">
                        <label for="itemsPerPage">Số mục mỗi trang:</label>
                        <select id="itemsPerPage" onchange="changeItemsPerPage(this.value)">
                            <option value="5">5</option>
                            <option value="7" selected>7</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                        </select>
                    </div>

                    <button class="page-link next <%= users != null && users.size() <= 7 ? "disabled" : "" %>" onclick="changePage('next')" id="nextBtn">→</button>
                </div>
            </div>
        </div>
 
</main>

    </div>

    <!-- JavaScript for functionality -->
    <script>
        // Toggle all checkboxes
        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const checkboxes = document.getElementsByClassName('user-select');
            for(let checkbox of checkboxes) {
                checkbox.checked = selectAllCheckbox.checked;
            }
        }

        // Create new user
        function createUser() {
            window.location.href = "${pageContext.request.contextPath}/admin/user/create";
        }

        // Edit user
        function editUser(userId) {
            window.location.href = "${pageContext.request.contextPath}/admin/user/edit/" + userId;
        }

        // Delete user
        function deleteUser(userId) {
            if(confirm('Are you sure you want to delete this user?')) {
                fetch("${pageContext.request.contextPath}/admin/user/delete/" + userId, {
                    method: 'POST',
                })
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        location.reload();
                    } else {
                        alert('Failed to delete user');
                    }
                });
            }
        }



        // Block selected users
        function blockSelectedUsers() {
            const selectedUsers = [];
            const checkboxes = document.getElementsByClassName('user-select');
            for(let checkbox of checkboxes) {
                if(checkbox.checked) {
                    selectedUsers.push(checkbox.value);
                }
            }

            if(selectedUsers.length === 0) {
                alert('Please select users to block');
                return;
            }

            if(confirm('Are you sure you want to block the selected users?')) {
                fetch("${pageContext.request.contextPath}/admin/users/block", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(selectedUsers)
                })
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        location.reload();
                    } else {
                        alert('Failed to block users');
                    }
                });
            }
        }

        // Search users
        function searchUsers() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const table = document.querySelector('.data-table');
            const tr = table.getElementsByTagName('tr');

            for (let i = 1; i < tr.length; i++) {
                const td = tr[i].getElementsByTagName('td');
                let txtValue = '';
                for (let j = 1; j < td.length - 1; j++) { // Skip checkbox and actions columns
                    txtValue += td[j].textContent || td[j].innerText;
                }
                if (txtValue.toLowerCase().indexOf(filter) > -1) {
                    tr[i].style.display = '';
                } else {
                    tr[i].style.display = 'none';
                }
            }
        }

        // Pagination variables
        let currentPage = 1;
        let itemsPerPage = 7;
        let totalPages = 0;
        let allRows = [];

        // Initialize pagination when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializePagination();
        });

        // Initialize pagination
        function initializePagination() {
            const table = document.getElementById('accountManagementTable');
            if (!table) return;

            const tbody = table.querySelector('tbody');
            if (!tbody) return;

            // Get all data rows (excluding no-data row)
            allRows = Array.from(tbody.querySelectorAll('tr:not(.no-data)'));
            totalPages = Math.ceil(allRows.length / itemsPerPage);

            // If no data or only one page, hide pagination controls
            const paginationContainer = document.querySelector('.pagination-container');
            if (allRows.length === 0 || totalPages <= 1) {
                if (paginationContainer) {
                    paginationContainer.style.display = 'none';
                }
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
            // Hide all rows first
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
            updatePaginationControls();
        }

        // Update pagination controls
        function updatePaginationControls() {
            const startIndex = (currentPage - 1) * itemsPerPage + 1;
            const endIndex = Math.min(currentPage * itemsPerPage, allRows.length);
            const paginationInfo = document.querySelector('.pagination-info');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');

            if (paginationInfo) {
                paginationInfo.textContent = `Hiển thị ${startIndex} đến ${endIndex} trong tổng số ${allRows.length} mục`;
            }

            // Update button states
            if (prevBtn) {
                prevBtn.classList.toggle('disabled', currentPage === 1);
            }
            if (nextBtn) {
                nextBtn.classList.toggle('disabled', currentPage === totalPages);
            }
        }

        // Change page function
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
            currentPage = 1; // Reset to first page
            totalPages = Math.ceil(allRows.length / itemsPerPage);
            showPage(1);
            updatePaginationControls();
        }
    </script>
</body>
</html>

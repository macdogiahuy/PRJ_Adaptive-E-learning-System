<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    USER DROPDOWN MENU COMPONENT - WITH ROLE-BASED ACCESS
    
    Usage: Include this file where you need the user dropdown menu
    <%@ include file="/WEB-INF/includes/user-dropdown.jsp" %>
    
    Requirements:
    - Session attribute "account" must be set (Users object)
    - User object must have: getUserName(), getEmail(), getAvatarUrl(), getRole()
--%>

<%@page import="model.Users"%>
<%
    Users currentUser = (Users) session.getAttribute("account");
    if (currentUser != null) {
        String userRole = currentUser.getRole(); // "Learner", "Instructor", "Admin"
        String userName = currentUser.getUserName();
        String userEmail = currentUser.getEmail();
        String avatarUrl = currentUser.getAvatarUrl();
%>

<div class="user-dropdown">
    <button class="user-menu-btn" type="button">
        <div class="user-avatar">
            <% if (avatarUrl != null && !avatarUrl.isEmpty()) { %>
                <img src="<%= avatarUrl %>" alt="Avatar" class="avatar-img">
            <% } else { %>
                <i class="fas fa-user-circle"></i>
            <% } %>
        </div>
        <div class="user-info">
            <span class="user-name"><%= userName %></span>
            <i class="fas fa-chevron-down dropdown-arrow"></i>
        </div>
    </button>
    
    <div class="dropdown-menu">
        <!-- Header -->
        <div class="dropdown-header">
            <div class="user-details">
                <% if (avatarUrl != null && !avatarUrl.isEmpty()) { %>
                    <img src="<%= avatarUrl %>" alt="Avatar" class="dropdown-avatar">
                <% } else { %>
                    <div class="dropdown-avatar-placeholder">
                        <i class="fas fa-user-circle"></i>
                    </div>
                <% } %>
                <div class="user-text">
                    <div class="user-fullname"><%= userName %></div>
                    <div class="user-email"><%= userEmail %></div>
                    <% if (userRole != null && !userRole.isEmpty()) { %>
                        <div class="user-role-badge role-<%= userRole.toLowerCase() %>">
                            <%= userRole %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <div class="dropdown-divider"></div>
        
        <!-- Menu Items Based on Role -->
        <div class="dropdown-items">
            <%
                // Dashboard - Only for Instructor and Admin
                if ("Instructor".equalsIgnoreCase(userRole) || "Admin".equalsIgnoreCase(userRole)) {
                    String dashboardUrl = "";
                    String dashboardIcon = "fas fa-tachometer-alt";
                    String dashboardLabel = "Dashboard";
                    
                    if ("Admin".equalsIgnoreCase(userRole)) {
                        dashboardUrl = request.getContextPath() + "/admin_dashboard.jsp";
                        dashboardLabel = "Admin Dashboard";
                    } else if ("Instructor".equalsIgnoreCase(userRole)) {
                        dashboardUrl = request.getContextPath() + "/instructor_dashboard.jsp";
                        dashboardLabel = "Instructor Dashboard";
                    }
            %>
                <a href="<%= dashboardUrl %>" class="dropdown-item">
                    <i class="<%= dashboardIcon %>"></i>
                    <span><%= dashboardLabel %></span>
                </a>
            <% } %>
            
            <%-- My Courses - For All Users (Everyone can enroll in courses) --%>
            <a href="<%= request.getContextPath() %>/my-courses" class="dropdown-item">
                <i class="fas fa-book"></i>
                <span>Khóa học đã đăng ký</span>
            </a>
            
            <%-- Profile - For All Users --%>
            <a href="<%= request.getContextPath() %>/profile" class="dropdown-item">
                <i class="fas fa-user-edit"></i>
                <span>Chỉnh sửa hồ sơ</span>
            </a>
            
            <%-- Settings - For All Users --%>
            <a href="<%= request.getContextPath() %>/settings" class="dropdown-item">
                <i class="fas fa-cog"></i>
                <span>Cài đặt</span>
            </a>
        </div>
        
        <div class="dropdown-divider"></div>
        
        <!-- Logout -->
        <div class="dropdown-items">
            <a href="<%= request.getContextPath() %>/logout" class="dropdown-item logout-item">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </a>
        </div>
    </div>
</div>

<% } else { %>
    <!-- Not logged in -->
    <a href="<%= request.getContextPath() %>/login" class="login-btn">Đăng nhập</a>
    <a href="<%= request.getContextPath() %>/register" class="register-btn">Đăng ký</a>
<% } %>

<style>
/* Role Badge Styling */
.user-role-badge {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    margin-top: 4px;
}

.user-role-badge.role-learner {
    background: #e3f2fd;
    color: #1976d2;
}

.user-role-badge.role-instructor {
    background: #fff3e0;
    color: #f57c00;
}

.user-role-badge.role-admin {
    background: #fce4ec;
    color: #c2185b;
}

/* Enhanced dropdown item styling */
.dropdown-item {
    display: flex;
    align-items: center;
    padding: 12px 20px;
    color: #333;
    text-decoration: none;
    transition: all 0.2s;
}

.dropdown-item:hover {
    background: #f5f5f5;
    color: #4A90E2;
}

.dropdown-item i {
    width: 20px;
    margin-right: 12px;
    font-size: 16px;
}

.dropdown-item.logout-item {
    color: #d32f2f;
}

.dropdown-item.logout-item:hover {
    background: #ffebee;
    color: #c62828;
}
</style>

/**
 * Modern Instructor Dashboard JavaScript
 * ES6+ Implementation with Advanced Features
 */

class ModernDashboard {
    constructor() {
        this.sidebarCollapsed = this.getSavedSidebarState();
        this.currentUser = null;
        this.charts = new Map();
        this.notifications = [];
        this.refreshInterval = null;
        
        this.init();
    }

    async init() {
        try {
            // Core functionality first
            this.setupEventListeners();
            this.initializeSidebar();
            
            // Defer heavy operations
            requestAnimationFrame(() => {
                this.loadUserData();
                this.loadDashboardData();
            });
            
            // Initialize charts after DOM is ready
            setTimeout(() => {
                this.initializeCharts();
            }, 300);
            
            // Real-time updates last
            setTimeout(() => {
                this.setupRealTimeUpdates();
                this.addAnimations();
            }, 1000);
            
            console.log('Dashboard initialized successfully');
        } catch (error) {
            console.error('Dashboard initialization failed:', error);
            this.showToast('Lỗi khởi tạo dashboard', 'error');
        }
    }

    setupEventListeners() {
        // Sidebar toggle
        const sidebarToggle = document.querySelector('.sidebar-toggle');
        sidebarToggle?.addEventListener('click', () => this.toggleSidebar());

        // Navigation
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', (e) => this.handleNavigation(e));
        });

        // Search with debounce
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => this.handleSearch(e.target.value), 300);
            });
        }

        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.handleFilter(e));
        });

        // User avatar dropdown
        const userAvatar = document.querySelector('.user-avatar');
        userAvatar?.addEventListener('click', () => this.toggleUserDropdown());

        // Notification button
        const notificationBtn = document.querySelector('.notification-btn');
        notificationBtn?.addEventListener('click', () => this.toggleNotifications());

        // Table actions
        document.addEventListener('click', (e) => {
            if (e.target.closest('[data-action]')) {
                this.handleTableAction(e);
            }
        });

        // Window resize
        window.addEventListener('resize', () => this.handleResize());

        // Close dropdowns on outside click
        document.addEventListener('click', (e) => this.handleOutsideClick(e));

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => this.handleKeyboardShortcuts(e));

        // Prevent form submission on Enter in search
        searchInput?.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.performSearch(e.target.value);
            }
        });
    }

    initializeSidebar() {
        const sidebar = document.querySelector('.sidebar');
        const mainContent = document.querySelector('.main-content');
        
        if (this.sidebarCollapsed) {
            sidebar?.classList.add('collapsed');
            mainContent?.classList.add('expanded');
        }
        
        // Set active nav item based on current page
        this.setActiveNavItem();
    }

    setActiveNavItem() {
        const currentPage = window.location.pathname;
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentPage || 
                (currentPage.includes('dashboard') && link.getAttribute('href') === '#dashboard')) {
                link.classList.add('active');
            }
        });
    }

    toggleSidebar() {
        const sidebar = document.querySelector('.sidebar');
        const mainContent = document.querySelector('.main-content');
        const isMobile = window.innerWidth <= 1024;
        
        if (isMobile) {
            sidebar?.classList.toggle('show');
        } else {
            this.sidebarCollapsed = !this.sidebarCollapsed;
            sidebar?.classList.toggle('collapsed');
            mainContent?.classList.toggle('expanded');
            this.saveSidebarState();
        }
    }

    getSavedSidebarState() {
        return localStorage.getItem('sidebarCollapsed') === 'true';
    }

    saveSidebarState() {
        localStorage.setItem('sidebarCollapsed', this.sidebarCollapsed.toString());
    }

    handleNavigation(e) {
        e.preventDefault();
        const link = e.target.closest('.nav-link');
        const href = link.getAttribute('href');
        
        // Remove active class from all nav links
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        link.classList.add('active');
        
        // Show loading state
        this.showLoadingState();
        
        // Simulate page navigation (replace with actual routing)
        setTimeout(() => {
            this.hideLoadingState();
            this.loadPageContent(href);
        }, 500);
        
        // Close mobile sidebar
        if (window.innerWidth <= 1024) {
            document.querySelector('.sidebar')?.classList.remove('show');
        }
    }

    async loadPageContent(href) {
        try {
            // This would typically make an AJAX request to load page content
            console.log(`Loading page: ${href}`);
            
            // Update page title
            const pageTitle = this.getPageTitle(href);
            document.querySelector('.page-title').textContent = pageTitle;
            
            // Update content based on page
            await this.updatePageContent(href);
            
        } catch (error) {
            console.error('Failed to load page content:', error);
            this.showToast('Lỗi tải nội dung trang', 'error');
        }
    }

    getPageTitle(href) {
        const titles = {
            '#dashboard': 'Tổng quan',
            '#courses': 'Quản lý khóa học',
            '#students': 'Quản lý học viên',
            '#assignments': 'Bài tập và kiểm tra',
            '#discussions': 'Thảo luận',
            '#analytics': 'Phân tích và báo cáo',
            '#resources': 'Tài liệu học tập',
            '#calendar': 'Lịch học',
            '#settings': 'Cài đặt'
        };
        return titles[href] || 'Dashboard';
    }

    async updatePageContent(href) {
        // Implement page-specific content updates
        switch (href) {
            case '#dashboard':
                await this.loadDashboardData();
                break;
            case '#courses':
                await this.loadCoursesData();
                break;
            case '#students':
                await this.loadStudentsData();
                break;
            // Add more cases as needed
        }
    }

    async handleSearch(query) {
        if (!query.trim()) {
            this.clearSearchResults();
            return;
        }

        try {
            // Show search loading
            this.showSearchLoading();
            
            // Simulate API call
            const results = await this.performSearch(query);
            this.showSearchResults(results);
            
        } catch (error) {
            console.error('Search failed:', error);
            this.showToast('Lỗi tìm kiếm', 'error');
        }
    }

    async performSearch(query) {
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 300));
        
        // Mock search results
        const mockData = [
            { id: 1, type: 'course', title: 'JavaScript Fundamentals', description: 'Khóa học JS cơ bản' },
            { id: 2, type: 'student', title: 'Nguyễn Văn A', description: 'Học viên khóa React' },
            { id: 3, type: 'assignment', title: 'Bài tập tuần 1', description: 'Bài tập HTML/CSS' },
            { id: 4, type: 'course', title: 'React Advanced', description: 'Khóa học React nâng cao' },
            { id: 5, type: 'student', title: 'Trần Thị B', description: 'Học viên khóa Node.js' }
        ];
        
        return mockData.filter(item => 
            item.title.toLowerCase().includes(query.toLowerCase()) ||
            item.description.toLowerCase().includes(query.toLowerCase())
        );
    }

    showSearchLoading() {
        const searchContainer = document.querySelector('.search-container');
        let dropdown = searchContainer.querySelector('.search-dropdown');
        
        if (!dropdown) {
            dropdown = this.createSearchDropdown();
            searchContainer.appendChild(dropdown);
        }
        
        dropdown.innerHTML = `
            <div class="search-loading">
                <div class="spinner"></div>
                <span>Đang tìm kiếm...</span>
            </div>
        `;
        dropdown.classList.add('show');
    }

    showSearchResults(results) {
        const searchContainer = document.querySelector('.search-container');
        let dropdown = searchContainer.querySelector('.search-dropdown');
        
        if (!dropdown) {
            dropdown = this.createSearchDropdown();
            searchContainer.appendChild(dropdown);
        }
        
        if (results.length === 0) {
            dropdown.innerHTML = `
                <div class="search-no-results">
                    <i class="fas fa-search"></i>
                    <span>Không tìm thấy kết quả</span>
                </div>
            `;
        } else {
            dropdown.innerHTML = `
                <div class="search-results-header">
                    <span>Kết quả tìm kiếm (${results.length})</span>
                </div>
                ${results.map(result => `
                    <div class="search-result-item" data-id="${result.id}" data-type="${result.type}">
                        <div class="search-result-icon">
                            <i class="fas fa-${this.getSearchIcon(result.type)}"></i>
                        </div>
                        <div class="search-result-content">
                            <div class="search-result-title">${result.title}</div>
                            <div class="search-result-description">${result.description}</div>
                        </div>
                        <div class="search-result-type">${this.getSearchTypeLabel(result.type)}</div>
                    </div>
                `).join('')}
            `;
            
            // Add click handlers to results
            dropdown.querySelectorAll('.search-result-item').forEach(item => {
                item.addEventListener('click', () => this.handleSearchResultClick(item));
            });
        }
        
        dropdown.classList.add('show');
    }

    createSearchDropdown() {
        const dropdown = document.createElement('div');
        dropdown.className = 'search-dropdown dropdown-menu';
        return dropdown;
    }

    getSearchIcon(type) {
        const icons = {
            course: 'book',
            student: 'user-graduate',
            assignment: 'tasks',
            discussion: 'comments',
            resource: 'file-alt'
        };
        return icons[type] || 'search';
    }

    getSearchTypeLabel(type) {
        const labels = {
            course: 'Khóa học',
            student: 'Học viên',
            assignment: 'Bài tập',
            discussion: 'Thảo luận',
            resource: 'Tài liệu'
        };
        return labels[type] || 'Khác';
    }

    handleSearchResultClick(item) {
        const id = item.dataset.id;
        const type = item.dataset.type;
        
        console.log(`Clicked on ${type} with id: ${id}`);
        this.clearSearchResults();
        this.showToast(`Đang mở ${this.getSearchTypeLabel(type)}: ${item.querySelector('.search-result-title').textContent}`, 'info');
    }

    clearSearchResults() {
        const dropdown = document.querySelector('.search-dropdown');
        dropdown?.classList.remove('show');
    }

    handleFilter(e) {
        const filterBtn = e.target.closest('.filter-btn');
        const filterValue = filterBtn.dataset.filter;
        
        // Update active filter
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        filterBtn.classList.add('active');
        
        // Apply filter
        this.applyFilter(filterValue);
    }

    async applyFilter(filterValue) {
        try {
            this.showLoadingState();
            
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 800));
            
            // Update charts and data
            await this.updateChartData(filterValue);
            
            this.hideLoadingState();
            this.showToast(`Đã áp dụng bộ lọc: ${filterValue}`, 'success');
            
        } catch (error) {
            console.error('Filter application failed:', error);
            this.hideLoadingState();
            this.showToast('Lỗi áp dụng bộ lọc', 'error');
        }
    }

    toggleUserDropdown() {
        const userMenu = document.querySelector('.user-menu');
        let dropdown = userMenu.querySelector('.dropdown-menu');
        
        if (!dropdown) {
            dropdown = this.createUserDropdown();
            userMenu.appendChild(dropdown);
        }
        
        dropdown.classList.toggle('show');
    }

    createUserDropdown() {
        const dropdown = document.createElement('div');
        dropdown.className = 'dropdown-menu';
        dropdown.innerHTML = `
            <div class="dropdown-item" data-action="profile">
                <i class="fas fa-user"></i>
                <span>Hồ sơ cá nhân</span>
            </div>
            <div class="dropdown-item" data-action="settings">
                <i class="fas fa-cog"></i>
                <span>Cài đặt tài khoản</span>
            </div>
            <div class="dropdown-item" data-action="help">
                <i class="fas fa-question-circle"></i>
                <span>Trợ giúp</span>
            </div>
            <div class="dropdown-divider"></div>
            <div class="dropdown-item danger" data-action="logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Đăng xuất</span>
            </div>
        `;
        
        dropdown.addEventListener('click', (e) => {
            const action = e.target.closest('.dropdown-item')?.dataset.action;
            if (action) this.handleUserMenuAction(action);
        });
        
        return dropdown;
    }

    handleUserMenuAction(action) {
        switch (action) {
            case 'profile':
                this.showToast('Đang mở hồ sơ cá nhân', 'info');
                break;
            case 'settings':
                this.showToast('Đang mở cài đặt', 'info');
                break;
            case 'help':
                this.showToast('Đang mở trợ giúp', 'info');
                break;
            case 'logout':
                this.handleLogout();
                break;
        }
        
        // Close dropdown
        document.querySelector('.user-menu .dropdown-menu')?.classList.remove('show');
    }

    handleLogout() {
        if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
            this.showToast('Đang đăng xuất...', 'info');
            // Implement logout logic
            setTimeout(() => {
                window.location.href = '/Adaptive_Elearning/login';
            }, 1000);
        }
    }

    toggleNotifications() {
        const notificationBtn = document.querySelector('.notification-btn');
        let dropdown = notificationBtn.parentElement.querySelector('.dropdown-menu');
        
        if (!dropdown) {
            dropdown = this.createNotificationDropdown();
            notificationBtn.parentElement.appendChild(dropdown);
        }
        
        dropdown.classList.toggle('show');
    }

    createNotificationDropdown() {
        const dropdown = document.createElement('div');
        dropdown.className = 'dropdown-menu';
        dropdown.style.width = '320px';
        dropdown.innerHTML = `
            <div class="notification-header">
                <h4>Thông báo</h4>
                <button class="btn-sm" onclick="dashboard.markAllAsRead()">Đánh dấu đã đọc</button>
            </div>
            <div class="notification-list">
                ${this.renderNotifications()}
            </div>
            <div class="notification-footer">
                <a href="#notifications">Xem tất cả thông báo</a>
            </div>
        `;
        
        return dropdown;
    }

    renderNotifications() {
        // Mock notifications
        const notifications = [
            { id: 1, title: 'Học viên mới đăng ký', message: 'Nguyễn Văn A đã đăng ký khóa JavaScript', time: '2 phút trước', unread: true },
            { id: 2, title: 'Bài tập được nộp', message: 'Có 5 bài tập mới được nộp', time: '15 phút trước', unread: true },
            { id: 3, title: 'Đánh giá khóa học', message: 'Khóa học React nhận được đánh giá 5 sao', time: '1 giờ trước', unread: false }
        ];
        
        return notifications.map(notif => `
            <div class="notification-item ${notif.unread ? 'unread' : ''}">
                <div class="notification-content">
                    <div class="notification-title">${notif.title}</div>
                    <div class="notification-message">${notif.message}</div>
                    <div class="notification-time">${notif.time}</div>
                </div>
                ${notif.unread ? '<div class="notification-dot"></div>' : ''}
            </div>
        `).join('');
    }

    markAllAsRead() {
        document.querySelectorAll('.notification-item.unread').forEach(item => {
            item.classList.remove('unread');
            item.querySelector('.notification-dot')?.remove();
        });
        
        // Update badge
        const badge = document.querySelector('.notification-badge');
        if (badge) badge.style.display = 'none';
        
        this.showToast('Đã đánh dấu tất cả thông báo là đã đọc', 'success');
    }

    handleTableAction(e) {
        e.preventDefault();
        const actionBtn = e.target.closest('[data-action]');
        const action = actionBtn.dataset.action;
        const id = actionBtn.dataset.id;
        
        switch (action) {
            case 'view':
                this.viewItem(id);
                break;
            case 'edit':
                this.editItem(id);
                break;
            case 'delete':
                this.deleteItem(id);
                break;
            default:
                console.log(`Unknown action: ${action}`);
        }
    }

    viewItem(id) {
        console.log(`Viewing item: ${id}`);
        this.showToast(`Đang xem chi tiết mục ${id}`, 'info');
    }

    editItem(id) {
        console.log(`Editing item: ${id}`);
        this.showToast(`Đang chỉnh sửa mục ${id}`, 'info');
    }

    deleteItem(id) {
        if (confirm('Bạn có chắc chắn muốn xóa mục này?')) {
            console.log(`Deleting item: ${id}`);
            this.showToast(`Đã xóa mục ${id}`, 'success');
        }
    }

    handleResize() {
        const isMobile = window.innerWidth <= 1024;
        const sidebar = document.querySelector('.sidebar');
        const mainContent = document.querySelector('.main-content');
        
        if (isMobile) {
            sidebar?.classList.remove('collapsed');
            mainContent?.classList.remove('expanded');
        } else {
            sidebar?.classList.remove('show');
            if (this.sidebarCollapsed) {
                sidebar?.classList.add('collapsed');
                mainContent?.classList.add('expanded');
            }
        }
    }

    handleOutsideClick(e) {
        // Close dropdowns when clicking outside
        const dropdowns = document.querySelectorAll('.dropdown-menu.show');
        dropdowns.forEach(dropdown => {
            if (!dropdown.closest('.dropdown').contains(e.target)) {
                dropdown.classList.remove('show');
            }
        });
        
        // Close search results
        const searchDropdown = document.querySelector('.search-dropdown.show');
        if (searchDropdown && !e.target.closest('.search-container')) {
            this.clearSearchResults();
        }
        
        // Close mobile sidebar
        const sidebar = document.querySelector('.sidebar.show');
        if (sidebar && window.innerWidth <= 1024 && 
            !sidebar.contains(e.target) && 
            !e.target.closest('.sidebar-toggle')) {
            sidebar.classList.remove('show');
        }
    }

    handleKeyboardShortcuts(e) {
        // Ctrl/Cmd + K for search focus
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            document.querySelector('.search-input')?.focus();
        }
        
        // Escape to close dropdowns
        if (e.key === 'Escape') {
            document.querySelectorAll('.dropdown-menu.show').forEach(dropdown => {
                dropdown.classList.remove('show');
            });
            this.clearSearchResults();
        }
    }

    async loadUserData() {
        try {
            // This would typically fetch user data from an API
            this.currentUser = {
                id: 1,
                name: window.userName || 'Instructor',
                email: 'instructor@example.com',
                avatar: null
            };
            
            console.log('User data loaded:', this.currentUser);
        } catch (error) {
            console.error('Failed to load user data:', error);
        }
    }

    async loadDashboardData() {
        try {
            const [statsData, chartData, activityData] = await Promise.all([
                this.fetchStatsData(),
                this.fetchChartData(),
                this.fetchActivityData()
            ]);
            
            this.updateStatsCards(statsData);
            this.updateCharts(chartData);
            this.updateActivity(activityData);
            
        } catch (error) {
            console.error('Failed to load dashboard data:', error);
            this.showToast('Lỗi tải dữ liệu dashboard', 'error');
        }
    }

    async fetchStatsData() {
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 500));
        
        return {
            totalStudents: 1247,
            activeCourses: 23,
            completionRate: 87,
            monthlyRevenue: 45600
        };
    }

    async fetchChartData() {
        await new Promise(resolve => setTimeout(resolve, 300));
        
        return {
            studentProgress: [65, 72, 68, 85, 91, 89, 95],
            courseStats: [12, 19, 15, 25, 22, 18, 30],
            revenue: [3200, 4100, 3800, 5200, 4800, 5600, 6200]
        };
    }

    async fetchActivityData() {
        await new Promise(resolve => setTimeout(resolve, 200));
        
        return [
            { icon: 'user-plus', text: 'Học viên mới đăng ký khóa JavaScript', time: '2 phút trước' },
            { icon: 'book', text: 'Khóa học React được cập nhật nội dung', time: '15 phút trước' },
            { icon: 'star', text: 'Nhận đánh giá 5 sao từ học viên', time: '1 giờ trước' },
            { icon: 'comment', text: 'Câu hỏi mới trong diễn đàn thảo luận', time: '3 giờ trước' }
        ];
    }

    updateStatsCards(data) {
        const stats = [
            { selector: '.stat-number', key: 'totalStudents', format: 'number' },
            { selector: '.stat-number', key: 'activeCourses', format: 'number' },
            { selector: '.stat-number', key: 'completionRate', format: 'percentage' },
            { selector: '.stat-number', key: 'monthlyRevenue', format: 'currency' }
        ];
        
        document.querySelectorAll('.stat-card').forEach((card, index) => {
            const stat = stats[index];
            if (stat && data[stat.key] !== undefined) {
                const element = card.querySelector(stat.selector);
                if (element) {
                    this.animateNumber(element, data[stat.key], stat.format);
                }
            }
        });
    }

    animateNumber(element, targetValue, format) {
        const startValue = 0;
        const duration = 1500;
        const startTime = performance.now();
        
        const animate = (currentTime) => {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            // Easing function (ease-out)
            const easeOut = 1 - Math.pow(1 - progress, 3);
            const currentValue = startValue + (targetValue - startValue) * easeOut;
            
            let displayValue;
            switch (format) {
                case 'percentage':
                    displayValue = Math.round(currentValue) + '%';
                    break;
                case 'currency':
                    displayValue = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(Math.round(currentValue));
                    break;
                default:
                    displayValue = Math.round(currentValue).toLocaleString();
            }
            
            element.textContent = displayValue;
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };
        
        requestAnimationFrame(animate);
    }

    updateActivity(activities) {
        const container = document.querySelector('.activity-list');
        if (!container) return;
        
        container.innerHTML = activities.map(activity => `
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-${activity.icon}"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-text">${activity.text}</div>
                    <div class="activity-time">${activity.time}</div>
                </div>
            </div>
        `).join('');
    }

    initializeCharts() {
        // Use Intersection Observer for lazy chart loading
        const chartObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.createChart(entry.target);
                    chartObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        // Observe chart containers
        document.querySelectorAll('canvas').forEach(canvas => {
            chartObserver.observe(canvas);
        });
    }

    createChart(canvas) {
        if (!canvas) return;
        
        const chartType = canvas.id;
        switch(chartType) {
            case 'studentProgressChart':
                this.createStudentProgressChart(canvas);
                break;
            case 'courseStatsChart':
                this.createCourseStatsChart(canvas);
                break;
        }
    }

    createStudentProgressChart(canvas) {
        const ctx = canvas.getContext('2d');
        this.drawLineChart(ctx, 'Tiến độ học viên', [65, 72, 68, 85, 91, 89, 95]);
    }

    createCourseStatsChart() {
        const canvas = document.getElementById('courseStatsChart');
        if (!canvas) return;
        
        const ctx = canvas.getContext('2d');
        this.drawBarChart(ctx, 'Thống kê khóa học', [12, 19, 15, 25, 22, 18, 30]);
    }

    drawLineChart(ctx, title, data) {
        const canvas = ctx.canvas;
        const width = canvas.width;
        const height = canvas.height;
        const padding = 40;
        
        // Clear canvas
        ctx.clearRect(0, 0, width, height);
        
        // Set styles
        ctx.strokeStyle = '#3b82f6';
        ctx.fillStyle = '#3b82f6';
        ctx.lineWidth = 3;
        ctx.font = '12px Inter';
        
        // Calculate points
        const maxValue = Math.max(...data);
        const points = data.map((value, index) => ({
            x: padding + (index * (width - 2 * padding)) / (data.length - 1),
            y: height - padding - (value / maxValue) * (height - 2 * padding)
        }));
        
        // Draw line
        ctx.beginPath();
        ctx.moveTo(points[0].x, points[0].y);
        points.forEach(point => ctx.lineTo(point.x, point.y));
        ctx.stroke();
        
        // Draw points
        points.forEach(point => {
            ctx.beginPath();
            ctx.arc(point.x, point.y, 4, 0, Math.PI * 2);
            ctx.fill();
        });
        
        // Draw title
        ctx.fillStyle = '#1f2937';
        ctx.fillText(title, 20, 20);
    }

    drawBarChart(ctx, title, data) {
        const canvas = ctx.canvas;
        const width = canvas.width;
        const height = canvas.height;
        const padding = 40;
        
        // Clear canvas
        ctx.clearRect(0, 0, width, height);
        
        // Set styles
        ctx.fillStyle = '#10b981';
        ctx.font = '12px Inter';
        
        // Calculate bars
        const maxValue = Math.max(...data);
        const barWidth = (width - 2 * padding) / data.length * 0.8;
        const barSpacing = (width - 2 * padding) / data.length * 0.2;
        
        data.forEach((value, index) => {
            const barHeight = (value / maxValue) * (height - 2 * padding);
            const x = padding + index * (barWidth + barSpacing);
            const y = height - padding - barHeight;
            
            ctx.fillRect(x, y, barWidth, barHeight);
        });
        
        // Draw title
        ctx.fillStyle = '#1f2937';
        ctx.fillText(title, 20, 20);
    }

    async updateChartData(filter) {
        try {
            const chartData = await this.fetchChartData(filter);
            this.updateCharts(chartData);
        } catch (error) {
            console.error('Failed to update chart data:', error);
        }
    }

    updateCharts(data) {
        // Update existing charts with new data
        this.createStudentProgressChart();
        this.createCourseStatsChart();
    }

    setupRealTimeUpdates() {
        // Setup periodic data refresh
        this.refreshInterval = setInterval(() => {
            this.refreshDashboardData();
        }, 30000); // Refresh every 30 seconds
    }

    async refreshDashboardData() {
        try {
            const statsData = await this.fetchStatsData();
            this.updateStatsCards(statsData);
            
            // Update notification badge
            this.updateNotificationBadge();
            
        } catch (error) {
            console.error('Failed to refresh dashboard data:', error);
        }
    }

    updateNotificationBadge() {
        const badge = document.querySelector('.notification-badge');
        if (badge) {
            // Simulate new notifications
            const count = Math.floor(Math.random() * 5);
            if (count > 0) {
                badge.textContent = count;
                badge.style.display = 'flex';
            }
        }
    }

    addAnimations() {
        // Add intersection observer for scroll animations
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        });
        
        // Observe elements for animation
        document.querySelectorAll('.stat-card, .chart-container, .table-container').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        });
    }

    showLoadingState() {
        const content = document.querySelector('.dashboard-content');
        content?.classList.add('loading');
        
        // Show loading spinner overlay
        this.showLoadingOverlay();
    }

    hideLoadingState() {
        const content = document.querySelector('.dashboard-content');
        content?.classList.remove('loading');
        
        this.hideLoadingOverlay();
    }

    showLoadingOverlay() {
        let overlay = document.querySelector('.loading-overlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="loading-spinner">
                    <div class="spinner"></div>
                    <span>Đang tải...</span>
                </div>
            `;
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(255, 255, 255, 0.8);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                backdrop-filter: blur(4px);
            `;
            document.body.appendChild(overlay);
        }
        overlay.style.display = 'flex';
    }

    hideLoadingOverlay() {
        const overlay = document.querySelector('.loading-overlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }

    showToast(message, type = 'info', duration = 3000) {
        // Remove existing toast
        const existingToast = document.querySelector('.toast');
        existingToast?.remove();
        
        // Create new toast
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        
        const icon = this.getToastIcon(type);
        toast.innerHTML = `
            <div class="toast-content">
                <i class="fas fa-${icon}"></i>
                <span>${message}</span>
            </div>
            <button class="toast-close" onclick="this.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        `;
        
        // Add styles
        toast.style.cssText = `
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-left: 4px solid ${this.getToastColor(type)};
            transform: translateX(400px);
            transition: transform 0.3s ease;
        `;
        
        document.body.appendChild(toast);
        
        // Show toast
        requestAnimationFrame(() => {
            toast.style.transform = 'translateX(0)';
        });
        
        // Auto hide
        setTimeout(() => {
            toast.style.transform = 'translateX(400px)';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    getToastIcon(type) {
        const icons = {
            success: 'check-circle',
            error: 'exclamation-circle',
            warning: 'exclamation-triangle',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }

    getToastColor(type) {
        const colors = {
            success: '#10b981',
            error: '#ef4444',
            warning: '#f59e0b',
            info: '#3b82f6'
        };
        return colors[type] || '#3b82f6';
    }

    // Cleanup method
    destroy() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
        }
        
        // Remove event listeners
        document.removeEventListener('click', this.handleOutsideClick);
        document.removeEventListener('keydown', this.handleKeyboardShortcuts);
        window.removeEventListener('resize', this.handleResize);
    }
}

// Utility functions
const DashboardUtils = {
    formatNumber: (num) => num.toLocaleString('vi-VN'),
    
    formatCurrency: (amount) => new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount),
    
    formatDate: (date) => new Intl.DateTimeFormat('vi-VN').format(new Date(date)),
    
    getTimeAgo: (date) => {
        const now = new Date();
        const diffInSeconds = Math.floor((now - new Date(date)) / 1000);
        
        if (diffInSeconds < 60) return `${diffInSeconds} giây trước`;
        if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)} phút trước`;
        if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)} giờ trước`;
        return `${Math.floor(diffInSeconds / 86400)} ngày trước`;
    },
    
    debounce: (func, wait) => {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },
    
    throttle: (func, limit) => {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
};

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new ModernDashboard();
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ModernDashboard, DashboardUtils };
}
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Online Users Counter Component
    Displays real-time count of online users
    Auto-refreshes every 2 minutes
--%>
<div class="online-users-counter" id="onlineUsersCounter">
    <i class="fas fa-users"></i>
    <span class="online-users-count" id="onlineUsersCount">
        <i class="fas fa-spinner fa-spin"></i>
    </span>
    <span class="online-users-label">người đang online</span>
</div>

<style>
    .online-users-counter {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        background: linear-gradient(135deg, #6a93d3 0%, #5a7dbf 100%);
        border-radius: 25px;
        color: white;
        font-weight: 600;
        font-size: 14px;
        box-shadow: 0 4px 15px rgba(106, 147, 211, 0.4);
        transition: all 0.3s;
        animation: pulse 2s ease-in-out infinite;
    }
    
    .online-users-counter:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(106, 147, 211, 0.6);
    }
    
    .online-users-counter i.fa-users {
        font-size: 16px;
    }
    
    .online-users-count {
        font-size: 18px;
        font-weight: 700;
        min-width: 30px;
        text-align: center;
    }
    
    .online-users-label {
        font-weight: 500;
    }
    
    @keyframes pulse {
        0%, 100% {
            box-shadow: 0 4px 15px rgba(106, 147, 211, 0.4);
        }
        50% {
            box-shadow: 0 4px 20px rgba(106, 147, 211, 0.6);
        }
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .online-users-counter {
            font-size: 12px;
            padding: 8px 15px;
        }
        
        .online-users-count {
            font-size: 16px;
        }
        
        .online-users-label {
            display: none;
        }
    }
</style>

<script>
(function() {
    // Get online users count from server
    function updateOnlineUsersCount() {
        fetch('<%= request.getContextPath() %>/api/online-users', {
            method: 'GET',
            headers: {
                'Cache-Control': 'no-cache'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const countElement = document.getElementById('onlineUsersCount');
                if (countElement) {
                    countElement.innerHTML = data.count;
                    
                    // Add animation on update
                    countElement.style.transform = 'scale(1.2)';
                    setTimeout(() => {
                        countElement.style.transform = 'scale(1)';
                    }, 200);
                }
            } else {
                console.error('Failed to get online users count:', data.error);
            }
        })
        .catch(error => {
            console.error('Error fetching online users count:', error);
            const countElement = document.getElementById('onlineUsersCount');
            if (countElement) {
                countElement.innerHTML = '<i class="fas fa-question"></i>';
            }
        });
    }
    
    // Initial load
    updateOnlineUsersCount();
    
    // Update every 1 minute (60000 milliseconds) instead of 2 minutes
    setInterval(updateOnlineUsersCount, 60000);
    
    // Also update when page becomes visible (user returns to tab)
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            updateOnlineUsersCount();
        }
    });
})();
</script>

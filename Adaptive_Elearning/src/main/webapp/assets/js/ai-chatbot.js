/**
 * AI Chatbot Advisor JavaScript
 * Handles chat functionality, UI interactions, and API communication
 */

class AIChatbot {
    constructor() {
        this.messageInput = document.getElementById('message-input');
        this.sendButton = document.getElementById('send-button');
        this.chatMessages = document.getElementById('chat-messages');
        this.typingIndicator = document.getElementById('typing-indicator');
        this.welcomeMessage = document.getElementById('welcome-message');
        
        // Get context path
        this.contextPath = window.location.pathname.split('/')[1];
        this.apiUrl = `/${this.contextPath}/ai-advice`;
        
        this.init();
    }

    init() {
        // Event listeners
        this.sendButton.addEventListener('click', () => this.sendMessage());
        this.messageInput.addEventListener('keydown', (e) => this.handleKeyPress(e));
        this.messageInput.addEventListener('input', () => this.handleInput());
        
        // Quick action buttons
        const quickActionBtns = document.querySelectorAll('.quick-action-btn');
        quickActionBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                this.messageInput.value = btn.dataset.message;
                this.messageInput.focus();
                this.handleInput();
            });
        });

        // Suggestion chips
        const suggestionChips = document.querySelectorAll('.suggestion-chip');
        suggestionChips.forEach(chip => {
            chip.addEventListener('click', () => {
                this.messageInput.value = chip.textContent.trim();
                this.sendMessage();
            });
        });

        // Auto-resize textarea
        this.messageInput.addEventListener('input', () => {
            this.messageInput.style.height = 'auto';
            this.messageInput.style.height = this.messageInput.scrollHeight + 'px';
        });

        // Focus input on load
        this.messageInput.focus();
    }

    handleKeyPress(e) {
        // Send on Enter (without Shift)
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            this.sendMessage();
        }
    }

    handleInput() {
        const message = this.messageInput.value.trim();
        this.sendButton.disabled = message.length === 0;
        
        // Update character counter if exists
        const charCounter = document.querySelector('.char-counter');
        if (charCounter) {
            charCounter.textContent = `${message.length}/500`;
        }
    }

    async sendMessage() {
        const message = this.messageInput.value.trim();
        
        if (!message) {
            this.showNotification('Vui lòng nhập câu hỏi!', 'warning');
            return;
        }

        // Hide welcome message
        if (this.welcomeMessage) {
            this.welcomeMessage.style.display = 'none';
        }

        // Add user message to chat
        this.addMessage(message, 'user');
        
        // Clear input
        this.messageInput.value = '';
        this.messageInput.style.height = 'auto';
        this.handleInput();
        
        // Show typing indicator
        this.showTypingIndicator();

        try {
            // Call API
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ message: message })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            
            // Hide typing indicator
            this.hideTypingIndicator();
            
            // Add bot response
            if (data.reply) {
                this.addMessage(data.reply, 'bot');
            } else {
                throw new Error('Không nhận được phản hồi từ AI');
            }

        } catch (error) {
            console.error('Error:', error);
            this.hideTypingIndicator();
            this.addMessage(
                'Xin lỗi, đã có lỗi xảy ra khi kết nối với AI. Vui lòng thử lại sau! 😔',
                'bot',
                true
            );
            this.showNotification('Lỗi kết nối với AI', 'error');
        }
    }

    addMessage(text, sender, isError = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message`;
        
        const avatar = document.createElement('div');
        avatar.className = 'message-avatar';
        avatar.textContent = sender === 'user' ? '👤' : '🤖';
        
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        const bubbleDiv = document.createElement('div');
        bubbleDiv.className = 'message-bubble';
        
        if (isError) {
            bubbleDiv.style.background = '#FEE2E2';
            bubbleDiv.style.color = '#991B1B';
        }
        
        // Format message with markdown-like syntax
        bubbleDiv.innerHTML = this.formatMessage(text);
        
        const timeDiv = document.createElement('div');
        timeDiv.className = 'message-time';
        timeDiv.textContent = this.getCurrentTime();
        
        contentDiv.appendChild(bubbleDiv);
        contentDiv.appendChild(timeDiv);
        
        messageDiv.appendChild(avatar);
        messageDiv.appendChild(contentDiv);
        
        this.chatMessages.appendChild(messageDiv);
        
        // Scroll to bottom
        this.scrollToBottom();
    }

    formatMessage(text) {
        // Convert markdown-like syntax to HTML
        let formatted = text;
        
        // Bold: **text** or __text__
        formatted = formatted.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
        formatted = formatted.replace(/__(.+?)__/g, '<strong>$1</strong>');
        
        // Italic: *text* or _text_
        formatted = formatted.replace(/\*(.+?)\*/g, '<em>$1</em>');
        formatted = formatted.replace(/_(.+?)_/g, '<em>$1</em>');
        
        // Code: `code`
        formatted = formatted.replace(/`(.+?)`/g, '<code style="background: #E5E7EB; padding: 2px 6px; border-radius: 4px; font-family: monospace;">$1</code>');
        
        // Line breaks
        formatted = formatted.replace(/\n/g, '<br>');
        
        // Lists: - item or * item
        formatted = formatted.replace(/^[\-\*]\s+(.+)$/gm, '<li>$1</li>');
        if (formatted.includes('<li>')) {
            formatted = formatted.replace(/(<li>.*<\/li>)/s, '<ul style="margin: 10px 0; padding-left: 20px;">$1</ul>');
        }
        
        // Numbered lists: 1. item, 2. item
        formatted = formatted.replace(/^\d+\.\s+(.+)$/gm, '<li>$1</li>');
        
        // Headers: ### text
        formatted = formatted.replace(/^###\s+(.+)$/gm, '<h3 style="font-size: 1.1rem; margin: 10px 0 5px 0; color: #4F46E5;">$1</h3>');
        formatted = formatted.replace(/^##\s+(.+)$/gm, '<h2 style="font-size: 1.2rem; margin: 10px 0 5px 0; color: #4F46E5;">$1</h2>');
        
        return formatted;
    }

    showTypingIndicator() {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message bot-message';
        messageDiv.id = 'typing-message';
        
        const avatar = document.createElement('div');
        avatar.className = 'message-avatar';
        avatar.textContent = '🤖';
        
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        const typingDiv = document.createElement('div');
        typingDiv.className = 'typing-indicator show';
        typingDiv.innerHTML = '<div class="typing-dot"></div><div class="typing-dot"></div><div class="typing-dot"></div>';
        
        contentDiv.appendChild(typingDiv);
        messageDiv.appendChild(avatar);
        messageDiv.appendChild(contentDiv);
        
        this.chatMessages.appendChild(messageDiv);
        this.scrollToBottom();
    }

    hideTypingIndicator() {
        const typingMessage = document.getElementById('typing-message');
        if (typingMessage) {
            typingMessage.remove();
        }
    }

    scrollToBottom() {
        setTimeout(() => {
            this.chatMessages.scrollTop = this.chatMessages.scrollHeight;
        }, 100);
    }

    getCurrentTime() {
        const now = new Date();
        const hours = now.getHours().toString().padStart(2, '0');
        const minutes = now.getMinutes().toString().padStart(2, '0');
        return `${hours}:${minutes}`;
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            background: ${type === 'error' ? '#EF4444' : type === 'warning' ? '#F59E0B' : '#10B981'};
            color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            animation: slideInRight 0.3s ease-out;
        `;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        // Remove after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.3s ease-out';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
}

// Add notification animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Initialize chatbot when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new AIChatbot();
});

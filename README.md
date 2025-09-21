# Adaptive E-learning Management System

An intelligent learning platform that adapts to student needs using AI-powered personalization, comprehensive course management, and advanced assessment tools.

![Adaptive E-learning System Banner](https://via.placeholder.com/1200x300?text=Adaptive+E-learning+System)

## 📋 Overview

The Adaptive E-learning Management System is a comprehensive platform designed to revolutionize online education by providing personalized learning experiences. Using advanced AI algorithms, the system analyzes student performance, identifies knowledge gaps, and recommends tailored learning paths to maximize educational outcomes.

Key capabilities include:

- Personalized learning roadmaps based on individual progress and skill level
- Intelligent content recommendation and adaptive assessments
- Comprehensive course management and content delivery
- Secure user authentication and payment processing
- Detailed analytics and reporting for administrators and educators
- AI-powered tutoring and question generation

## 🚀 Features and User Roles

The system implements a comprehensive role-based access control with four distinct user types:

### Learner Role

- **Profile Management**

  - Complete user profile with personal information
  - Profile customization with avatar and biography
  - Track enrollment history and course progress
  - View certificates and achievements

- **Course Exploration**

  - Browse course catalog with advanced filtering and search
  - View detailed course information, syllabi, and instructor profiles
  - Access course ratings, reviews, and learner feedback
  - Bookmark favorite courses for later enrollment

- **Learning Experience**

  - Access to enrolled courses and all learning materials
  - Video lectures with interactive transcripts and note-taking
  - Downloadable resources and supplementary materials
  - Chapter-based quizzes and comprehensive assessments
  - Progress tracking with visual indicators
  - AI-generated personalized learning schedule
  - Comprehensive test history and performance analytics

- **Interactive Features**

  - Live Q&A sessions with AI tutoring assistant
  - Discussion forums for peer-to-peer learning
  - Direct messaging with instructors for questions
  - Progress sharing and social learning features

- **Payment System**
  - Multiple payment methods (credit/debit cards, MoMo, ZaloPay)
  - Bank transfer and QR code payment options
  - Secure transaction processing and receipt generation
  - Payment history and invoice management

### Instructor Role (all Learner features plus)

- **Course Creation**

  - Intuitive course builder with section and lecture management
  - Rich content editor for creating engaging learning materials
  - Video upload and management with automatic transcription
  - Quiz and assessment creation with various question types
  - Curriculum planning and learning path design

- **Student Management**

  - Monitor student progress and engagement metrics
  - Grade assignments and provide personalized feedback
  - Communicate with enrolled students through announcements
  - Generate performance reports for course improvement

- **Financial Dashboard**

  - Track course earnings and revenue statistics
  - Manage payout methods and transaction history
  - Analyze enrollment trends and conversion metrics
  - Set pricing strategies and promotional discounts

- **Analytics Tools**
  - Content engagement metrics and viewer statistics
  - Quiz performance analysis and difficulty assessment
  - Student retention and completion rate tracking
  - Detailed feedback analysis for course improvement

### Admin Role (all Instructor features plus)

- **Platform Management**

  - Approve and feature quality courses
  - Manage categories and learning paths
  - Configure system settings and parameters
  - Monitor platform performance and stability

- **User Administration**

  - Manage all user accounts across roles
  - Review and approve instructor applications
  - Handle user issues and support requests
  - Implement user restrictions when necessary

- **Content Moderation**

  - Review course content for quality assurance
  - Ensure compliance with platform guidelines
  - Manage reported content and user complaints
  - Feature and promote outstanding courses

- **Financial Operations**

  - Process instructor payouts and commissions
  - Generate financial reports and analytics
  - Manage refund requests and billing issues
  - Configure payment gateways and methods

- **System Analytics**
  - Platform-wide usage statistics and trends
  - User engagement and retention metrics
  - Revenue tracking and financial performance
  - Course effectiveness and completion rates

### System Admin Role (all Admin features plus)

- **Technical Configuration**

  - Database management and optimization
  - Server configuration and performance tuning
  - Integration with third-party services
  - System backup and disaster recovery

- **Security Management**

  - User authentication and authorization control
  - Data protection and privacy compliance
  - Security auditing and vulnerability assessment
  - Implement and maintain security protocols

- **API Management**

  - Configure and monitor API endpoints
  - Manage rate limiting and access controls
  - Integrate with external services and platforms
  - Monitor API performance and usage statistics

- **Development Operations**
  - Deploy system updates and new features
  - Manage development environments
  - Coordinate with development team
  - Conduct system testing and quality assurance

## 💻 Tech Stack

### Backend

- Java Servlet & JSP for server-side processing
- JSTL for dynamic content generation
- Filters and Listeners for request/response handling
- JavaBeans for encapsulating business logic
- JDBC/JPA for database connectivity
- RESTful APIs for client-server communication

### Frontend

- HTML5, CSS3, and JavaScript for UI/UX
- Responsive design for multi-device compatibility
- Modern UI components and interactive elements
- Client-side validation and dynamic content loading

### Database

- SQL Server for structured data storage
- Optimized schema design for educational content
- Transaction management for data integrity

### AI Services

- Python with Transformers library for NLP tasks
- LangChain for AI agent orchestration
- PEFT/LoRA for efficient fine-tuning of language models (maybe not necessary)
- RAG (Retrieval-Augmented Generation) pipeline for accurate responses
- Vector databases for semantic search capabilities

### Deployment

- Kaggle for model training and demonstration
- Ngrok + Nginx reverse proxy for API integration
- Apache Tomcat for Java web application hosting

## 🏗️ Architecture

The system follows a modular architecture with clear separation of concerns:

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Client Layer   │────>│   Web Layer     │────>│  Service Layer  │
│  (HTML/CSS/JS)  │<────│  (Servlets/JSP) │<────│  (Java Beans)   │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   AI Services   │<────│   Integration   │<────│    Data Layer   │
│  (Python/Flask) │────>│  (REST/Proxy)   │────>│  (JDBC/JPA/SQL) │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

- **Client Layer**: Handles user interface and client-side logic
- **Web Layer**: Processes HTTP requests/responses via Servlets and JSP
- **Service Layer**: Implements business logic and application workflows
- **Data Layer**: Manages data persistence and database operations
- **AI Services**: Provides intelligent features through machine learning models
- **Integration Layer**: Facilitates communication between Java backend and Python AI services

## 🧠 AI Integration

### Adaptive Learning Agent

The system incorporates an intelligent agent that:

1. Analyzes student performance data from completed assessments
2. Classifies students into appropriate skill levels (beginner/intermediate/advanced)
3. Generates personalized learning roadmaps based on individual needs
4. Tracks progress and adjusts recommendations over time

### RAG Pipeline for Question Answering

```
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│ User Question │───>│  Retrieval    │───>│  Generation   │───> Response
└───────────────┘    │  Component    │    │  Component    │
                     └───────────────┘    └───────────────┘
                            │                    ▲
                            ▼                    │
                     ┌───────────────┐          │
                     │ Vector Store  │──────────┘
                     │ (Course Data) │
                     └───────────────┘
```

- Questions are processed and relevant context is retrieved from vector database
- Language model generates accurate responses grounded in course materials
- System provides citations and references to learning resources

### Automatic Question Generation

The AI can generate various types of assessment questions:

- Multiple-choice questions with distractor analysis
- Fill-in-the-blank and matching exercises
- Short answer and essay questions with evaluation criteria
- Case studies and problem-solving scenarios

### AI Tutoring Assistant

Students can access an AI tutor that provides:

- Just-in-time help with difficult concepts
- Step-by-step explanations of problem-solving approaches
- Clarification of course material and terminology
- Personalized feedback on performance and study habits

## ⚙️ Setup Instructions

### System Requirements

- Java 11 or higher
- Apache Tomcat 9.0+
- SQL Server 2019+
- Python 3.10+ (for AI services)
- Kaggle account (for model training)
- Ngrok and Nginx (for AI service integration)

### Database Setup

1. Install SQL Server 2019 or higher
2. Run the database creation script:
   ```sql
   -- From the /db/schema.sql file
   CREATE DATABASE AdaptiveElearning;
   USE AdaptiveElearning;
   -- Additional schema creation statements
   ```
3. Configure the database connection in `web.xml`

### Web Application Deployment

1. Clone the repository:

   ```bash
   git clone https://github.com/macdogiahuy/PRJ_Adaptive-E-learning-System.git
   cd PRJ_Adaptive-E-learning-System
   ```

2. Configure the application settings in `web.xml`:

   ```xml
   <context-param>
     <param-name>db.url</param-name>
     <param-value>jdbc:sqlserver://localhost:1433;database=AdaptiveElearning</param-value>
   </context-param>
   <!-- Additional configuration parameters -->
   ```

3. Build the project using Ant:

   ```bash
   ant build
   ```

4. Deploy the WAR file to Tomcat:
   - Copy the generated `adaptive-elearning.war` to Tomcat's `webapps` directory
   - Start or restart Tomcat

### AI Service Configuration

1. Launch the Kaggle notebook for AI model deployment:

   - Navigate to the `/ai/notebooks` directory
   - Upload the notebook to Kaggle
   - Enable GPU acceleration and run the notebook

2. Set up the Flask API with ngrok:

   ```bash
   cd ai/api
   pip install -r requirements.txt
   python app.py
   ```

3. In a separate terminal, start ngrok:

   ```bash
   ngrok http 5000
   ```

4. Configure Nginx as a reverse proxy:

   ```nginx
   location /api/ask {
     proxy_pass http://<ngrok-url>/ask;
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
   }
   ```

5. Restart Nginx to apply changes

## 🔍 Usage Examples

### Student Learning Workflow

1. **Course Enrollment**

   ```http
   POST /elearning/api/courses/enroll
   {
     "courseId": 123,
     "userId": 456,
     "paymentMethod": "credit_card"
   }
   ```

2. **Accessing Learning Materials**

   ```http
   GET /elearning/api/courses/123/chapters/2/lessons
   ```

3. **Taking an Assessment**

   ```http
   POST /elearning/api/assessment/submit
   {
     "assessmentId": 789,
     "userId": 456,
     "answers": [
       {"questionId": 1, "selectedOption": "B"},
       {"questionId": 2, "selectedOption": "A"},
       ...
     ]
   }
   ```

4. **Requesting Personalized Recommendations**
   ```http
   GET /elearning/api/students/456/recommendations
   ```

### AI Assistant Interaction

**Request:**

```http
POST /elearning/api/ask
Content-Type: application/json

{
  "question": "Tôi muốn lộ trình học phù hợp khi bị yếu về SQL?",
  "userId": 456,
  "courseId": 123
}
```

**Response:**

```json
{
  "answer": "Bạn hiện đang ở mức Beginner về SQL. Lộ trình gợi ý: \n1. Ôn lại kiến thức cơ bản SELECT/WHERE.\n2. Làm bài tập JOIN và GROUP BY. \n3. Sau đó học Stored Procedure và Transaction.",
  "resources": [
    {
      "title": "SQL Fundamentals - Chapter 2",
      "type": "lesson",
      "url": "/courses/123/chapters/2/lessons/5"
    },
    {
      "title": "JOIN Practice Problems",
      "type": "exercise",
      "url": "/courses/123/exercises/12"
    }
  ]
}
```

### Administrator Course Management

**Creating a New Course:**

```http
POST /elearning/api/admin/courses
Content-Type: application/json

{
  "title": "Advanced Database Design",
  "description": "Learn to design efficient and scalable database systems",
  "category": "Database",
  "price": 499000,
  "instructor": "John Doe",
  "duration": "8 weeks",
  "level": "Intermediate"
}
```

## � Future Work

- **Mobile Application**: Develop native mobile apps for iOS and Android
- **Advanced Analytics**: Implement predictive analytics for student success
- **Enhanced AI Models**: Integrate more specialized models for domain-specific tutoring
- **Gamification**: Add achievement badges, leaderboards, and reward systems
- **Peer Learning**: Implement collaborative learning spaces and group projects
- **Content Authoring**: Create intuitive tools for educators to develop adaptive content
- **Accessibility Features**: Ensure compliance with WCAG guidelines for all users
- **Multi-language Support**: Expand platform to support multiple languages

## 🛡️ Branch Protection

This repository implements strict branch protection rules to maintain code quality and ensure proper review processes:

- **Protected main branch** - Direct pushes to main are not allowed
- **Required pull requests** - All changes must go through pull requests
- **Required reviews** - Code owners must approve changes before merging
- **Status checks** - CI pipeline must pass before merging
- **Up-to-date branches** - Branches must be current with main before merging

## 🚀 Getting Started

### Prerequisites

- Java 11 or higher
- Apache Tomcat 9.0+
- SQL Server
- Maven 3.6+

### Development Workflow

1. **Fork the repository** and clone your fork
2. **Create a feature branch** from main: `git checkout -b feature/your-feature`
3. **Make your changes** following our coding guidelines
4. **Add tests** for new functionality
5. **Run tests** to ensure everything works: `mvn test`
6. **Submit a pull request** using our PR template

## 📋 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for detailed information about:

- Code of conduct
- Development setup
- Coding standards
- Pull request process
- Branch protection rules

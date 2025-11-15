# Adaptive E-Learning System - Maven Migration Guide

## 🚀 Đã chuyển đổi từ Ant sang Maven

### Cấu trúc project mới:

```
Adaptive_Elearning/
├── pom.xml                          # Maven configuration
├── src/
│   ├── main/
│   │   ├── java/                    # Java source code (đã di chuyển từ src/java/)
│   │   │   ├── controller/
│   │   │   ├── dao/
│   │   │   ├── model/
│   │   │   ├── services/
│   │   │   ├── servlet/
│   │   │   ├── utils/
│   │   │   └── userDAO/
│   │   ├── resources/               # Configuration files (đã di chuyển từ src/conf/)
│   │   │   ├── env.properties
│   │   │   ├── persistence.xml
│   │   │   └── MANIFEST.MF
│   │   └── webapp/                  # Web content (đã di chuyển từ web/)
│   │       ├── WEB-INF/
│   │       ├── assests/
│   │       ├── assets/
│   │       └── *.jsp
│   └── test/
│       ├── java/                    # Test source code
│       └── resources/               # Test resources
├── target/                          # Maven build output (auto-generated)
│   ├── classes/
│   ├── test-classes/
│   └── Adaptive_Elearning.war
└── [old structure preserved for reference]
```

## 📋 Các bước để chạy với Maven:

### 1. Cài đặt Apache Maven
```bash
# Download từ: https://maven.apache.org/download.cgi
# Hoặc sử dụng package manager:
# Windows (với Chocolatey): choco install maven
# macOS (với Homebrew): brew install maven
```

### 2. Verify Maven installation:
```bash
mvn --version
```

### 3. Build project:
```bash
# Clean và compile
mvn clean compile

# Chạy tests
mvn test

# Build WAR file
mvn clean package

# Build và skip tests (nếu cần)
mvn clean package -DskipTests
```

### 4. Chạy với embedded Tomcat:
```bash
# Chạy server development
mvn tomcat7:run

# Hoặc deploy lên Tomcat external
# Copy target/Adaptive_Elearning.war vào tomcat/webapps/
```

### 5. Deploy:
```bash
# Build production
mvn clean package -Pprod

# WAR file sẽ ở: target/Adaptive_Elearning.war
```

## 🔧 Maven Commands hữu ích:

```bash
# Clean build artifacts
mvn clean

# Compile source code
mvn compile

# Run unit tests
mvn test

# Create WAR file
mvn package

# Install to local repository
mvn install

# Show dependency tree
mvn dependency:tree

# Update project version
mvn versions:set -DnewVersion=1.1.0

# Generate project reports
mvn site
```

## 📦 Dependencies được quản lý:

- **Jakarta EE 10**: Servlet, JSP, JSTL
- **EclipseLink**: JPA Implementation
- **MS SQL Server**: Database driver
- **JSON Processing**: org.json, Gson
- **Jakarta Mail**: Email functionality
- **SLF4J + Logback**: Logging
- **JUnit 5**: Testing framework

## 🔀 IDE Support:

### IntelliJ IDEA:
1. File → Open → Chọn pom.xml
2. Import as Maven project

### Eclipse:
1. File → Import → Existing Maven Projects
2. Browse đến thư mục chứa pom.xml

### NetBeans:
1. File → Open Project
2. Chọn thư mục chứa pom.xml

### VS Code:
1. Install Extension Pack for Java
2. Open folder chứa pom.xml

## 🚨 Migration Notes:

### ✅ Đã hoàn thành:
- [x] Tạo pom.xml với tất cả dependencies
- [x] Di chuyển Java code sang src/main/java
- [x] Di chuyển resources sang src/main/resources  
- [x] Di chuyển web content sang src/main/webapp
- [x] Cấu hình Maven plugins (compiler, war, tomcat)
- [x] Setup profiles (dev, prod)
- [x] Cập nhật .gitignore cho Maven

### ⚠️ Cần kiểm tra:
- [ ] Database connection configuration
- [ ] Google OAuth credentials path
- [ ] Static resource paths trong JSP
- [ ] Context path configuration

### 🔄 Cấu trúc cũ vẫn được giữ lại:
- `src/java/` → Preserved (có thể xóa sau khi verify)
- `src/conf/` → Preserved  
- `web/` → Preserved
- `lib/` → Preserved (không cần thiết với Maven)
- `nbproject/` → Preserved (NetBeans specific)

## 🎯 Production Deployment:

```bash
# Build for production
mvn clean package -Pprod

# Copy WAR to Tomcat
cp target/Adaptive_Elearning.war /path/to/tomcat/webapps/

# Or use Maven Tomcat plugin
mvn tomcat7:deploy
```

## 📝 Environment Configuration:

Cập nhật `src/main/resources/env.properties`:
```properties
# Database Configuration
DB_URL=jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=CourseHubDB;encrypt=true;trustServerCertificate=true;
DB_USER=your_username
DB_PASSWORD=your_password

# Google OAuth
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
REDIRECT_URI=http://localhost:8080/Adaptive_Elearning/oauth2callback
```

## 🏃‍♂️ Quick Start:

1. Clone project
2. `cd Adaptive_Elearning`
3. `mvn clean package`
4. `mvn tomcat7:run`
5. Open http://localhost:8080/Adaptive_Elearning
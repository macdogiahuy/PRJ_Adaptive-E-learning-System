# Security Setup Guide

## Configuration Overview

This project uses environment-based configuration to keep sensitive information secure, including database credentials and Google OAuth settings.

### Setup Steps:

1. **Copy the template file:**

   ```bash
   cp src/conf/env.properties.example src/conf/env.properties
   ```

2. **Configure Database Settings:**

   ```properties
   DB_URL=jdbc:sqlserver://localhost\\YOUR_INSTANCE;databaseName=YOUR_DB;encrypt=true;trustServerCertificate=true;
   DB_USER=your_username
   DB_PASSWORD=your_password
   ```

3. **Configure Google OAuth (if using Google login):**

   **Step 3.1: Create Google Cloud Project**

   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable Google+ API or People API

   **Step 3.2: Setup OAuth Credentials**

   - Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client ID"
   - Choose "Web application"
   - Add authorized redirect URI: `http://localhost:8080/YourAppName/auth/google/callback`
   - Copy Client ID and Client Secret

   **Step 3.3: Update env.properties**

   ```properties
   GOOGLE_CLIENT_ID=REDACTED
   GOOGLE_CLIENT_SECRET=REDACTED
   REDIRECT_URI=http://localhost:8080/YourAppName/auth/google/callback
   ```

4. **Important:** Never commit the `env.properties` file to git. It's already in `.gitignore`.

### Files Structure:

- `src/conf/env.properties` - Your actual credentials (gitignored)
- `src/conf/env.properties.example` - Template file (safe to commit)
- `src/java/utils/EnvConfig.java` - Loads environment properties
- `src/java/dao/DBConnection.java` - Uses environment variables for DB connection
- `src/java/services/GoogleAuthService.java` - Google OAuth authentication

### Security Features:

- ✅ Database credentials stored in separate file
- ✅ Google OAuth keys externalized
- ✅ Sensitive files excluded from git
- ✅ Template provided for easy setup
- ✅ No hardcoded passwords or API keys in source code
- ✅ Proper error handling for missing configuration

### For New Developers:

1. Clone the repository
2. Copy `env.properties.example` to `env.properties`
3. Update with your local database settings
4. If using Google login, setup Google OAuth credentials
5. Run the application

### Security Checklist:

- [ ] env.properties file created and configured
- [ ] Database credentials not hardcoded
- [ ] Google OAuth credentials not hardcoded
- [ ] .gitignore includes sensitive files
- [ ] No API keys in source code
- [ ] REDIRECT_URI matches your local setup

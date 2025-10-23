# ENVIRONMENT SETUP GUIDE

## 🔐 Credentials Configuration

### Important Security Notice
**NEVER commit real credentials to the repository!** The `env.properties` file is ignored by git to prevent accidental exposure of sensitive information.

### Setup Instructions

1. **Copy the template file:**
   ```bash
   cp src/main/java/env.properties.template src/main/java/env.properties
   ```

2. **Edit `src/main/java/env.properties` with your actual values:**

   **Database Configuration:**
   - Replace `your_db_username` with your SQL Server username (e.g., `sa`)
   - Replace `your_db_password` with your SQL Server password
   - Update database name if different from `CourseHubDB`

   **Google OAuth Setup:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Set authorized redirect URI: `http://localhost:8080/Adaptive_Elearning/auth/google/callback`
   - Copy Client ID and Client Secret to env.properties

   **Email Configuration:**
   - Use your Gmail account for SMTP
   - Generate an App Password (not your regular password)
   - Update SMTP settings accordingly

### Example env.properties (with fake values)
```properties
# Database Configuration
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=false;trustServerCertificate=true
DB_USERNAME=sa
DB_PASSWORD=MySecretPassword123

# Google OAuth Configuration
GOOGLE_CLIENT_ID=REDACTED
GOOGLE_CLIENT_SECRET=REDACTED
GOOGLE_REDIRECT_URI=http://localhost:8080/Adaptive_Elearning/auth/google/callback

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=myemail@gmail.com
SMTP_PASSWORD=abcd efgh ijkl mnop

# Application Configuration
APP_BASE_URL=http://localhost:8080/Adaptive_Elearning
```

### 🚨 Security Best Practices

1. **Never share credentials** in screenshots, logs, or documentation
2. **Use environment-specific files** for different deployments
3. **Rotate credentials regularly**
4. **Use strong passwords** and enable 2FA where possible
5. **Review .gitignore** to ensure sensitive files are excluded

### Troubleshooting

- If you get "file not found" errors, make sure `env.properties` exists in `src/main/java/`
- If OAuth fails, verify redirect URI matches exactly in Google Console
- If database connection fails, check SQL Server is running and credentials are correct
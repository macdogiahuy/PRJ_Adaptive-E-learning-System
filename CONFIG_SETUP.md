# Setup Instructions for Environment Configuration

## Important: Configuration Files Setup

Before running the application, you need to set up your environment configuration files:

### 1. Database Configuration
Copy the template file and update with your actual database credentials:
```bash
cp src/conf/env.properties.example src/conf/env.properties
```

Then edit `src/conf/env.properties` with your actual values:
- `DB_USER`: Your SQL Server username
- `DB_PASSWORD`: Your SQL Server password
- `DB_URL`: Your database connection string

### 2. Google OAuth Configuration
Update the Google OAuth credentials in `env.properties`:
- `GOOGLE_CLIENT_ID`: Your Google OAuth Client ID
- `GOOGLE_CLIENT_SECRET`: Your Google OAuth Client Secret

### 3. Security Notice
⚠️ **NEVER commit actual credentials to Git!** 
- The `env.properties` files are listed in `.gitignore`
- Only commit the `.example` template files
- Each developer should maintain their own local `env.properties` files

### 4. File Locations
The application looks for configuration in these locations:
- `src/conf/env.properties` (primary)
- `src/main/resources/env.properties` (backup)

Make sure both locations have the same configuration for consistency.
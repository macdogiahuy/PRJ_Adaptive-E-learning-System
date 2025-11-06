package servlet;

import dao.UserDAO;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Servlet for handling Facebook OAuth2 callback
 * Processes authentication code and retrieves user info
 */
@WebServlet("/facebook-callback")
public class FacebookCallbackServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FacebookCallbackServlet.class.getName());
    
    // Facebook App credentials
    private static final String FACEBOOK_APP_ID = "1174370030850794";
    private static final String FACEBOOK_APP_SECRET = "ef2cd8fc3e5bc51ffda833b6d73d9d8b";
    private static final String REDIRECT_URI = "https://unabased-melodie-collapsable.ngrok-free.dev/Adaptive_Elearning/facebook-callback";
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
        if (error != null) {
            LOGGER.log(Level.WARNING, "Facebook OAuth error: {0}", error);
            response.sendRedirect(request.getContextPath() + "/login?error=facebook_denied");
            return;
        }
        
        if (code == null || code.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "No authorization code received from Facebook");
            response.sendRedirect(request.getContextPath() + "/login?error=no_code");
            return;
        }
        
        try {
            // Exchange code for access token
            String accessToken = getAccessToken(code);
            
            if (accessToken == null) {
                throw new Exception("Failed to get access token");
            }
            
            // Get user info from Facebook
            JsonObject userInfo = getUserInfo(accessToken);
            
            if (userInfo == null) {
                throw new Exception("Failed to get user info");
            }
            
            // Process Facebook user
            String facebookId = userInfo.get("id").getAsString();
            String email = userInfo.has("email") ? userInfo.get("email").getAsString() : null;
            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : "Facebook User";
            
            LOGGER.log(Level.INFO, "Facebook user: ID={0}, Email={1}, Name={2}", 
                      new Object[]{facebookId, email, name});
            
            // Check if user exists or create new one
            Users user = null;
            if (email != null) {
                user = userDAO.findByEmail(email);
            }
            
            if (user == null) {
                // Create new user
                user = new Users();
                user.setUserName(email != null ? email : "facebook_" + facebookId);
                user.setEmail(email);
                user.setFullName(name);
                user.setMetaFullName(name);
                user.setPassword(""); // No password for OAuth users
                user.setRole("Student");
                user.setToken("");
                user.setRefreshToken("");
                user.setIsVerified(true);
                user.setIsApproved(true);
                user.setAccessFailedCount((short) 0);
                user.setLoginProvider("Facebook");
                user.setProviderKey(facebookId);
                
                boolean created = userDAO.registerUser(user);
                
                if (!created) {
                    throw new Exception("Failed to create user account");
                }
                
                // Re-fetch user to get full data
                user = userDAO.findByEmail(email);
                
                LOGGER.log(Level.INFO, "Created new user from Facebook: {0}", user.getUserName());
            } else {
                LOGGER.log(Level.INFO, "Existing user logged in via Facebook: {0}", user.getUserName());
            }
            
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            LOGGER.log(Level.INFO, "User {0} logged in successfully via Facebook", user.getUserName());
            
            // Redirect to home
            response.sendRedirect(request.getContextPath() + "/home");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing Facebook callback", e);
            response.sendRedirect(request.getContextPath() + "/login?error=facebook_processing_failed");
        }
    }
    
    /**
     * Exchange authorization code for access token
     */
    private String getAccessToken(String code) throws IOException {
        String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token?" +
                "client_id=" + FACEBOOK_APP_ID +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8") +
                "&client_secret=" + FACEBOOK_APP_SECRET +
                "&code=" + code;
        
        URL url = new URL(tokenUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            
            while ((line = in.readLine()) != null) {
                response.append(line);
            }
            in.close();
            
            JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
            return jsonResponse.get("access_token").getAsString();
        }
        
        return null;
    }
    
    /**
     * Get user info from Facebook Graph API
     */
    private JsonObject getUserInfo(String accessToken) throws IOException {
        String userInfoUrl = "https://graph.facebook.com/v18.0/me?" +
                "fields=id,name,email" +
                "&access_token=" + accessToken;
        
        URL url = new URL(userInfoUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            
            while ((line = in.readLine()) != null) {
                response.append(line);
            }
            in.close();
            
            return JsonParser.parseString(response.toString()).getAsJsonObject();
        }
        
        return null;
    }
}

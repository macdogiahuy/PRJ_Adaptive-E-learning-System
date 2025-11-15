package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for Facebook OAuth2 login
 * Initiates Facebook authentication flow
 */
@WebServlet("/facebook-login")
public class FacebookLoginServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FacebookLoginServlet.class.getName());
    
    // Facebook App credentials
    private static final String FACEBOOK_APP_ID = "1174370030850794";
    private static final String FACEBOOK_APP_SECRET = "ef2cd8fc3e5bc51ffda833b6d73d9d8b";
    private static final String REDIRECT_URI = "https://unabased-melodie-collapsable.ngrok-free.dev/Adaptive_Elearning/facebook-callback";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Build Facebook OAuth URL
            String facebookAuthUrl = "https://www.facebook.com/v18.0/dialog/oauth?" +
                    "client_id=" + FACEBOOK_APP_ID +
                    "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8") +
                    "&scope=" + URLEncoder.encode("email,public_profile", "UTF-8") +
                    "&response_type=code" +
                    "&state=" + generateState();
            
            LOGGER.log(Level.INFO, "Redirecting to Facebook OAuth: {0}", facebookAuthUrl);
            
            // Redirect to Facebook
            response.sendRedirect(facebookAuthUrl);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initiating Facebook login", e);
            response.sendRedirect(request.getContextPath() + "/login?error=facebook_init_failed");
        }
    }
    
    /**
     * Generate random state for CSRF protection
     */
    private String generateState() {
        return String.valueOf(System.currentTimeMillis());
    }
}

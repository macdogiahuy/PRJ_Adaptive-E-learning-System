package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import jakarta.servlet.http.HttpSession;
import model.Users;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Listener to track online users
 * Increments counter when user logs in (session created with user attribute)
 * Decrements counter when user logs out or session expires
 * @author LP
 */
@WebListener
public class OnlineUserListener implements HttpSessionListener {
    
    private static final Logger LOGGER = Logger.getLogger(OnlineUserListener.class.getName());
    public static final String ONLINE_USERS_KEY = "onlineUsersCount";
    public static final String USER_COUNTED_KEY = "userCounted";
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        // Initialize counter if not exists and increment immediately
        synchronized (context) {
            Integer count = (Integer) context.getAttribute(ONLINE_USERS_KEY);
            if (count == null) {
                count = 0;
            }
            
            // Increment counter for new session (visitor accessing site)
            count++;
            context.setAttribute(ONLINE_USERS_KEY, count);
            session.setAttribute(USER_COUNTED_KEY, true);
            
            LOGGER.log(Level.INFO, "New visitor session created. Online users: {0}", count);
        }
    }
    
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        
        // Check if this session had a logged-in user
        Boolean userCounted = (Boolean) session.getAttribute(USER_COUNTED_KEY);
        
        if (userCounted != null && userCounted) {
            // Decrement online users count
            synchronized (context) {
                Integer count = (Integer) context.getAttribute(ONLINE_USERS_KEY);
                if (count == null) {
                    count = 0;
                }
                
                if (count > 0) {
                    count--;
                    context.setAttribute(ONLINE_USERS_KEY, count);
                    LOGGER.log(Level.INFO, "User session destroyed. Online users: {0}", count);
                }
            }
        }
        
        LOGGER.log(Level.FINE, "Session destroyed: {0}", session.getId());
    }
    
    /**
     * Call this method when a user logs in (just for logging, counter already incremented in sessionCreated)
     */
    public static void userLoggedIn(HttpSession session) {
        // Counter already incremented when session was created
        // This method is now just for logging purposes
        
        ServletContext context = session.getServletContext();
        Integer count = (Integer) context.getAttribute(ONLINE_USERS_KEY);
        
        Users user = (Users) session.getAttribute("account");
        String username = user != null ? user.getUserName() : "Unknown";
        
        LOGGER.log(Level.INFO, "User {0} logged in. Online users: {1}", 
                  new Object[]{username, count != null ? count : 0});
    }
    
    /**
     * Call this method when a user logs out to decrement the counter
     * Also invalidate session to trigger sessionDestroyed
     */
    public static void userLoggedOut(HttpSession session) {
        ServletContext context = session.getServletContext();
        
        // Check if user was counted for this session
        Boolean userCounted = (Boolean) session.getAttribute(USER_COUNTED_KEY);
        
        if (userCounted != null && userCounted) {
            synchronized (context) {
                Integer count = (Integer) context.getAttribute(ONLINE_USERS_KEY);
                if (count == null) {
                    count = 0;
                }
                
                if (count > 0) {
                    count--;
                    context.setAttribute(ONLINE_USERS_KEY, count);
                    // Mark as not counted so sessionDestroyed won't decrement again
                    session.setAttribute(USER_COUNTED_KEY, false);
                    
                    Users user = (Users) session.getAttribute("account");
                    String username = user != null ? user.getUserName() : "Unknown";
                    LOGGER.log(Level.INFO, "User {0} logged out. Online users: {1}", 
                              new Object[]{username, count});
                }
            }
        }
    }
    
    /**
     * Get current online users count
     */
    public static int getOnlineUsersCount(ServletContext context) {
        Integer count = (Integer) context.getAttribute(ONLINE_USERS_KEY);
        return count != null ? count : 0;
    }
}

package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import jakarta.servlet.http.HttpSession;
import model.Users;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Refactored listener to reliably track logged-in users only.
 * Increments when the "account" attribute is first added to a session;
 * decrements when it is removed or the session is destroyed (if still present).
 * Avoids fragile beforeunload beacons and manual servlet decrement endpoints.
 */
@WebListener
public class OnlineUserListener implements HttpSessionListener, HttpSessionAttributeListener {

    private static final Logger LOGGER = Logger.getLogger(OnlineUserListener.class.getName());

    // Context attribute keys
    public static final String LOGGED_IN_USERS_KEY = "loggedInUsersCount"; // AtomicInteger stored in context
    public static final String ACCOUNT_ATTR = "account";                  // Session attribute holding Users object
    public static final String ACCOUNT_COUNTED_ATTR = "accountCounted";   // Boolean flag per session

    /** Initialize AtomicInteger container if absent */
    private AtomicInteger getOrInitCounter(ServletContext context) {
        synchronized (context) { // minimal sync only during init retrieval
            AtomicInteger ctr = (AtomicInteger) context.getAttribute(LOGGED_IN_USERS_KEY);
            if (ctr == null) {
                ctr = new AtomicInteger(0);
                context.setAttribute(LOGGED_IN_USERS_KEY, ctr);
                LOGGER.log(Level.INFO, "Initialized logged-in user counter.");
            }
            return ctr;
        }
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Do not increment here; we only count authenticated users.
        LOGGER.log(Level.FINE, "Session created: {0}", se.getSession().getId());
        // Ensure counter exists early to avoid later sync contention.
        getOrInitCounter(se.getSession().getServletContext());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        Boolean counted = (Boolean) session.getAttribute(ACCOUNT_COUNTED_ATTR);
        Object acc = session.getAttribute(ACCOUNT_ATTR);
        if (Boolean.TRUE.equals(counted) && acc != null) {
            AtomicInteger ctr = getOrInitCounter(context);
            int newVal = ctr.updateAndGet(v -> v > 0 ? v - 1 : 0); // guard against negative
            LOGGER.log(Level.INFO, "Session destroyed; decremented logged-in users to {0} (session {1})", new Object[]{newVal, session.getId()});
        } else {
            LOGGER.log(Level.FINE, "Session destroyed without logged-in user counted: {0}", session.getId());
        }
    }

    // Attribute listener methods
    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        if (ACCOUNT_ATTR.equals(event.getName())) {
            HttpSession session = event.getSession();
            ServletContext context = session.getServletContext();
            Boolean counted = (Boolean) session.getAttribute(ACCOUNT_COUNTED_ATTR);
            if (!Boolean.TRUE.equals(counted) && event.getValue() instanceof Users) {
                AtomicInteger ctr = getOrInitCounter(context);
                int newVal = ctr.incrementAndGet();
                session.setAttribute(ACCOUNT_COUNTED_ATTR, true);
                Users user = (Users) event.getValue();
                LOGGER.log(Level.INFO, "User {0} logged in; logged-in users: {1}", new Object[]{user.getUserName(), newVal});
            }
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        if (ACCOUNT_ATTR.equals(event.getName())) {
            HttpSession session = event.getSession();
            ServletContext context = session.getServletContext();
            Boolean counted = (Boolean) session.getAttribute(ACCOUNT_COUNTED_ATTR);
            if (Boolean.TRUE.equals(counted)) {
                AtomicInteger ctr = getOrInitCounter(context);
                int newVal = ctr.updateAndGet(v -> v > 0 ? v - 1 : 0);
                session.setAttribute(ACCOUNT_COUNTED_ATTR, false);
                LOGGER.log(Level.INFO, "Account attribute removed; logged-in users: {0}", newVal);
            }
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        if (ACCOUNT_ATTR.equals(event.getName())) {
            // Replacement of account (e.g., role change) should not change count.
            LOGGER.log(Level.FINE, "Account attribute replaced for session {0}", event.getSession().getId());
        }
    }

    /** Convenience accessor used by servlet that exposes count */
    public static int getLoggedInUsersCount(ServletContext context) {
        AtomicInteger ctr = (AtomicInteger) context.getAttribute(LOGGED_IN_USERS_KEY);
        return ctr != null ? ctr.get() : 0;
    }

    // Backwards compatibility methods (now no-ops except logging)
    public static void userLoggedIn(HttpSession session) {
        LOGGER.log(Level.FINE, "userLoggedIn() called explicitly; counting handled automatically.");
    }
    public static void userLoggedOut(HttpSession session) {
        LOGGER.log(Level.FINE, "userLoggedOut() called explicitly; counting handled automatically.");
    }
}

package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.Csrf;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Csrf.ensureToken(req.getSession());
        if (req.getSession().getAttribute("PWD_RESET_OK_USER_ID") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/reset-password.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    if (!Csrf.valid(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

    HttpSession session = req.getSession();
    String userId = (String) session.getAttribute("PWD_RESET_OK_USER_ID");
    
    System.out.println("DEBUG: ResetPasswordServlet.doPost() called");
    System.out.println("DEBUG: userId from session: " + userId);
    
    if (userId == null) { 
        System.out.println("DEBUG: No userId in session, redirecting to login");
        resp.sendRedirect(req.getContextPath() + "/login"); 
        return; 
    }

    String password = req.getParameter("password");
    String confirm  = req.getParameter("confirm");

    System.out.println("DEBUG: password length: " + (password != null ? password.length() : "null"));
    System.out.println("DEBUG: confirm length: " + (confirm != null ? confirm.length() : "null"));

    if (password != null) password = password.trim();
    if (confirm != null)  confirm  = confirm.trim();

    String err = validatePassword(password, confirm);
    if (err != null) {
        req.setAttribute("alertMessage", err);
        req.setAttribute("alertStatus", false);
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/reset-password.jsp").forward(req, resp);
        return;
    }

    boolean ok = userDAO.updatePasswordHash(userId, password);
    userDAO.clearToken(userId);
    session.removeAttribute("PWD_RESET_OK_USER_ID");

    System.out.println("DEBUG: Password update result: " + ok);

    if (ok) {
        System.out.println("DEBUG: Password updated successfully, redirecting to auth");
        req.setAttribute("alertMessage", "Password updated successfully! You can now sign in.");
        req.setAttribute("alertStatus", true);
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(req, resp);
    } else {
        System.out.println("DEBUG: Password update failed");
        req.setAttribute("alertMessage", "Something went wrong. Please try again.");
        req.setAttribute("alertStatus", false);
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/reset-password.jsp").forward(req, resp);
    }
}

  private String validatePassword(String pwd, String confirm) {
    if (pwd == null || confirm == null) return "Please fill all fields.";
    if (!pwd.equals(confirm)) return "Password confirmation does not match.";
    if (pwd.length() < 6) return "Password must be at least 6 characters."; // đặt ngưỡng hợp lý
    if (pwd.length() > 128) return "Password is too long.";
    return null;
}

}

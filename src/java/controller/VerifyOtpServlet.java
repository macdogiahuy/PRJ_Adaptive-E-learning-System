package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;
import utils.Csrf;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private static final int OTP_TTL_MINUTES = 5;

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Csrf.ensureToken(req.getSession());
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/verify-otp.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!Csrf.valid(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");

        if (email == null || otp == null || !otp.matches("\\d{6}")) {
            req.setAttribute("alertMessage", "Invalid input.");
            req.setAttribute("alertStatus", false);
            req.getRequestDispatcher("/WEB-INF/views/Pages/user/verify-otp.jsp").forward(req, resp);
            return;
        }

        Users user = userDAO.findByEmailWithValidOtp(email.trim(), otp, OTP_TTL_MINUTES);
        if (user == null) {
            req.setAttribute("alertMessage", "Invalid or expired code.");
            req.setAttribute("alertStatus", false);
            req.getRequestDispatcher("/WEB-INF/views/Pages/user/verify-otp.jsp").forward(req, resp);
            return;
        }

        req.getSession().setAttribute("PWD_RESET_OK_USER_ID", user.getId());
        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }
}

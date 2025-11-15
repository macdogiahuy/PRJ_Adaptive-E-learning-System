package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;
import utils.Csrf;
import utils.EmailHelper;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ThreadLocalRandom;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final EmailHelper emailHelper = new EmailHelper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("DEBUG: ForgotPasswordServlet.doGet() called");
        System.out.println("DEBUG: Request URI: " + req.getRequestURI());
        System.out.println("DEBUG: Context Path: " + req.getContextPath());
        
        Csrf.ensureToken(req.getSession());
        req.getRequestDispatcher("/WEB-INF/views/Pages/user/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!Csrf.valid(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            req.setAttribute("alertMessage", "Please enter your email.");
            req.setAttribute("alertStatus", false);
            req.getRequestDispatcher("/WEB-INF/views/Pages/user/forgot-password.jsp").forward(req, resp);
            return;
        }
        email = email.trim();

       
        Users user = userDAO.findByEmail(email);
        if (user == null) {
         
            req.setAttribute("alertMessage", "Email not found. Please check and try again.");
            req.setAttribute("alertStatus", false);
            req.getRequestDispatcher("/WEB-INF/views/Pages/user/forgot-password.jsp").forward(req, resp);
            return;
        }

        String otp = String.valueOf(ThreadLocalRandom.current().nextInt(100000, 1000000));
        userDAO.issueResetOtp(user.getId(), otp);

        try {
            String subject = "Your password reset code";
            String body = "Your OTP is: " + otp + " (valid for 5 minutes).";
            emailHelper.sendMail(email, subject, body);

            String next = req.getContextPath() + "/verify-otp?email="
                    + URLEncoder.encode(email, StandardCharsets.UTF_8);
            resp.sendRedirect(next);
        } catch (Exception ex) {
            req.setAttribute("alertMessage", "We couldn't send the email. Please try again later.");
            req.setAttribute("alertStatus", false);
            req.getRequestDispatcher("/WEB-INF/views/Pages/user/forgot-password.jsp").forward(req, resp);
        }
    }
}

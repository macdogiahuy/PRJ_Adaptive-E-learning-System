package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;
import dao.UserDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
     UserDAO userDAO = new UserDAO();
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        if (username == null || password == null) {
            request.setAttribute("alertMessage", "Please enter username and password.");
            request.setAttribute("alertStatus", false);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
            return;
        }
        //login với database
        Users us = userDAO.checkLogin(username, password);

        if (us != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", us);
            session.setAttribute("user", us.getUserName()); 
            session.setAttribute("role", us.getRole());
            
                 if ("yes".equals(rememberMe)) {
                Cookie usernameCookie = new Cookie("username", username);
                usernameCookie.setMaxAge(30 * 24 * 60 * 60); 
                usernameCookie.setPath("/");

//                Cookie passwordCookie = new Cookie("password", password);
//                passwordCookie.setMaxAge(30 * 24 * 60 * 60); 
//                passwordCookie.setPath("/");

                response.addCookie(usernameCookie);
               // response.addCookie(passwordCookie);
            }


            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("alertMessage", "Invalid username or password!");
            request.setAttribute("alertStatus", false);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    request.setAttribute("username", cookie.getValue()); 
                }
//                if (cookie.getName().equals("password")) {
//                    request.setAttribute("password", cookie.getValue()); 
//                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
    }
    
}

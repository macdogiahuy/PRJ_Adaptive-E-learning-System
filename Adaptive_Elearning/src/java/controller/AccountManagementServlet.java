package controller;

import model.Users;
import controller.UsersJpaController;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class AccountManagementServlet extends HttpServlet {
    
    private UsersJpaController usersController;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    
    @Override
    public void init() throws ServletException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WebApplication3PU");
        usersController = new UsersJpaController(emf);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Users> users = usersController.findUsersEntities();
            request.setAttribute("users", users);
            request.setAttribute("dateFormat", dateFormat);
            request.getRequestDispatcher("/WEB-INF/views/admin/accountmanagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading users");
        }
    }
}
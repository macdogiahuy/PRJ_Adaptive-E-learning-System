package servlet;

import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "HealthServlet", urlPatterns = {"/healthz"})
public class HealthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        boolean dbOk = DBConnection.testConnection();
        int status = dbOk ? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE;
        resp.setStatus(status);

        try (PrintWriter writer = resp.getWriter()) {
            writer.write("{\"status\":\"" + (dbOk ? "ok" : "degraded") + "\"}");
        }
    }
}


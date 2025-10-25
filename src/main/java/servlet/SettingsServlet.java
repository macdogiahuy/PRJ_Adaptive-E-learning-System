package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utils.SettingsManager;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/admin/settings", "/settings"})
public class SettingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SettingsManager mgr = new SettingsManager();
        Map<String, String> all = mgr.getAll();
        request.setAttribute("settings", all);

        Object flashErr = request.getSession().getAttribute("errorMessage");
        if (flashErr != null) {
            request.setAttribute("errorMessage", flashErr.toString());
            request.getSession().removeAttribute("errorMessage");
        }
        Object flashSuccess = request.getSession().getAttribute("successMessage");
        if (flashSuccess != null) {
            request.setAttribute("successMessage", flashSuccess.toString());
            request.getSession().removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/Pages/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // collect posted fields. We deliberately accept only a small set of site settings.
        Map<String, String> posted = new HashMap<>();
        posted.put("siteTitle", trim(request.getParameter("siteTitle")));
        posted.put("siteDescription", trim(request.getParameter("siteDescription")));
        posted.put("itemsPerPage", trim(request.getParameter("itemsPerPage")));
        posted.put("allowRegistration", trim(request.getParameter("allowRegistration")));
        posted.put("maintenanceMode", trim(request.getParameter("maintenanceMode")));

        List<String> errors = SettingsManager.validate(posted);
        if (!errors.isEmpty()) {
            request.setAttribute("errorMessage", String.join(" ", errors));
            request.setAttribute("settings", posted);
            request.getRequestDispatcher("/WEB-INF/views/Pages/admin/settings.jsp").forward(request, response);
            return;
        }

        SettingsManager mgr = new SettingsManager();
        mgr.putAll(posted);
        try {
            mgr.save();
            request.getSession().setAttribute("successMessage", "Settings saved successfully.");
        } catch (Exception ex) {
            request.getSession().setAttribute("errorMessage", "Failed to save settings: " + ex.getMessage());
        }
        // Redirect to the short URL so both variants behave the same for users
        response.sendRedirect(request.getContextPath() + "/settings");
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}

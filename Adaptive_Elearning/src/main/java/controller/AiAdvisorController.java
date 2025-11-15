package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class AiAdvisorController extends HttpServlet {

    private static final String PYTHON_API = "http://127.0.0.1:8000/advice";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Forward to the JSP page when user navigates to /ai-advice
        req.getRequestDispatcher("/aichatbot_advice.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // READ JSON INPUT
        BufferedReader readerBody = req.getReader();
        JsonObject inputJson = new Gson().fromJson(readerBody, JsonObject.class);
        String message = inputJson.get("message").getAsString();

        System.out.println("MESSAGE RECEIVED = " + message);

        // PREPARE JSON FOR PYTHON
        JsonObject jsonBody = new JsonObject();
        jsonBody.addProperty("query", message);
        String jsonInput = new Gson().toJson(jsonBody);

        // CALL PYTHON
        URL url = new URL(PYTHON_API);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        con.setDoOutput(true);

        try (OutputStream os = con.getOutputStream()) {
            os.write(jsonInput.getBytes("UTF-8"));
        }

        BufferedReader reader = new BufferedReader(
            new InputStreamReader(con.getInputStream(), "UTF-8")
        );

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) sb.append(line);

        System.out.println("PYTHON RESPONSE = " + sb.toString());

        JsonObject pythonJson = new Gson().fromJson(sb.toString(), JsonObject.class);

        // GET advice
        String reply = pythonJson.get("advice").getAsString();

        // SEND JSON BACK
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("reply", reply);

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(new Gson().toJson(jsonResponse));
    }
}

package client;

import com.google.gson.*;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class CatApiClient {
    private final String baseUrl;
    private final Gson gson = new Gson();

    public CatApiClient(String baseUrl) {
        this.baseUrl = "http://127.0.0.1:5000";;
    }

    public JsonObject nextQuestion(String userId, String courseId, String assignmentId,
                                   Double currentTheta,
                                   List<String> answeredQuestions,
                                   List<Integer> lastResponse) throws IOException {
        JsonObject payload = new JsonObject();
        payload.addProperty("user_id", userId);
        payload.addProperty("course_id", courseId);
        payload.addProperty("assignment_id", assignmentId);
        if (currentTheta != null) payload.addProperty("current_theta", currentTheta);

        JsonArray ans = new JsonArray();
        for (String q : answeredQuestions) ans.add(q);
        payload.add("answered_questions", ans);

        JsonArray lr = new JsonArray();
        for (Integer v : lastResponse) lr.add(v);
        payload.add("last_response", lr);

        return postJson("/api/cat/next-question", payload);
    }

    public JsonObject submit(String userId, String courseId, String assignmentId,
                             List<String> answeredQuestions,
                             List<Integer> responses,
                             double smoothingAlpha) throws IOException {
        JsonObject payload = new JsonObject();
        payload.addProperty("user_id", userId);
        payload.addProperty("course_id", courseId);
        payload.addProperty("assignment_id", assignmentId);

        JsonArray ans = new JsonArray();
        for (String q : answeredQuestions) ans.add(q);
        payload.add("answered_questions", ans);

        JsonArray resp = new JsonArray();
        for (Integer r : responses) resp.add(r);
        payload.add("responses", resp);

        payload.addProperty("smoothing_alpha", smoothingAlpha);
        return postJson("/api/cat/submit", payload);
    }

    private JsonObject postJson(String path, JsonObject payload) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setConnectTimeout(8000);
        con.setReadTimeout(15000);
        con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        con.setDoOutput(true);

        try (OutputStream os = con.getOutputStream()) {
            byte[] input = payload.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input);
        }

        int code = con.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? con.getInputStream() : con.getErrorStream();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            for (String line; (line = br.readLine()) != null; ) sb.append(line);
            JsonElement el = JsonParser.parseString(sb.toString());
            return el.isJsonObject() ? el.getAsJsonObject() : new JsonObject();
        }
    }
}

package services;

import jakarta.servlet.http.*;
import model.Users;
import org.json.JSONObject;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import utils.EnvConfig;

public class GoogleAuthService {
    private static final String CLIENT_ID = EnvConfig.get("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = EnvConfig.get("GOOGLE_CLIENT_SECRET");
    private static final String REDIRECT_URI = EnvConfig.get("REDIRECT_URI");

    public String buildAuthUrl(HttpSession session) {
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state", state);

        return "https://accounts.google.com/o/oauth2/v2/auth?" +
                "client_id=" + CLIENT_ID +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
                "&response_type=code" +
                "&scope=email%20profile" +
                "&state=" + state;
    }

    public Users handleCallback(HttpServletRequest req) {
        String code = req.getParameter("code");
        String state = req.getParameter("state");
        String expectedState = (String) req.getSession().getAttribute("oauth_state");

        if (code == null || !state.equals(expectedState)) return null;

        try {
            String accessToken = fetchAccessToken(code);
            return fetchUserInfo(accessToken);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String fetchAccessToken(String code) throws IOException {
        String tokenEndpoint = "https://oauth2.googleapis.com/token";
        String payload = "code=" + code +
                "&client_id=" + CLIENT_ID +
                "&client_secret=" + CLIENT_SECRET +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
                "&grant_type=authorization_code";

        HttpURLConnection conn = (HttpURLConnection) new URL(tokenEndpoint).openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.getOutputStream().write(payload.getBytes(StandardCharsets.UTF_8));

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder responseBuffer = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) responseBuffer.append(line);
        reader.close();

        JSONObject tokenJson = new JSONObject(responseBuffer.toString());
        return tokenJson.getString("access_token");
    }

    private Users fetchUserInfo(String accessToken) throws IOException {
        URL userInfoUrl = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
        HttpURLConnection conn = (HttpURLConnection) userInfoUrl.openConnection();
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder userBuffer = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) userBuffer.append(line);
        reader.close();

        JSONObject userJson = new JSONObject(userBuffer.toString());

        Users user = new Users();
        user.setEmail(userJson.getString("email"));
        user.setFullName(userJson.getString("name"));
        user.setAvatarUrl(userJson.getString("picture"));
        user.setLoginProvider("Google");
        user.setProviderKey(userJson.getString("id"));
        user.setIsVerified(true);
        user.setIsApproved(true);
        return user;
    }
}

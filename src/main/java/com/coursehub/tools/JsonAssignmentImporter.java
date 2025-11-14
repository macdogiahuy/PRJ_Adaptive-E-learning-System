package com.coursehub.tools;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.DBConnection;

import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Standalone utility to import MCQ JSON into an existing Assignment and store the JSON file path on the Assignment.
 * Usage: java -cp <classpath> com.coursehub.tools.JsonAssignmentImporter <assignmentId> <jsonFilePath>
 */
public class JsonAssignmentImporter {

    private static final Gson gson = new Gson();

    public static int importFileToAssignment(String assignmentId, String jsonFilePath) throws Exception {
        if (assignmentId == null || assignmentId.isBlank()) throw new IllegalArgumentException("assignmentId is required");
        // validate UUID
        try { UUID.fromString(assignmentId); } catch (IllegalArgumentException iae) { throw new IllegalArgumentException("assignmentId is not a valid UUID: " + assignmentId, iae); }

        // read file
        Path p = Path.of(jsonFilePath);
        if (!Files.exists(p)) throw new IOException("JSON file not found: " + jsonFilePath);
        String json = Files.readString(p, StandardCharsets.UTF_8);

        Type listType = new TypeToken<List<Map<String, Object>>>(){}.getType();
        List<Map<String, Object>> items = gson.fromJson(json, listType);
        if (items == null || items.isEmpty()) return 0;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            // ensure JsonFileUrl column exists
            try (Statement st = conn.createStatement()) {
                String checkSql = "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Assignments' AND COLUMN_NAME='JsonFileUrl'";
                try (ResultSet rs = st.executeQuery(checkSql)) {
                    if (!rs.next()) {
                        String alter = "ALTER TABLE dbo.Assignments ADD JsonFileUrl NVARCHAR(1000) NULL";
                        st.executeUpdate(alter);
                    }
                }
            }

            // Determine safe max lengths for Content columns to avoid SQL truncation errors
            Integer qContentMax = getColumnMaxLength(conn, "McqQuestions", "Content");
            Integer cContentMax = getColumnMaxLength(conn, "McqChoices", "Content");
            Integer jsonUrlMax = getColumnMaxLength(conn, "Assignments", "JsonFileUrl");

            String insertQuestionSql = "INSERT INTO dbo.McqQuestions (Id, Content, AssignmentId) VALUES (?, ?, ?)";
            String insertChoiceSql = "INSERT INTO dbo.McqChoices (Id, Content, IsCorrect, McqQuestionId) VALUES (?, ?, ?, ?)";
            String updateAssignmentSql = "UPDATE dbo.Assignments SET QuestionCount = ISNULL(QuestionCount,0) + ?, JsonFileUrl = ? WHERE Id = ?";

            int imported = 0;
            try (PreparedStatement psQ = conn.prepareStatement(insertQuestionSql);
                 PreparedStatement psC = conn.prepareStatement(insertChoiceSql);
                 PreparedStatement psUp = conn.prepareStatement(updateAssignmentSql)) {

                for (Map<String, Object> q : items) {
                    String qid = UUID.randomUUID().toString();
                    String questionText = q.getOrDefault("question", "").toString();
                    // truncate questionText if necessary
                    String originalQuestionText = questionText;
                    questionText = safeTruncate(questionText, qContentMax);
                    if (!questionText.equals(originalQuestionText)) System.err.println("[JsonImporter] Truncated question text to " + qContentMax + " chars.");

                    psQ.setString(1, qid);
                    psQ.setString(2, questionText);
                    psQ.setString(3, assignmentId);
                    psQ.executeUpdate();

                    Object optsObj = q.get("options");
                    if (optsObj instanceof List) {
                        List<?> opts = (List<?>) optsObj;
                        for (Object optRaw : opts) {
                            String content = optRaw == null ? "" : optRaw.toString();
                            String cid = UUID.randomUUID().toString();
                            boolean isCorrect = false;
                            Object answerObj = q.get("answer");
                            if (answerObj != null) {
                                isCorrect = content.trim().equalsIgnoreCase(answerObj.toString().trim());
                            }
                            // truncate choice content if necessary
                            String originalChoice = content;
                            content = safeTruncate(content, cContentMax);
                            if (!content.equals(originalChoice)) System.err.println("[JsonImporter] Truncated choice content to " + cContentMax + " chars.");
                            psC.setString(1, cid);
                            psC.setString(2, content);
                            psC.setInt(3, isCorrect ? 1 : 0);
                            psC.setString(4, qid);
                            psC.executeUpdate();
                        }
                    }
                    imported++;
                }
                // Truncate JsonFileUrl if necessary before updating assignment
                String jpath = safeTruncate(jsonFilePath, jsonUrlMax);
                if (!jpath.equals(jsonFilePath)) System.err.println("[JsonImporter] Truncated JsonFileUrl to " + jsonUrlMax + " chars.");

                psUp.setInt(1, imported);
                psUp.setString(2, jpath);
                psUp.setString(3, assignmentId);
                int updated = psUp.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    throw new SQLException("Assignment not found for Id: " + assignmentId);
                }

                conn.commit();
                return imported;
            } catch (SQLException ex) {
                try { conn.rollback(); } catch (SQLException e) { /* ignore */ }
                throw ex;
            }
        }
    }

    /**
     * Return the character maximum length for a given table.column from INFORMATION_SCHEMA.
     * Returns null when length is unlimited or unknown.
     */
    private static Integer getColumnMaxLength(Connection conn, String tableName, String columnName) {
        String sql = "SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ? AND COLUMN_NAME = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int v = rs.getInt(1);
                    if (rs.wasNull()) return null;
                    // SQL Server uses -1 for MAX types
                    if (v <= 0) return null;
                    return v;
                }
            }
        } catch (SQLException ex) {
            // ignore and return null
        }
        return null;
    }

    private static String safeTruncate(String s, Integer max) {
        if (s == null) return null;
        if (max == null || max <= 0) return s;
        if (s.length() <= max) return s;
        if (max > 3) return s.substring(0, max - 3) + "...";
        return s.substring(0, max);
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: JsonAssignmentImporter <assignmentId> <jsonFilePath>");
            System.out.println("Example: JsonAssignmentImporter 6965B04A-E57A-4CC0-AC98-C19C61EAA497 \"C:\\Users\\datdi\\Downloads\\SQL___MySQL_for_Data_Analytics_and_Business_Intelligence_150_questions.json\"");
            return;
        }
        String assignmentId = args[0];
        String jsonFilePath = args[1];
        try {
            int imported = importFileToAssignment(assignmentId, jsonFilePath);
            System.out.println("✅ Imported " + imported + " questions into Assignment " + assignmentId);
        } catch (Exception e) {
            System.err.println("❌ Import failed: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

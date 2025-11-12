package com.coursehub.tools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * SaveDriveLink
 *
 * Chạy trong VS Code hoặc từ dòng lệnh.
 * Nhận hai tham số: LectureId (UUID) và FileId (Google Drive file id).
 * Kiểm tra LectureId có tồn tại trong dbo.Lectures, nếu có chèn record vào dbo.LectureMaterial.
 * Dùng try-with-resources để đóng Connection/Statements tự động.
 */
public class SaveDriveLink {

    // Mặc định kết nối; có thể ghi đè bằng biến môi trường DB_URL, DB_USER, DB_PASSWORD
    private static final String DEFAULT_DB_URL = System.getenv().getOrDefault(
            "DB_URL", "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB");
    private static final String DEFAULT_DB_USER = System.getenv().getOrDefault("DB_USER", "sa");
    private static final String DEFAULT_DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "123456789");

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Sử dụng: java -cp \".;path\\to\\mssql-jdbc.jar\" com.coursehub.tools.SaveDriveLink <LectureId-UUID> <FileId>");
            return;
        }

        String lectureIdStr = args[0];
        String fileId = args[1];

        UUID lectureId;
        try {
            lectureId = UUID.fromString(lectureIdStr);
        } catch (IllegalArgumentException ex) {
            System.err.println("❌ LectureId không hợp lệ. Hãy truyền một UUID hợp lệ.");
            return;
        }

        String previewUrl = "https://drive.google.com/uc?export=preview&id=" + fileId;

        String dbUrl = DEFAULT_DB_URL;
        String dbUser = DEFAULT_DB_USER;
        String dbPassword = DEFAULT_DB_PASSWORD;

        // Kết nối và thực hiện kiểm tra + insert
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {

            // Kiểm tra LectureId tồn tại trong dbo.Lectures
            String checkSql = "SELECT 1 FROM dbo.Lectures WHERE Id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, lectureId.toString());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        System.out.println("❌ LectureId không tồn tại trong bảng Lectures.");
                        return;
                    }
                }
            }

            // Chèn vào dbo.LectureMaterial. LectureMaterial.Id is IDENTITY, so omit Id and let DB generate it.
            String insertSql = "INSERT INTO dbo.LectureMaterial (LectureId, Type, Url) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                insertStmt.setString(1, lectureId.toString());
                insertStmt.setString(2, "Video");
                insertStmt.setString(3, previewUrl);

                int rows = insertStmt.executeUpdate();
                if (rows == 1) {
                    // try to read generated key (if any)
                    try (ResultSet gk = insertStmt.getGeneratedKeys()) {
                        if (gk != null && gk.next()) {
                            long generatedId = gk.getLong(1);
                            System.out.println("✅ Upload thành công! Link Google Drive đã được lưu xuống LectureMaterial.");
                            System.out.println(" - LectureMaterial.generatedId = " + generatedId);
                            System.out.println(" - Url = " + previewUrl);
                        } else {
                            System.out.println("✅ Upload thành công! Link Google Drive đã được lưu xuống LectureMaterial.");
                            System.out.println(" - Url = " + previewUrl);
                        }
                    }
                } else {
                    System.out.println("❌ Không chèn được bản ghi vào LectureMaterial (rows affected = " + rows + ").");
                }
            } catch (SQLException e) {
                System.err.println("❌ Lỗi khi lưu link Google Drive: " + e.getMessage());
                printDetailedSQLException(e);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi kết nối hoặc SQL: " + e.getMessage());
            printDetailedSQLException(e);
        } catch (Exception e) {
            System.err.println("❌ Lỗi bất ngờ: " + e.getMessage());
            e.printStackTrace(System.err);
        }
    }

    private static void printDetailedSQLException(SQLException ex) {
        System.err.println("---- Chi tiết SQLException ----");
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                SQLException se = (SQLException) e;
                System.err.println("Message: " + se.getMessage());
                System.err.println("SQLState: " + se.getSQLState());
                System.err.println("ErrorCode: " + se.getErrorCode());
            } else {
                System.err.println("Other throwable: " + e.getMessage());
            }
        }
        System.err.println("-------------------------------");
        ex.printStackTrace(System.err);
    }
}

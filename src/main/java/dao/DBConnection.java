package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    public static String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB11;encrypt=true;trustServerCertificate=true;";
    public static String userDB = "sa";
    public static String passDB = "123456789";

    public static Connection getConnection() throws SQLException {
        Connection con = null;
        try {
            Class.forName(driverName);
            con = DriverManager.getConnection(dbURL, userDB, passDB);
            System.out.println("✅ Database connection successful!");
            return con;
        } catch (ClassNotFoundException ex) {
            System.err.println("SQL Server Driver not found: " + ex.getMessage());
            throw new SQLException("SQL Server Driver not found", ex);
        } catch (SQLException ex) {
            System.err.println("Database connection failed: " + ex.getMessage());
            System.err.println("URL: " + dbURL);
            System.err.println("User: " + userDB);
            throw ex;
        }
    }

    public static boolean testConnection() {
        try (Connection con = getConnection()) {
            if (con != null && !con.isClosed()) {
                return true;  
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false; 
    }
    public static void main(String[] args) {
        if (testConnection()) {
            System.out.println("✅ Database connected successfully!");
        } else {
            System.out.println("❌ Failed to connect to database!");
        }
    }
}
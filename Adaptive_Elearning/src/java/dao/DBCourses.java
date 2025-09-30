/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author datdi
 */

import java.sql.Connection;
import java.sql.DriverManager;

public class DBCourses {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=false";
    private static final String USER = "sa";
    private static final String PASS = "123456789"; // thay mật khẩu sa của bạn

    public static Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}


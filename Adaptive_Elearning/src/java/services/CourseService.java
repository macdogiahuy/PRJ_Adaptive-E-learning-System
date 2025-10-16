package services;

import model.Course;
import dao.CourseDao;
import java.sql.SQLException;
import java.util.*;

public class CourseService {
    private CourseDao courseDao = new CourseDao();

    public Course getCourseById(String courseId) {
        try {
            return courseDao.getCourseById(courseId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Course> getCoursesByInstructorExcept(String instructorId, String exceptCourseId) {
        try {
            return courseDao.getCoursesByInstructorExcept(instructorId, exceptCourseId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

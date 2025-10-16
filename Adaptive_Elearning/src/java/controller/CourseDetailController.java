package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import model.Instructor;
import model.Review;
import services.CourseService;
import services.InstructorService;
import services.ReviewService;

import java.io.IOException;
import java.util.List;

@WebServlet("/course-detail")
public class CourseDetailController extends HttpServlet {
    private CourseService courseService = new CourseService();
    private InstructorService instructorService = new InstructorService();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("id");
        Course course = courseService.getCourseById(courseId);
        List<Review> reviews = reviewService.getReviewsByCourseId(courseId);
        Instructor instructor = instructorService.getById(course.getInstructorId());
        List<Course> otherCourses = courseService.getCoursesByInstructorExcept(course.getInstructorId(), courseId);
        request.setAttribute("course", course);
        request.setAttribute("reviews", reviews);
        request.setAttribute("instructor", instructor);
        request.setAttribute("otherCourses", otherCourses);
        // Giả lập user
        request.setAttribute("userName", "Fgn85761");
        request.setAttribute("userAvatar", "assets/img/avatar.png");
        request.getRequestDispatcher("/course_detail.jsp").forward(request, response);
    }
}

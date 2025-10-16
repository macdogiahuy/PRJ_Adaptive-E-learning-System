package services;

import model.Review;
import dao.ReviewDao;
import java.sql.SQLException;
import java.util.*;

public class ReviewService {
    private ReviewDao reviewDao = new ReviewDao();

    public List<Review> getReviewsByCourseId(String courseId) {
        try {
            return reviewDao.getReviewsByCourseId(courseId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

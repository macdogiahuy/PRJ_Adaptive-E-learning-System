package services;

import model.Instructor;
import dao.InstructorDao;
import java.sql.SQLException;

public class InstructorService {
    private InstructorDao instructorDao = new InstructorDao();

    public Instructor getById(String instructorId) {
        try {
            return instructorDao.getById(instructorId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}

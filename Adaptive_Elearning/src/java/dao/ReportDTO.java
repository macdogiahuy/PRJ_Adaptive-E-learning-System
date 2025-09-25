

package dao;

public class ReportDTO {
    private String reporter;
    private String course;
    private String message;

    public ReportDTO(String reporter, String course, String message) {
        this.reporter = reporter;
        this.course = course;
        this.message = message;
    }

    // getters
    public String getReporter() { return reporter; }
    public String getCourse() { return course; }
    public String getMessage() { return message; }
}

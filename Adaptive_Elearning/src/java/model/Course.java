package model;

public class Course {
    private String id;
    private String title;
    private String thumbUrl;
    private String price;
    private String intro; // Đổi shortDescription thành intro cho khớp DB
    private String description;
    private String outcomes;
    private String requirements;
    private String instructorId;

    public Course(String id, String title, String thumbUrl, String price, String intro, String description, String outcomes, String requirements, String instructorId) {
        this.id = id;
        this.title = title;
        this.thumbUrl = thumbUrl;
        this.price = price;
        this.intro = intro;
        this.description = description;
        this.outcomes = outcomes;
        this.requirements = requirements;
        this.instructorId = instructorId;
    }

    public String getId() { return id; }
    public String getTitle() { return title; }
    public String getThumbUrl() { return thumbUrl; }
    public String getPrice() { return price; }
    public String getIntro() { return intro; }
    public String getDescription() { return description; }
    public String getOutcomes() { return outcomes; }
    public String getRequirements() { return requirements; }
    public String getInstructorId() { return instructorId; }
}

package model;

public class Review {
    private String userName;
    private String comment;
    private double rating;

    public Review(String userName, String comment, double rating) {
        this.userName = userName;
        this.comment = comment;
        this.rating = rating;
    }

    public String getUserName() { return userName; }
    public String getComment() { return comment; }
    public double getRating() { return rating; }
}

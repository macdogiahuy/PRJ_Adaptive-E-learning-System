/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author datdi
 */
public class CoursesMarket {
    private int id;
    private String title;
    private String thumbnail;
    private String instructor;
    private double price;
    private double discount;
    private String category;
    private double rating;
    private int studentsCount;
    private LocalDateTime createAt;

    public CoursesMarket(int id, String title, String thumbnail, String instructor, double price, double discount, String category, double rating, int studentsCount, LocalDateTime createAt) {
        this.id = id;
        this.title = title;
        this.thumbnail = thumbnail;
        this.instructor = instructor;
        this.price = price;
        this.discount = discount;
        this.category = category;
        this.rating = rating;
        this.studentsCount = studentsCount;
        this.createAt = createAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getStudentsCount() {
        return studentsCount;
    }

    public void setStudentsCount(int studentsCount) {
        this.studentsCount = studentsCount;
    }

    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    @Override
    public String toString() {
        return "CoursesMarket{" + "id=" + id + ", title=" + title + ", thumbnail=" + thumbnail + ", instructor=" + instructor + ", price=" + price + ", discount=" + discount + ", category=" + category + ", rating=" + rating + ", studentsCount=" + studentsCount + ", createAt=" + createAt + '}';
    }

    
    
}

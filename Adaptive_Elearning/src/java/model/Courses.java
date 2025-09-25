/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Courses")
@NamedQueries({
    @NamedQuery(name = "Courses.findAll", query = "SELECT c FROM Courses c"),
    @NamedQuery(name = "Courses.findById", query = "SELECT c FROM Courses c WHERE c.id = :id"),
    @NamedQuery(name = "Courses.findByTitle", query = "SELECT c FROM Courses c WHERE c.title = :title"),
    @NamedQuery(name = "Courses.findByMetaTitle", query = "SELECT c FROM Courses c WHERE c.metaTitle = :metaTitle"),
    @NamedQuery(name = "Courses.findByThumbUrl", query = "SELECT c FROM Courses c WHERE c.thumbUrl = :thumbUrl"),
    @NamedQuery(name = "Courses.findByIntro", query = "SELECT c FROM Courses c WHERE c.intro = :intro"),
    @NamedQuery(name = "Courses.findByDescription", query = "SELECT c FROM Courses c WHERE c.description = :description"),
    @NamedQuery(name = "Courses.findByStatus", query = "SELECT c FROM Courses c WHERE c.status = :status"),
    @NamedQuery(name = "Courses.findByPrice", query = "SELECT c FROM Courses c WHERE c.price = :price"),
    @NamedQuery(name = "Courses.findByDiscount", query = "SELECT c FROM Courses c WHERE c.discount = :discount"),
    @NamedQuery(name = "Courses.findByDiscountExpiry", query = "SELECT c FROM Courses c WHERE c.discountExpiry = :discountExpiry"),
    @NamedQuery(name = "Courses.findByLevel", query = "SELECT c FROM Courses c WHERE c.level = :level"),
    @NamedQuery(name = "Courses.findByOutcomes", query = "SELECT c FROM Courses c WHERE c.outcomes = :outcomes"),
    @NamedQuery(name = "Courses.findByRequirements", query = "SELECT c FROM Courses c WHERE c.requirements = :requirements"),
    @NamedQuery(name = "Courses.findByLectureCount", query = "SELECT c FROM Courses c WHERE c.lectureCount = :lectureCount"),
    @NamedQuery(name = "Courses.findByLearnerCount", query = "SELECT c FROM Courses c WHERE c.learnerCount = :learnerCount"),
    @NamedQuery(name = "Courses.findByRatingCount", query = "SELECT c FROM Courses c WHERE c.ratingCount = :ratingCount"),
    @NamedQuery(name = "Courses.findByTotalRating", query = "SELECT c FROM Courses c WHERE c.totalRating = :totalRating"),
    @NamedQuery(name = "Courses.findByCreationTime", query = "SELECT c FROM Courses c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "Courses.findByLastModificationTime", query = "SELECT c FROM Courses c WHERE c.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Courses.findByLastModifierId", query = "SELECT c FROM Courses c WHERE c.lastModifierId = :lastModifierId")})
public class Courses implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Title")
    private String title;
    @Basic(optional = false)
    @Column(name = "MetaTitle")
    private String metaTitle;
    @Basic(optional = false)
    @Column(name = "ThumbUrl")
    private String thumbUrl;
    @Basic(optional = false)
    @Column(name = "Intro")
    private String intro;
    @Basic(optional = false)
    @Column(name = "Description")
    private String description;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @Column(name = "Price")
    private double price;
    @Basic(optional = false)
    @Column(name = "Discount")
    private double discount;
    @Basic(optional = false)
    @Column(name = "DiscountExpiry")
    @Temporal(TemporalType.TIMESTAMP)
    private Date discountExpiry;
    @Basic(optional = false)
    @Column(name = "Level")
    private String level;
    @Basic(optional = false)
    @Column(name = "Outcomes")
    private String outcomes;
    @Basic(optional = false)
    @Column(name = "Requirements")
    private String requirements;
    @Basic(optional = false)
    @Column(name = "LectureCount")
    private short lectureCount;
    @Basic(optional = false)
    @Column(name = "LearnerCount")
    private int learnerCount;
    @Basic(optional = false)
    @Column(name = "RatingCount")
    private int ratingCount;
    @Basic(optional = false)
    @Column(name = "TotalRating")
    private long totalRating;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @Basic(optional = false)
    @Column(name = "LastModifierId")
    private String lastModifierId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId")
    private List<CourseReviews> courseReviewsList;
    @JoinColumn(name = "LeafCategoryId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Categories leafCategoryId;
    @JoinColumn(name = "InstructorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Instructors instructorId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courseId")
    private List<Sections> sectionsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courses")
    private List<CourseMeta> courseMetaList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "courses")
    private List<Enrollments> enrollmentsList;

    public Courses() {
    }

    public Courses(String id) {
        this.id = id;
    }

    public Courses(String id, String title, String metaTitle, String thumbUrl, String intro, String description, String status, double price, double discount, Date discountExpiry, String level, String outcomes, String requirements, short lectureCount, int learnerCount, int ratingCount, long totalRating, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.title = title;
        this.metaTitle = metaTitle;
        this.thumbUrl = thumbUrl;
        this.intro = intro;
        this.description = description;
        this.status = status;
        this.price = price;
        this.discount = discount;
        this.discountExpiry = discountExpiry;
        this.level = level;
        this.outcomes = outcomes;
        this.requirements = requirements;
        this.lectureCount = lectureCount;
        this.learnerCount = learnerCount;
        this.ratingCount = ratingCount;
        this.totalRating = totalRating;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
        this.lastModifierId = lastModifierId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMetaTitle() {
        return metaTitle;
    }

    public void setMetaTitle(String metaTitle) {
        this.metaTitle = metaTitle;
    }

    public String getThumbUrl() {
        return thumbUrl;
    }

    public void setThumbUrl(String thumbUrl) {
        this.thumbUrl = thumbUrl;
    }

    public String getIntro() {
        return intro;
    }

    public void setIntro(String intro) {
        this.intro = intro;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public Date getDiscountExpiry() {
        return discountExpiry;
    }

    public void setDiscountExpiry(Date discountExpiry) {
        this.discountExpiry = discountExpiry;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getOutcomes() {
        return outcomes;
    }

    public void setOutcomes(String outcomes) {
        this.outcomes = outcomes;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public short getLectureCount() {
        return lectureCount;
    }

    public void setLectureCount(short lectureCount) {
        this.lectureCount = lectureCount;
    }

    public int getLearnerCount() {
        return learnerCount;
    }

    public void setLearnerCount(int learnerCount) {
        this.learnerCount = learnerCount;
    }

    public int getRatingCount() {
        return ratingCount;
    }

    public void setRatingCount(int ratingCount) {
        this.ratingCount = ratingCount;
    }

    public long getTotalRating() {
        return totalRating;
    }

    public void setTotalRating(long totalRating) {
        this.totalRating = totalRating;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getLastModificationTime() {
        return lastModificationTime;
    }

    public void setLastModificationTime(Date lastModificationTime) {
        this.lastModificationTime = lastModificationTime;
    }

    public String getLastModifierId() {
        return lastModifierId;
    }

    public void setLastModifierId(String lastModifierId) {
        this.lastModifierId = lastModifierId;
    }

    public List<CourseReviews> getCourseReviewsList() {
        return courseReviewsList;
    }

    public void setCourseReviewsList(List<CourseReviews> courseReviewsList) {
        this.courseReviewsList = courseReviewsList;
    }

    public Categories getLeafCategoryId() {
        return leafCategoryId;
    }

    public void setLeafCategoryId(Categories leafCategoryId) {
        this.leafCategoryId = leafCategoryId;
    }

    public Instructors getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(Instructors instructorId) {
        this.instructorId = instructorId;
    }

    public Users getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Users creatorId) {
        this.creatorId = creatorId;
    }

    public List<Sections> getSectionsList() {
        return sectionsList;
    }

    public void setSectionsList(List<Sections> sectionsList) {
        this.sectionsList = sectionsList;
    }

    public List<CourseMeta> getCourseMetaList() {
        return courseMetaList;
    }

    public void setCourseMetaList(List<CourseMeta> courseMetaList) {
        this.courseMetaList = courseMetaList;
    }

    public List<Enrollments> getEnrollmentsList() {
        return enrollmentsList;
    }

    public void setEnrollmentsList(List<Enrollments> enrollmentsList) {
        this.enrollmentsList = enrollmentsList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Courses)) {
            return false;
        }
        Courses other = (Courses) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Courses[ id=" + id + " ]";
    }
    
}

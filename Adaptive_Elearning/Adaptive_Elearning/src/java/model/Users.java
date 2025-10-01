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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Users")
@NamedQueries({
    @NamedQuery(name = "Users.findAll", query = "SELECT u FROM Users u"),
    @NamedQuery(name = "Users.findById", query = "SELECT u FROM Users u WHERE u.id = :id"),
    @NamedQuery(name = "Users.findByUserName", query = "SELECT u FROM Users u WHERE u.userName = :userName"),
    @NamedQuery(name = "Users.findByPassword", query = "SELECT u FROM Users u WHERE u.password = :password"),
    @NamedQuery(name = "Users.findByEmail", query = "SELECT u FROM Users u WHERE u.email = :email"),
    @NamedQuery(name = "Users.findByFullName", query = "SELECT u FROM Users u WHERE u.fullName = :fullName"),
    @NamedQuery(name = "Users.findByMetaFullName", query = "SELECT u FROM Users u WHERE u.metaFullName = :metaFullName"),
    @NamedQuery(name = "Users.findByAvatarUrl", query = "SELECT u FROM Users u WHERE u.avatarUrl = :avatarUrl"),
    @NamedQuery(name = "Users.findByRole", query = "SELECT u FROM Users u WHERE u.role = :role"),
    @NamedQuery(name = "Users.findByToken", query = "SELECT u FROM Users u WHERE u.token = :token"),
    @NamedQuery(name = "Users.findByRefreshToken", query = "SELECT u FROM Users u WHERE u.refreshToken = :refreshToken"),
    @NamedQuery(name = "Users.findByIsVerified", query = "SELECT u FROM Users u WHERE u.isVerified = :isVerified"),
    @NamedQuery(name = "Users.findByIsApproved", query = "SELECT u FROM Users u WHERE u.isApproved = :isApproved"),
    @NamedQuery(name = "Users.findByAccessFailedCount", query = "SELECT u FROM Users u WHERE u.accessFailedCount = :accessFailedCount"),
    @NamedQuery(name = "Users.findByLoginProvider", query = "SELECT u FROM Users u WHERE u.loginProvider = :loginProvider"),
    @NamedQuery(name = "Users.findByProviderKey", query = "SELECT u FROM Users u WHERE u.providerKey = :providerKey"),
    @NamedQuery(name = "Users.findByBio", query = "SELECT u FROM Users u WHERE u.bio = :bio"),
    @NamedQuery(name = "Users.findByDateOfBirth", query = "SELECT u FROM Users u WHERE u.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Users.findByPhone", query = "SELECT u FROM Users u WHERE u.phone = :phone"),
    @NamedQuery(name = "Users.findByEnrollmentCount", query = "SELECT u FROM Users u WHERE u.enrollmentCount = :enrollmentCount"),
    @NamedQuery(name = "Users.findByInstructorId", query = "SELECT u FROM Users u WHERE u.instructorId = :instructorId"),
    @NamedQuery(name = "Users.findByCreationTime", query = "SELECT u FROM Users u WHERE u.creationTime = :creationTime"),
    @NamedQuery(name = "Users.findByLastModificationTime", query = "SELECT u FROM Users u WHERE u.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Users.findBySystemBalance", query = "SELECT u FROM Users u WHERE u.systemBalance = :systemBalance")})
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "UserName")
    private String userName;
    @Basic(optional = false)
    @Column(name = "Password")
    private String password;
    @Basic(optional = false)
    @Column(name = "Email")
    private String email;
    @Basic(optional = false)
    @Column(name = "FullName")
    private String fullName;
    @Basic(optional = false)
    @Column(name = "MetaFullName")
    private String metaFullName;
    @Basic(optional = false)
    @Column(name = "AvatarUrl")
    private String avatarUrl;
    @Basic(optional = false)
    @Column(name = "Role")
    private String role;
    @Basic(optional = false)
    @Column(name = "Token")
    private String token;
    @Basic(optional = false)
    @Column(name = "RefreshToken")
    private String refreshToken;
    @Basic(optional = false)
    @Column(name = "IsVerified")
    private boolean isVerified;
    @Basic(optional = false)
    @Column(name = "IsApproved")
    private boolean isApproved;
    @Basic(optional = false)
    @Column(name = "AccessFailedCount")
    private short accessFailedCount;
    @Column(name = "LoginProvider")
    private String loginProvider;
    @Column(name = "ProviderKey")
    private String providerKey;
    @Basic(optional = false)
    @Column(name = "Bio")
    private String bio;
    @Column(name = "DateOfBirth")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOfBirth;
    @Column(name = "Phone")
    private String phone;
    @Basic(optional = false)
    @Column(name = "EnrollmentCount")
    private int enrollmentCount;
    @Column(name = "InstructorId")
    private String instructorId;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @Basic(optional = false)
    @Column(name = "SystemBalance")
    private long systemBalance;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Articles> articlesList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Assignments> assignmentsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<CourseReviews> courseReviewsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Courses> coursesList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Conversations> conversationsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "users")
    private List<Enrollments> enrollmentsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Comments> commentsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<ChatMessages> chatMessagesList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "users")
    private List<ConversationMembers> conversationMembersList;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private Instructors instructors;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Notifications> notificationsList;
    @OneToMany(mappedBy = "receiverId")
    private List<Notifications> notificationsList1;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Submissions> submissionsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "creatorId")
    private List<Bills> billsList;

    public Users() {
    }

    public Users(String id) {
        this.id = id;
    }

    public Users(String id, String userName, String password, String email, String fullName, String metaFullName, String avatarUrl, String role, String token, String refreshToken, boolean isVerified, boolean isApproved, short accessFailedCount, String bio, int enrollmentCount, Date creationTime, Date lastModificationTime, long systemBalance) {
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.metaFullName = metaFullName;
        this.avatarUrl = avatarUrl;
        this.role = role;
        this.token = token;
        this.refreshToken = refreshToken;
        this.isVerified = isVerified;
        this.isApproved = isApproved;
        this.accessFailedCount = accessFailedCount;
        this.bio = bio;
        this.enrollmentCount = enrollmentCount;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
        this.systemBalance = systemBalance;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMetaFullName() {
        return metaFullName;
    }

    public void setMetaFullName(String metaFullName) {
        this.metaFullName = metaFullName;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public boolean getIsVerified() {
        return isVerified;
    }

    public void setIsVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    public boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }

    public short getAccessFailedCount() {
        return accessFailedCount;
    }

    public void setAccessFailedCount(short accessFailedCount) {
        this.accessFailedCount = accessFailedCount;
    }

    public String getLoginProvider() {
        return loginProvider;
    }

    public void setLoginProvider(String loginProvider) {
        this.loginProvider = loginProvider;
    }

    public String getProviderKey() {
        return providerKey;
    }

    public void setProviderKey(String providerKey) {
        this.providerKey = providerKey;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getEnrollmentCount() {
        return enrollmentCount;
    }

    public void setEnrollmentCount(int enrollmentCount) {
        this.enrollmentCount = enrollmentCount;
    }

    public String getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(String instructorId) {
        this.instructorId = instructorId;
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

    public long getSystemBalance() {
        return systemBalance;
    }

    public void setSystemBalance(long systemBalance) {
        this.systemBalance = systemBalance;
    }

    public List<Articles> getArticlesList() {
        return articlesList;
    }

    public void setArticlesList(List<Articles> articlesList) {
        this.articlesList = articlesList;
    }

    public List<Assignments> getAssignmentsList() {
        return assignmentsList;
    }

    public void setAssignmentsList(List<Assignments> assignmentsList) {
        this.assignmentsList = assignmentsList;
    }

    public List<CourseReviews> getCourseReviewsList() {
        return courseReviewsList;
    }

    public void setCourseReviewsList(List<CourseReviews> courseReviewsList) {
        this.courseReviewsList = courseReviewsList;
    }

    public List<Courses> getCoursesList() {
        return coursesList;
    }

    public void setCoursesList(List<Courses> coursesList) {
        this.coursesList = coursesList;
    }

    public List<Conversations> getConversationsList() {
        return conversationsList;
    }

    public void setConversationsList(List<Conversations> conversationsList) {
        this.conversationsList = conversationsList;
    }

    public List<Enrollments> getEnrollmentsList() {
        return enrollmentsList;
    }

    public void setEnrollmentsList(List<Enrollments> enrollmentsList) {
        this.enrollmentsList = enrollmentsList;
    }

    public List<Comments> getCommentsList() {
        return commentsList;
    }

    public void setCommentsList(List<Comments> commentsList) {
        this.commentsList = commentsList;
    }

    public List<ChatMessages> getChatMessagesList() {
        return chatMessagesList;
    }

    public void setChatMessagesList(List<ChatMessages> chatMessagesList) {
        this.chatMessagesList = chatMessagesList;
    }

    public List<ConversationMembers> getConversationMembersList() {
        return conversationMembersList;
    }

    public void setConversationMembersList(List<ConversationMembers> conversationMembersList) {
        this.conversationMembersList = conversationMembersList;
    }

    public Instructors getInstructors() {
        return instructors;
    }

    public void setInstructors(Instructors instructors) {
        this.instructors = instructors;
    }

    public List<Notifications> getNotificationsList() {
        return notificationsList;
    }

    public void setNotificationsList(List<Notifications> notificationsList) {
        this.notificationsList = notificationsList;
    }

    public List<Notifications> getNotificationsList1() {
        return notificationsList1;
    }

    public void setNotificationsList1(List<Notifications> notificationsList1) {
        this.notificationsList1 = notificationsList1;
    }

    public List<Submissions> getSubmissionsList() {
        return submissionsList;
    }

    public void setSubmissionsList(List<Submissions> submissionsList) {
        this.submissionsList = submissionsList;
    }

    public List<Bills> getBillsList() {
        return billsList;
    }

    public void setBillsList(List<Bills> billsList) {
        this.billsList = billsList;
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
        if (!(object instanceof Users)) {
            return false;
        }
        Users other = (Users) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Users[ id=" + id + " ]";
    }
    
}

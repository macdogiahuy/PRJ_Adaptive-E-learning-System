//package model;
//
//import java.time.LocalDateTime;
//import java.util.UUID;
//
//import jakarta.persistence.Column;
//import jakarta.persistence.Entity;
//import jakarta.persistence.EnumType;
//import jakarta.persistence.Enumerated;
//import jakarta.persistence.GeneratedValue;
//import jakarta.persistence.Id;
//import jakarta.persistence.PrePersist;
//import jakarta.persistence.PreUpdate;
//import jakarta.persistence.Table;
//import jakarta.validation.constraints.Email;
//import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.Size;
//
//@Entity
//@Table(name = "Users")
//public class User {
//
//  @Id
//  @GeneratedValue
//  @Column(name = "Id")
//  private UUID id;
//
//  @NotBlank
//  @Size(max = 45)
//  @Column(name = "UserName", length = 45, nullable = false)
//  private String userName;
//
//  @NotBlank
//  @Size(max = 100)
//  @Column(name = "Password", length = 100, nullable = false)
//  private String password;
//
//  @Email
//  @NotBlank
//  @Size(max = 45)
//  @Column(name = "Email", length = 45, nullable = false)
//  private String email;
//
//  @NotBlank
//  @Size(max = 45)
//  @Column(name = "FullName", length = 45, nullable = false)
//  private String fullName;
//
//  @Size(max = 45)
//  @Column(name = "MetaFullName", length = 45, nullable = false)
//  private String metaFullName;
//
//  @Size(max = 100)
//  @Column(name = "AvatarUrl", length = 100, nullable = false)
//  private String avatarUrl = "";
//
//  @Enumerated(EnumType.STRING)
//  @Column(name = "Role", nullable = false)
//  private Role role;
//
//  @Size(max = 100)
//  @Column(name = "Token", length = 100, nullable = false)
//  private String token = "";
//
//  @Size(max = 100)
//  @Column(name = "RefreshToken", length = 100, nullable = false)
//  private String refreshToken = "";
//
//  @Column(name = "IsVerified", nullable = false)
//  private boolean isVerified = false;
//
//  @Column(name = "IsApproved", nullable = false)
//  private boolean isApproved = true;
//
//  @Column(name = "AccessFailedCount", nullable = false)
//  private byte accessFailedCount = 0;
//
//  @Size(max = 100)
//  @Column(name = "LoginProvider", length = 100)
//  private String loginProvider;
//
//  @Size(max = 100)
//  @Column(name = "ProviderKey", length = 100)
//  private String providerKey;
//
//  @Column(name = "CreationTime", nullable = false)
//  private LocalDateTime creationTime;
//
//  @Column(name = "LastModificationTime", nullable = false)
//  private LocalDateTime lastModificationTime;
//
//  // Default constructor
//  public User() {
//    this.creationTime = LocalDateTime.now();
//    this.lastModificationTime = LocalDateTime.now();
//  }
//
//  // Constructor with basic required fields
//  public User(String userName, String email, String fullName, String password, Role role) {
//    this();
//    this.userName = userName;
//    this.email = email;
//    this.fullName = fullName;
//    this.metaFullName = fullName;
//    this.password = password;
//    this.role = role;
//  }
//
//  // Getters and Setters
//  public UUID getId() {
//    return id;
//  }
//
//  public void setId(UUID id) {
//    this.id = id;
//  }
//
//  public String getUserName() {
//return userName;
//  }
//
//  public void setUserName(String userName) {
//    this.userName = userName;
//  }
//
//  public String getPassword() {
//    return password;
//  }
//
//  public void setPassword(String password) {
//    this.password = password;
//  }
//
//  public String getEmail() {
//    return email;
//  }
//
//  public void setEmail(String email) {
//    this.email = email;
//  }
//
//  public String getFullName() {
//    return fullName;
//  }
//
//  public void setFullName(String fullName) {
//    this.fullName = fullName;
//    this.metaFullName = fullName; // Auto-update metaFullName
//  }
//
//  public String getMetaFullName() {
//    return metaFullName;
//  }
//
//  public void setMetaFullName(String metaFullName) {
//    this.metaFullName = metaFullName;
//  }
//
//  public String getAvatarUrl() {
//    return avatarUrl;
//  }
//
//  public void setAvatarUrl(String avatarUrl) {
//    this.avatarUrl = avatarUrl != null ? avatarUrl : "";
//  }
//
//  public Role getRole() {
//    return role;
//  }
//
//  public void setRole(Role role) {
//    this.role = role;
//  }
//
//  public String getToken() {
//    return token;
//  }
//
//  public void setToken(String token) {
//    this.token = token != null ? token : "";
//  }
//
//  public String getRefreshToken() {
//    return refreshToken;
//  }
//
//  public void setRefreshToken(String refreshToken) {
//    this.refreshToken = refreshToken != null ? refreshToken : "";
//  }
//
//  public boolean isVerified() {
//    return isVerified;
//  }
//
//  public void setVerified(boolean verified) {
//    isVerified = verified;
//  }
//
//  public boolean isApproved() {
//    return isApproved;
//  }
//
//  public void setApproved(boolean approved) {
//    isApproved = approved;
//  }
//
//  // Method needed by service classes
//  public void setIsActive(boolean active) {
//    this.isApproved = active;
//  }
//
//  public byte getAccessFailedCount() {
//    return accessFailedCount;
//  }
//
//  public void setAccessFailedCount(byte accessFailedCount) {
//    this.accessFailedCount = accessFailedCount;
//  }
//
//  public String getLoginProvider() {
//    return loginProvider;
//  }
//
//  public void setLoginProvider(String loginProvider) {
//    this.loginProvider = loginProvider;
//  }
//
//  public String getProviderKey() {
//    return providerKey;
//  }
//
//  public void setProviderKey(String providerKey) {
//    this.providerKey = providerKey;
//  }
//
//  public LocalDateTime getCreationTime() {
//    return creationTime;
//  }
//
//  public void setCreationTime(LocalDateTime creationTime) {
//    this.creationTime = creationTime;
//  }
//
//  public LocalDateTime getLastModificationTime() {
//    return lastModificationTime;
//  }
//
//  public void setLastModificationTime(LocalDateTime lastModificationTime) {
//    this.lastModificationTime = lastModificationTime;
//  }
//
//  // Helper methods
//  @PrePersist
//  protected void onCreate() {
//    creationTime = LocalDateTime.now();
//    lastModificationTime = LocalDateTime.now();
//  }
//
//  @PreUpdate
//  protected void onUpdate() {
//    lastModificationTime = LocalDateTime.now();
//  }
//
//  // Additional methods that are expected by controllers/services
//  public String getIdAsString() {
//return id != null ? id.toString() : null;
//  }
//
//  public void setId(String idString) {
//    this.id = idString != null ? UUID.fromString(idString) : null;
//  }
//
//  // Legacy compatibility methods for first/last name
//  public String getFirstName() {
//    if (fullName != null && fullName.contains(" ")) {
//      return fullName.split(" ")[0];
//    }
//    return fullName;
//  }
//
//  public void setFirstName(String firstName) {
//    if (firstName != null) {
//      String lastName = getLastName();
//      this.fullName = firstName + (lastName != null ? " " + lastName : "");
//      this.metaFullName = this.fullName;
//    }
//  }
//
//  public String getLastName() {
//    if (fullName != null && fullName.contains(" ")) {
//      String[] parts = fullName.split(" ", 2);
//      return parts.length > 1 ? parts[1] : "";
//    }
//    return "";
//  }
//
//  public void setLastName(String lastName) {
//    String firstName = getFirstName();
//    if (firstName != null) {
//      this.fullName = firstName + (lastName != null ? " " + lastName : "");
//      this.metaFullName = this.fullName;
//    }
//  }
//
//  // Legacy password hash methods (mapped to password field for compatibility)
//  public String getPasswordHash() {
//    return password; // In new schema, password is already hashed
//  }
//
//  public void setPasswordHash(String passwordHash) {
//    this.password = passwordHash;
//  }
//
//  // Legacy verification methods
//  public boolean isEmailVerified() {
//    return isVerified;
//  }
//
//  public void setEmailVerified(boolean emailVerified) {
//    this.isVerified = emailVerified;
//  }
//
//  // Legacy date methods (mapped to LocalDateTime)
//  public java.util.Date getCreatedDate() {
//    return creationTime != null ? java.sql.Timestamp.valueOf(creationTime) : null;
//  }
//
//  public void setCreatedDate(java.util.Date createdDate) {
//    this.creationTime = createdDate != null ? createdDate.toInstant()
//        .atZone(java.time.ZoneId.systemDefault()).toLocalDateTime() : null;
//  }
//
//  public java.util.Date getUpdatedDate() {
//    return lastModificationTime != null ? java.sql.Timestamp.valueOf(lastModificationTime) : null;
//  }
//
//  public void setUpdatedDate(java.util.Date updatedDate) {
//    this.lastModificationTime = updatedDate != null ? updatedDate.toInstant()
//        .atZone(java.time.ZoneId.systemDefault()).toLocalDateTime() : null;
//  }
//
//  // Role enum matching .NET Core implementation
//  public enum Role {
//    Student,
//    Instructor,
//    Admin,
//    SysAdmin
//  }
//  
//  
//
//  @Override
//  public String toString() {
//    return "User{" +
//        "id=" + id +
//        ", userName='" + userName + '\'' +
//        ", email='" + email + '\'' +
//        ", fullName='" + fullName + '\'' +
//        ", role=" + role +
//        ", isVerified=" + isVerified +
//        ", isApproved=" + isApproved +
//        ", creationTime=" + creationTime +
//        '}';
//  }
//}
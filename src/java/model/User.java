package model;

import java.time.LocalDate;

public class User {
    private String id;
    private String userName;
    private String password;
    private String email;
    private String fullName;
    private String metaFullName;
    private String avatarUrl;
    private String role;
    private String token;
    private String refreshToken;
    private boolean isVerified;
    private boolean isApproved;
    private int accessFailedCount;
    private String loginProvider;
    private String providerKey;
    private String bio;
    private LocalDate dateOfBirth;
    private String phone;
    private int enrollmentCount;
    private String instructorId;
    private LocalDate creationTime;
    private LocalDate lastModificationTime;
    private long systemBalance;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getMetaFullName() { return metaFullName; }
    public void setMetaFullName(String metaFullName) { this.metaFullName = metaFullName; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getRefreshToken() { return refreshToken; }
    public void setRefreshToken(String refreshToken) { this.refreshToken = refreshToken; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }

    public int getAccessFailedCount() { return accessFailedCount; }
    public void setAccessFailedCount(int accessFailedCount) { this.accessFailedCount = accessFailedCount; }

    public String getLoginProvider() { return loginProvider; }
    public void setLoginProvider(String loginProvider) { this.loginProvider = loginProvider; }

    public String getProviderKey() { return providerKey; }
    public void setProviderKey(String providerKey) { this.providerKey = providerKey; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getEnrollmentCount() { return enrollmentCount; }
    public void setEnrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; }

    public String getInstructorId() { return instructorId; }
    public void setInstructorId(String instructorId) { this.instructorId = instructorId; }

    public LocalDate getCreationTime() { return creationTime; }
    public void setCreationTime(LocalDate creationTime) { this.creationTime = creationTime; }

    public LocalDate getLastModificationTime() { return lastModificationTime; }
    public void setLastModificationTime(LocalDate lastModificationTime) { this.lastModificationTime = lastModificationTime; }

    public long getSystemBalance() { return systemBalance; }
    public void setSystemBalance(long systemBalance) { this.systemBalance = systemBalance; }
}
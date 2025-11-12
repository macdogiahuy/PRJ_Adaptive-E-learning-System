package model;

public class DashboardData {
    private int totalUsers;
    private int totalNotifications;
    private int totalCourses;
    private int totalLearningGroups;

    public DashboardData() {
        this.totalUsers = 0;
        this.totalNotifications = 0;
        this.totalCourses = 0;
        this.totalLearningGroups = 0;
    }

    public DashboardData(int totalUsers, int totalNotifications, int totalCourses, int totalLearningGroups) {
        this.totalUsers = totalUsers;
        this.totalNotifications = totalNotifications;
        this.totalCourses = totalCourses;
        this.totalLearningGroups = totalLearningGroups;
    }

    // Getters and Setters
    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalNotifications() {
        return totalNotifications;
    }

    public void setTotalNotifications(int totalNotifications) {
        this.totalNotifications = totalNotifications;
    }

    public int getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(int totalCourses) {
        this.totalCourses = totalCourses;
    }

    public int getTotalLearningGroups() {
        return totalLearningGroups;
    }

    public void setTotalLearningGroups(int totalLearningGroups) {
        this.totalLearningGroups = totalLearningGroups;
    }
}

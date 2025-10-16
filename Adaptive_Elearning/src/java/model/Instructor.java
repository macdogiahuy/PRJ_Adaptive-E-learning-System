/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author datdi
 */
public class Instructor {
    private String id;
    private String fullName;
    private String avatar;

    public Instructor(String id, String fullName, String avatar) {
        this.id = id;
        this.fullName = fullName;
        this.avatar = avatar;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "Instructor{" + "id=" + id + ", fullName=" + fullName + ", avatar=" + avatar + '}';
    }
}

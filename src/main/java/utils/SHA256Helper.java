/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author ADMIN
 */
public class SHA256Helper {
     public static String hash(String input) {
        try {
            MessageDigest sha256Hash = MessageDigest.getInstance("SHA-256");
            byte[] bytes = sha256Hash.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder builder = new StringBuilder();
            for (byte b : bytes) {
                builder.append(String.format("%02x", b));  // Chuyển byte thành chuỗi hex
            }
            return builder.toString(); // Trả về chuỗi hex
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found.", e);
        }
    }
}

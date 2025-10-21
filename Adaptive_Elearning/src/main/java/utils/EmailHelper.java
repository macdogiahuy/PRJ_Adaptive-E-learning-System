/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

/**
 *
 * @author ADMIN
 */
public class EmailHelper {
    private final String senderEmail = "mit54480@gmail.com";   
    private final String senderPassword = "trjstutrixaauvrd";   

    public void sendMail(String recipientEmail, String subject, String messageContent) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(messageContent);

            Transport.send(message);
            System.out.println("[MAIL] Gửi mail thành công tới: " + recipientEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
     public static void main(String[] args) {
        EmailHelper mailer = new EmailHelper();
        String recipient = "mit54480@gmail.com";
        String subject = "🧪 Test gửi mail từ Java";
        String message = "Xin chào!\n\nĐây là email test được gửi từ EmailService qua Gmail SMTP.\nNếu bạn nhận được, tức là cấu hình App Password hoạt động thành công ✅\n\nTrân trọng.";

        mailer.sendMail(recipient, subject, message);
    }
   
  }


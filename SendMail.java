import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class SendMail {
    public static void main(String[] args) throws Exception {
        // Read HTML report
        String html = new String(Files.readAllBytes(Paths.get("test-output/api-custom-report.html")));

        // Use direct values for email and password
        String to = "sumit.kunjir@spurqlabs.com, chandrashekhar.bora@spurqlabs.com";
        String from = System.getenv("EMAIL_USERNAME");
        String username = System.getenv("EMAIL_USERNAME");
        String password = System.getenv("EMAIL_PASSWORD");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject("Bitbucket Test Execution Report");
        msg.setContent(html, "text/html");

        Transport.send(msg);
        System.out.println("✅ Email sent successfully.");
    }
}

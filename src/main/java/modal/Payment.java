package modal;

import utils.UserHandle;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment {
    private User user;
    private String paymentId;
    private String paymentStatus;
    private String paymentDate;
    private Double paymentAmount;
    private String paymentMethod;

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public Payment(Double paymentAmount, String paymentMethod, User user) {
        this.user = user;
        this.paymentId = null;
        this.paymentStatus = "PENDING";
        this.paymentDate = LocalDateTime.now().format(formatter);
        this.paymentAmount = paymentAmount;
        this.paymentMethod = paymentMethod;
    }

    // Constructor for fromString Method
    public Payment(String paymentId, String paymentStatus, String paymentDate, Double paymentAmount, String paymentMethod, User user) {
        this.user = user;
        this.paymentId = paymentId;
        this.paymentStatus = paymentStatus;
        this.paymentDate = paymentDate;
        this.paymentAmount = paymentAmount;
        this.paymentMethod = paymentMethod;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setPaymentAmount(Double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(String paymentDate) {
        this.paymentDate = paymentDate;
    }

    public double getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String paymentToString() {
        return paymentId + "|" + paymentStatus + "|" + paymentDate + "|" + paymentAmount + "|" + paymentMethod + "|" + user.getUserId();
    }

    public static Payment fromString(String string) {
        String[] parts = string.split("\\|");

        if (parts.length < 5) {
            throw new IllegalArgumentException("Invalid order string format");
        }

        String paymentId = parts[0];
        String paymentStatus = parts[1];
        String paymentDate = parts[2];
        Double paymentAmount = Double.parseDouble(parts[3]);
        String paymentMethod = parts[4];
        User user = UserHandle.findUserById(Integer.parseInt(parts[5]));


        return new Payment(paymentId, paymentStatus, paymentDate, paymentAmount, paymentMethod, user);
    }

}

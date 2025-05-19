package modal;

import java.time.LocalDate;

public class Booking {
    private String bookingId;
    private User user;
    private Room room;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private int numOfDays;
    private Payment payment;
    private String status;
    private Review review;

    public Review getReview() {
        return review;
    }

    public void setReview(Review review) {
        this.review = review;
    }

    public int getNumOfDays() {
        return numOfDays;
    }

    public void setNumOfDays(int numOfDays) {
        this.numOfDays = numOfDays;
    }

    public Booking(User user, Room room, LocalDate checkInDate, LocalDate checkOutDate) {
        bookingId = null;
        this.user = user;
        this.room = room;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numOfDays = checkOutDate.getDayOfMonth() - checkInDate.getDayOfMonth();
        this.status = "BOOKED";
        payment = null;
        review = null;
    }

    public Booking(String bookingId, User user, Room room, LocalDate checkInDate, LocalDate checkOutDate,int numOfDays, Payment payment, String status, Review review) {
        this.bookingId = bookingId;
        this.user = user;
        this.room = room;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numOfDays = numOfDays;
        this.payment = payment;
        this.status = status;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String bookingToString() {
        String paymentId = (payment == null) ? null : payment.getPaymentId();
        String reviewId = (review == null) ? null : review.getReviewId();

        return bookingId + "|" + user.getUserId() + "|" + room.getRoomNumber() + "|" + checkInDate.toString() + "|" + checkOutDate.toString() + "|"+ numOfDays + "|" + paymentId + "|" + status + "|" + reviewId;
    }

}

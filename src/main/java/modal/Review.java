package modal;

import utils.BookingHandle;
import utils.UserHandle;

import java.io.IOException;
import java.time.LocalDate;

public class Review {
    private String reviewId;
    private String reviewText;
    private int rating;
    private LocalDate reviewDate;
    private Booking booking;

    public Review() {}

    public Review(String reviewText, int rating, Booking booking) {
        this.reviewId = null;
        this.reviewText = reviewText;
        this.rating = rating;
        this.reviewDate = LocalDate.now();
        this.booking = booking;
    }

    public Review(String reviewId, String reviewText, int rating, LocalDate reviewDate, Booking booking) {
        this.reviewId = reviewId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.reviewDate = reviewDate;
        this.booking = booking;
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public LocalDate getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDate reviewDate) {
        this.reviewDate = reviewDate;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    // Convert Review to String for file storage
    public String reviewToString() {
        return reviewId + "|" + reviewText + "|" + rating + "|" + reviewDate + "|" + booking.getBookingId();
    }

    // Create Review from String
    public static Review stringToReview(String str) throws IOException {
        String[] parts = str.split("\\|");
        String reviewId = parts[0];
        String reviewText = parts[1];
        int rating = Integer.parseInt(parts[2]);
        LocalDate reviewDate = LocalDate.parse(parts[3]);

        // These would need to be fetched from their respective Handle classes
        Booking booking = BookingHandle.findBookingById(parts[4]);

        return new Review(reviewId, reviewText, rating, reviewDate, booking);
    }
}
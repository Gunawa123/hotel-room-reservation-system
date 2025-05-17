package utils;

import modal.Review;
import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedList;

public class ReviewHandle {
    private static LinkedList<Review> reviews = new LinkedList<>();
    public static int lastReviewId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String generateReviewId() {
        lastReviewId++;
        return String.format("REV%04d", lastReviewId);
    }

    public static LinkedList<Review> getReviews() {
        return reviews;
    }

    public static void addReview(Review review) throws IOException {
        if (review.getReviewId() == null || review.getReviewId().isEmpty()) {
            review.setReviewId(generateReviewId());
        }
        reviews.add(review);
        saveToFile();
    }

    public static void removeReview(Review review) throws IOException {
        reviews.remove(review);
        saveToFile();
    }

    public static Review findReviewById(String reviewId) {
        for (Review review : reviews) {
            if (review.getReviewId().equals(reviewId)) {
                return review;
            }
        }
        System.out.println("Review not found");
        return null;
    }

    public static void updateReview(String reviewId, String reviewText, int rating, LocalDate reviewDate) throws IOException {
        Review review = findReviewById(reviewId);
        if (review != null) {
            review.setReviewText(reviewText);
            review.setRating(rating);
            review.setReviewDate(reviewDate);
            saveToFile();
        }
    }

    public static void loadFromFile() throws IOException {
        reviews = DataHandle.reviewDataLoadFromFile();
        System.out.println("Reviews loaded");

        for (Review review : reviews) {
            if (review.getReviewId() != null && review.getReviewId().startsWith("REV")) {
                int idNo = Integer.parseInt(review.getReviewId().replace("REV", ""));
                lastReviewId = Math.max(idNo, lastReviewId);
            }
        }
    }

    public static void saveToFile() throws IOException {
        DataHandle.reviewsDataSaveToFile(reviews);
        System.out.println("Reviews data saved");
    }

    // Additional helper methods
    public static LinkedList<Review> findReviewsByUser(int userId) {
        LinkedList<Review> userReviews = new LinkedList<>();
        for (Review review : reviews) {
            if (review.getBooking().getUser().getUserId() == userId) {
                userReviews.add(review);
            }
        }
        return userReviews;
    }

    public static LinkedList<Review> findReviewsByBooking(String bookingId) {
        LinkedList<Review> bookingReviews = new LinkedList<>();
        for (Review review : reviews) {
            if (review.getBooking().getBookingId().equals(bookingId)) {
                bookingReviews.add(review);
            }
        }
        return bookingReviews;
    }
}
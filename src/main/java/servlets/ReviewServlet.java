package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.Booking;
import modal.Review;
import utils.BookingHandle;
import utils.ReviewHandle;

import java.io.IOException;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    public void init() {
        try {
            BookingHandle.loadFromFile();
            ReviewHandle.loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        Booking booking = BookingHandle.findBookingById(request.getParameter("bookingId"));

        if (action.equals("addReview")) {
            Review review = new Review(request.getParameter("reviewText"), Integer.parseInt(request.getParameter("rating")),  booking);
            ReviewHandle.addReview(review);

            response.sendRedirect(request.getContextPath() + "/MyReviews.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action.equals("delete")) {
            ReviewHandle.removeReview(ReviewHandle.findReviewById(request.getParameter("reviewId")));
            response.sendRedirect(request.getContextPath() + "/MyReviews.jsp");
        }

        if (action.equals("adminDelete")) {
            ReviewHandle.removeReview(ReviewHandle.findReviewById(request.getParameter("reviewId")));
            response.sendRedirect(request.getContextPath() + "/admin/ManageReviews.jsp");
        }
    }
}

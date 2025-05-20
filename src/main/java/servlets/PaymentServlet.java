package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modal.Booking;
import modal.Payment;
import modal.Room;
import modal.User;
import utils.*;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    public void init() {
        try {
            RoomHandle.loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("USER");

        Booking booking = BookingHandle.findBookingById(request.getParameter("bookingId"));

        if (action.equals("payForBooking")) {
            String paymentMethod = request.getParameter("paymentMethod");

            Payment payment = booking.getPayment();
            PaymentHandle.updatePaymentDetails(payment.getPaymentId(), paymentMethod, "PAID");
            BookingHandle.setBookingPayment(booking.getBookingId(), payment);
            BookingHandle.setBookingStatus(booking.getBookingId(), "CHECKED-OUT");

            RoomHandle.updateAvailability(booking.getRoom().getRoomNumber(), true);

            response.sendRedirect(request.getContextPath() + "/MyBookings.jsp");

        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("USER");
        Payment payment = PaymentHandle.findPaymentById(request.getParameter("paymentId"));

        if (action.equals("refund")) {
            if (payment != null) {
                PaymentHandle.updatePaymentStatus(payment.getPaymentId(), "REFUNDED");
            }

            response.sendRedirect(request.getContextPath() + "/admin/ManagePayments.jsp");

        }

        if (action.equals("delete")) {
            if (payment != null) {
                PaymentHandle.removePayment(payment);
            }

            response.sendRedirect(request.getContextPath() + "/admin/ManagePayments.jsp");

        }

    }
}

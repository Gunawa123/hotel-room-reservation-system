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
import utils.BookingHandle;
import utils.PaymentHandle;
import utils.RoomHandle;
import utils.UserHandle;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("USER");
        Room room = RoomHandle.findRoomByNumber(request.getParameter("roomNumber"));

        if (action.equals("createBooking")) {
            LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

            Booking booking = new Booking(user, room, checkIn, checkOut);

            BookingHandle.addBooking(booking);
            RoomHandle.updateAvailability(room.getRoomNumber(), false);

            Double paymentAmount = booking.getRoom().calculatePrice() * booking.getNumOfDays();
            Payment payment = new Payment(paymentAmount, null, user);
            PaymentHandle.addPayment(payment);
            BookingHandle.setBookingPayment(booking.getBookingId(), payment);

            response.sendRedirect(request.getContextPath() + "/MyBookings.jsp");

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("USER");
        String action = request.getParameter("action");
        Booking booking = BookingHandle.findBookingById(request.getParameter("bookingId"));
         if (action.equals("check-in") ) {
             if (booking != null) {
                 BookingHandle.setBookingStatus(booking.getBookingId(), "CHECKED-IN");
             }
             response.sendRedirect(request.getContextPath() + "/MyBookings.jsp");
         }


         if (action.equals("cancel") ) {
             Booking b = BookingHandle.findBookingById(request.getParameter("bookingId"));
             if (booking != null) {
                 RoomHandle.updateAvailability(b.getRoom().getRoomNumber(), true);
                 BookingHandle.setBookingStatus(booking.getBookingId(), "CANCELLED");
             }

             if (user.isAdmin()) {
                 response.sendRedirect(request.getContextPath() + "/admin/ManageBookings.jsp");
             } else {
                 response.sendRedirect(request.getContextPath() + "/MyBookings.jsp");
             }

         }

        if (action.equals("delete") ) {
            Booking b = BookingHandle.findBookingById(request.getParameter("bookingId"));
            if (booking != null) {
                BookingHandle.removeBooking(b);
            }
            response.sendRedirect(request.getContextPath() + "/admin/ManageBookings.jsp");
        }
    }
}

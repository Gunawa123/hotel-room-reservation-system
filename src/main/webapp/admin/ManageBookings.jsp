<%@ page import="modal.Booking" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.User" %>
<%@ page import="modal.Room" %>
<%@ page import="utils.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    if (!loggedUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/");
    }

    BookingHandle.loadFromFile();
    RoomHandle.loadFromFile();
    PaymentHandle.loadFromFile();
    ServiceHandle.loadFromFile();

    LinkedList<Booking> bookings = BookingHandle.getBookings();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Booking Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/manage-bookings.css">
</head>
<body>
<div class="container">
    <!-- Sidebar Navigation -->
    <nav class="admin-menu">
        <h2>Hotel Admin</h2>
        <a href="<%=request.getContextPath()%>/admin/index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp"><i class="fas fa-users-cog"></i> User Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageRooms.jsp"><i class="fas fa-bed"></i> Room Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageBookings.jsp" class="active"><i class="fas fa-calendar-check"></i> Booking Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManagePayments.jsp"><i class="fas fa-credit-card"></i> Payment Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServices.jsp"><i class="fas fa-concierge-bell"></i> Services Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServiceRequests.jsp"><i class="fas fa-reply-all"></i> Service Request Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp"><i class="fas fa-comment-alt"></i> Feedback Management</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <!-- Main Content Area -->
    <main class="admin-content">
        <div class="header">
            <h1>Booking Management</h1>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Guest</th>
                    <th>Room</th>
                    <th>Dates</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>

                <%
                    for (Booking booking : bookings) {
                        if (booking != null) {

                %>

                <tr>
                    <td><%= booking.getBookingId() %></td>
                    <td>
                        <strong><%= booking.getUser().getFirstName() + " " + booking.getUser().getLastName() %></strong>
                        <div class="text-muted"><%= booking.getUser().getEmail() %></div>
                    </td>

                    <% if (booking.getRoom() != null) { %>
                    <td><%=booking.getRoom().getRoomType()%> (Room <%= booking.getRoom().getRoomNumber() %>)</td>
                    <% } else { %>
                    <td>N/A (Room N/A)</td>
                    <% } %>

                    <td>
                        <div><%= booking.getCheckInDate() %> - <%=booking.getCheckOutDate()%></div>
                    </td>

                    <% if (booking.getPayment() != null) { %>
                    <td>Rs. <%=booking.getPayment().getPaymentAmount()%></td>
                    <% } else { %>
                    <td>Rs. N/A</td>
                    <% } %>

                    <td>
                        <%
                            String status = booking.getStatus();
                            String statusClass = "";
                            String icon = "";

                            if (status.equalsIgnoreCase("BOOKED")) {
                                statusClass = "status-pending";
                                icon = "far fa-clock";
                            } else if (status.equalsIgnoreCase("CHECKED-IN")) {
                                statusClass = "status-confirmed";
                                icon = "fas fa-door-open";
                            } else if (status.equalsIgnoreCase("CHECKED-OUT")) {
                                statusClass = "status-completed";
                                icon = "fas fa-door-closed";
                            } else if (status.equalsIgnoreCase("CANCELLED")) {
                                statusClass = "status-cancelled";
                                icon = "fas fa-times-circle";
                            } else {
                                statusClass = "status-pending";
                                icon = "far fa-clock";
                            }
                        %>
                        <span class="status <%= statusClass %>"><i class="<%= icon %>"></i> <%= status %></span>
                    </td>

                    <td class="actions">

                        <% if (booking.getStatus().equals("BOOKED")) {%>
                        <a href="<%=request.getContextPath()%>/BookingServlet?action=cancel&bookingId=<%= booking.getBookingId() %>">
                            <button class="btn btn-archive">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                        </a>
                        <% } %>

                        <%if (booking.getStatus().equals("CANCELLED")) {%>
                        <a href="<%=request.getContextPath()%>/BookingServlet?action=delete&bookingId=<%= booking.getBookingId() %>">
                            <button class="btn btn-delete" onclick="return confirm('Delete Booking?');">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </a>
                        <% } %>

                    </td>
                </tr>

                <% }
                } %>

                </tbody>
            </table>
        </div>
    </main>
</div>

<script>
    function openAddBookingModal() {
        document.getElementById('addBookingModal').style.display = 'flex';
    }

    function openViewBookingModal() {
        document.getElementById('viewBookingModal').style.display = 'flex';
    }

    function openEditBookingModal() {
        document.getElementById('editBookingModal').style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    function confirmBooking() {
        alert('Booking confirmed successfully!');
        // In a real application, you would make an AJAX call to update the booking status
    }

    function cancelBooking() {
        if (confirm('Are you sure you want to cancel this booking?')) {
            alert('Booking cancelled successfully!');
            closeModal('editBookingModal');
            // In a real application, you would make an AJAX call to update the booking status
        }
    }

    function printBookingDetails() {
        window.print();
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>
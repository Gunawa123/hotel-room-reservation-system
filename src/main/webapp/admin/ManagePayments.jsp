<%@ page import="utils.PaymentHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.Payment" %>
<%@ page import="utils.BookingHandle" %>
<%@ page import="modal.Booking" %>
<%@ page import="modal.User" %>
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

    PaymentHandle.loadFromFile();
    LinkedList<Booking> bookings = BookingHandle.getBookings();
    LinkedList<Payment> payments = PaymentHandle.getPayments();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Payment Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/manage-payments.css">
</head>
<body>
<div class="container">
    <!-- Sidebar Navigation -->
    <nav class="admin-menu">
        <h2>Hotel Admin</h2>
        <a href="<%=request.getContextPath()%>/admin/index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp"><i class="fas fa-users-cog"></i> User Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageRooms.jsp"><i class="fas fa-bed"></i> Room Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageBookings.jsp"><i class="fas fa-calendar-check"></i> Booking Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManagePayments.jsp" class="active"><i class="fas fa-credit-card"></i> Payment Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServices.jsp"><i class="fas fa-concierge-bell"></i> Services Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServiceRequests.jsp"><i class="fas fa-reply-all"></i> Service Request Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp"><i class="fas fa-comment-alt"></i> Feedback Management</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <!-- Main Content Area -->
    <main class="admin-content">
        <div class="header">
            <h1>Payment Management</h1>
        </div>

        <!-- Payments Table -->
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Payment ID</th>
                    <th>From</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>

                <% for (Payment payment : payments) {
                    if (payment != null) {
                %>

                <tr>
                    <td><%= payment.getPaymentId() %></td>
                    <td>
                        <strong><%= payment.getUser().getFirstName() + " " + payment.getUser().getLastName() %></strong>
                    </td>
                    <td class="payment-amount">Rs. <%= payment.getPaymentAmount() %></td>
                    <td>
                        <div class="payment-method">
                            <% if (payment.getPaymentMethod().equals("credit_card")) { %>
                            <span>Credit Card</span>
                            <% } else if (payment.getPaymentMethod().equals("debit_card")) { %>
                            <span>Debit Card</span>
                            <% } %>
                        </div>
                    </td>
                    <td><%=payment.getPaymentDate()%></td>

                    <td>
                        <span class="status status-<%= payment.getPaymentStatus().toLowerCase().replace(" ", "-") %>">
                            <%= payment.getPaymentStatus() %>
                        </span>
                    </td>


                    <td class="actions">

                        <% if (!payment.getPaymentStatus().equals("PENDING") && !payment.getPaymentStatus().equals("REFUNDED")) { %>
                        <a href="<%=request.getContextPath()%>/PaymentServlet?action=refund&paymentId=<%=payment.getPaymentId()%>">
                            <button type="submit" class="btn btn-refund" onclick="return confirm('Sure you want to refund?')"><i class="fas fa-exchange-alt"></i> Refund</button>
                        </a>
                        <% } %>

                        <a href="<%=request.getContextPath()%>/PaymentServlet?action=delete&paymentId=<%=payment.getPaymentId()%>">
                            <button class="btn btn-delete" onclick="return confirm('Delete Payment?');"><i class="fas fa-times"></i>Delete</button>
                        </a>

                    </td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </main>
</div>
</body>
</html>
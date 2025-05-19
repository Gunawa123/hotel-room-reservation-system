<%@ page import="modal.Booking" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.User" %>
<%@ page import="modal.ServiceRequest" %>
<%@ page import="utils.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    // check if a user is logged in
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookingHandle.loadFromFile();
    RoomHandle.loadFromFile();
    PaymentHandle.loadFromFile();
    ServiceHandle.loadFromFile();

    LinkedList<Booking> bookings = BookingHandle.getBookingsByUserId(loggedUser.getUserId());
    LinkedList<Booking> bookingsSortedByCheckInDate = BookingHandle.SortBookingsByCheckInDate(bookings);
    LinkedList<ServiceRequest> userServices = ServiceRequestHandle.getServiceRequestsByUser(loggedUser.getUserId());

    LinkedList<Booking> userBookings = new LinkedList<>();



%>

<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Manage Bookings</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --info-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
            --gray-color: #95a5a6;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        /* Navigation */
        .nav-menu {
            background-color: var(--dark-color);
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-menu a:hover {
            background-color: rgba(255,255,255,0.2);
        }

        .nav-menu a i {
            font-size: 0.9rem;
        }

        .nav-menu a.active {
            background-color: var(--primary-color);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h1 {
            color: var(--dark-color);
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .page-header p {
            color: var(--gray-color);
            max-width: 600px;
            margin: 0 auto;
        }

        /* Booking Table */
        .booking-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            overflow-x: auto;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: var(--light-color);
            color: var(--dark-color);
            font-weight: 600;
        }

        /* Status Styles */
        .status, .booking-status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: rgba(243, 156, 18, 0.1);
            color: #f39c12;
        }

        .status-confirmed {
            background-color: rgba(46, 204, 113, 0.1);
            color: #2ecc71;
        }

        .status-completed {
            background-color: rgba(52, 152, 219, 0.1);
            color: #3498db;
        }

        .status-cancelled {
            background-color: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
        }

        /* Icons */
        .fa-door-open, .fa-door-closed, .fa-clock, .fa-times-circle {
            font-size: 0.9em;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.85rem;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
        }

        .btn-danger {
            background: var(--danger-color);
        }

        .btn-danger:hover {
            background-color: #c0392b;
        }

        .btn-success {
            background: var(--success-color);
        }

        .btn-success:hover {
            background-color: #27ae60;
        }

        .btn-info {
            background: var(--info-color);
        }

        .btn-info:hover {
            background-color: #ddb14d;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }

        .section-header {
            color: var(--dark-color);
            font-size: 1.5rem;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-color);
        }

        /* User Welcome Bar */
        .user-welcome-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .user-welcome {
            font-size: 1.1rem;
            font-weight: 500;
        }

        .user-welcome i {
            margin-right: 8px;
        }

        .admin-btn {
            background-color: var(--dark-color);
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .admin-btn:hover {
            background-color: #1a252f;
        }

        .admin-btn i {
            font-size: 0.8rem;
        }

        /* Services Table */
        .services-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            overflow-x: auto;
            margin-bottom: 30px;
        }



        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .nav-menu {
                flex-direction: column;
                gap: 5px;
            }

            th, td {
                padding: 8px;
                font-size: 0.85rem;
            }

            .booking-table, .services-table {
                overflow-x: auto;
            }
            /* User Welcome Bar */
            .user-welcome-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: var(--primary-color);
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .user-welcome {
                font-size: 1.1rem;
                font-weight: 500;
            }

            .user-welcome i {
                margin-right: 8px;
            }
        }
    </style>
</head>
<body>
<div class="container">

    <!-- User Welcome Bar -->
    <div class="user-welcome-bar">
        <div class="user-welcome">
            <i class="fas fa-user-circle"></i>
            Welcome, <%= loggedUser.getFirstName() %> <%= loggedUser.getLastName() %>
        </div>
        <% if (loggedUser.isAdmin()) { %>
        <a href="<%=request.getContextPath()%>/admin/index.jsp" class="admin-btn">
            <i class="fas fa-cog"></i> Admin Dashboard
        </a>
        <% } %>
    </div>

    <nav class="nav-menu">
        <a href="RoomList.jsp"><i class="fas fa-search"></i> Browse Rooms</a>
        <a href="MyBookings.jsp" class="active"><i class="fas fa-calendar-alt"></i> My Bookings</a>
        <a href="MyPayments.jsp"><i class="fas fa-credit-card"></i> My Payments </a>
        <a href="HotelServices.jsp"><i class="fas fa-concierge-bell"></i> Hotel Services</a>
        <a href="MyReviews.jsp"><i class="fas fa-star"></i> My Reviews</a>
        <a href="Profile.jsp"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <div class="page-header">
        <h1>Manage Your Bookings</h1>
        <p>View, modify, or cancel your upcoming and past reservations</p>
    </div>

    <!-- Room Bookings Section -->
    <h2 class="section-header"><i class="fas fa-bed"></i> Room Bookings</h2>
    <div class="booking-table">
        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Status</th>
                <th>Room Type</th>
                <th>Room Number</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Total Price</th>
                <th>Payment Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>

            <%
                for (Booking booking : bookingsSortedByCheckInDate) {
                    if (booking != null) {
            %>

            <tr>
                <td><%=booking.getBookingId()%></td>

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
                    <span class="booking-status <%= statusClass %>"><i class="<%= icon %>"></i> <%= status %></span>
                </td>

                <% if (booking.getRoom() != null) { %>
                    <td><%=booking.getRoom().getRoomType()%></td>
                    <td>Room <%=booking.getRoom().getRoomNumber()%></td>
                <% } else { %>
                    <td>N/A</td>
                    <td>Room N/A</td>
                <% } %>


                <td><%=booking.getCheckInDate()%></td>
                <td><%=booking.getCheckOutDate()%></td>

                <% if (booking.getPayment() != null) { %>
                    <td><%=booking.getPayment().getPaymentAmount()%></td>
                    <td><%=booking.getPayment().getPaymentStatus()%></td>
                <% } else { %>
                    <td>N/A</td>
                    <td>N/A</td>
                <% } %>


                <% if (booking.getStatus().equals("BOOKED")) { %>
                <td class="action-buttons">
                    <a href="<%=request.getContextPath()%>/BookingServlet?action=check-in&bookingId=<%=booking.getBookingId()%>" class="btn btn-success">
                        <i class="fas fa-door-open"></i> Check-In
                    </a>
                    <a href="<%=request.getContextPath()%>/BookingServlet?action=cancel&bookingId=<%=booking.getBookingId()%>" class="btn btn-danger">
                        <i class="fas fa-times-circle"></i> Cancel
                    </a>
                </td>
                <% } else if (booking.getStatus().equals("CHECKED-IN")) { %>
                <td>
                    <a href="BookingPaymentDetails.jsp?bookingId=<%=booking.getBookingId()%>" class="btn btn-info">
                        <i class="fas fa-door"></i> Check-Out
                    </a>
                </td>
                <% } else if (booking.getStatus().equals("CHECKED-OUT")) { %>
                <td>
                    <a href="AddReview.jsp?bookingId=<%=booking.getBookingId()%>" class="btn btn-primary">
                        <i class="fas fa-comments"></i> Review
                    </a>
                </td>
                <% } else if (booking.getStatus().equals("CANCELLED")) { %>
                <td>
                    Cancelled
                </td>
                <% } %>

            </tr>

            <% }
            } %>

            </tbody>
        </table>
    </div>

    <!-- Booked Services Section -->
    <h2 class="section-header"><i class="fas fa-concierge-bell"></i>Services Requests</h2>
    <div class="services-table">
        <table>
            <thead>
            <tr>
                <th>Service ID</th>
                <th>Service Name</th>
                <th>Purchased Date</th>
                <th>Payment ID</th>
                <th>Price</th>
            </tr>
            </thead>
            <tbody>

            <%
                for (ServiceRequest serviceRequest : userServices) {
                    if (serviceRequest != null) {
            %>

            <tr>
                <td><%=serviceRequest.getServiceRequestId()%></td>
                <td><%=serviceRequest.getService().getServiceName()%></td>
                <td><%=serviceRequest.getPayment().getPaymentDate()%></td>
                <td><%=serviceRequest.getPayment().getPaymentId()%></td>
                <td>Rs. <%=serviceRequest.getPayment().getPaymentAmount() %></td>
            </tr>

            <% }
            } %>

            </tbody>
        </table>
    </div>
</div>
</body>
</html>
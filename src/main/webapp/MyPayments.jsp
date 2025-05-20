<%@ page import="utils.PaymentHandle" %>
<%@ page import="modal.Payment" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.User" %>
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

    PaymentHandle.loadFromFile();
    LinkedList<Payment> payments = PaymentHandle.getPayments();
    LinkedList<Payment> userPayments = new LinkedList<>();

    for (Payment payment : payments) {
        if (payment.getUser().getUserId() == loggedUser.getUserId()) {
            userPayments.add(payment);
        }
    }

%>

<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - My Payments</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
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

        /* Payment Table */
        .payment-table {
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

        .payment-status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-paid {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success-color);
        }

        .status-pending {
            background-color: rgba(241, 196, 15, 0.1);
            color: var(--warning-color);
        }

        .status-failed {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger-color);
        }

        .status-refunded {
            background-color: rgba(52, 152, 219, 0.1);
            color: var(--primary-color);
        }

        .payment-amount {
            font-weight: 600;
            color: var(--dark-color);
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
            display: flex;
            align-items: center;
            gap: 10px;
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

            .payment-table {
                overflow-x: auto;
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
        <a href="MyBookings.jsp"><i class="fas fa-calendar-alt"></i> My Bookings</a>
        <a href="MyPayments.jsp" class="active"><i class="fas fa-credit-card"></i> My Payments</a>
        <a href="HotelServices.jsp"><i class="fas fa-concierge-bell"></i> Hotel Services</a>
        <a href="MyReviews.jsp"><i class="fas fa-star"></i> My Reviews</a>
        <a href="Profile.jsp"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <div class="page-header">
        <h1>My Payments</h1>
        <p>View your payment history and transaction details</p>
    </div>

    <!-- Payment History Section -->
    <h2 class="section-header"><i class="fas fa-history"></i> Payment History</h2>
    <div class="payment-table">
        <table>
            <thead>
            <tr>
                <th>Payment ID</th>
                <th>Amount</th>
                <th>Payment Method</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>

            <%

                for (Payment payment : userPayments) {
                    if (payment != null && !payment.getPaymentStatus().equals("PENDING")) {
            %>

            <tr>
                <td><%=payment.getPaymentId()%></td>
                <td class="payment-amount">Rs. <%=payment.getPaymentAmount()%></td>
                <% if (payment.getPaymentMethod().equals("credit_card")) { %>
                <td>Credit Card</td>
                <% } else if (payment.getPaymentMethod().equals("debit_card")) { %>
                <td>Debit Card</td>
                <% } %>
                <td><%= payment.getPaymentDate() %></td>

                <td>
                    <span class="payment-status status-<%= payment.getPaymentStatus().toLowerCase().replace(" ", "-") %>">
                        <%= payment.getPaymentStatus() %>
                    </span>
                </td>

            </tr>
            <% }
            } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
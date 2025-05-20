<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modal.Room" %>
<%@ page import="modal.Booking" %>
<%@ page import="utils.BookingHandle" %>
<%@ page import="modal.User" %>

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
    Booking booking = BookingHandle.findBookingById(request.getParameter("bookingId"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Payment Details</title>
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

        .container {
            max-width: 800px;
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

        .booking-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-weight: 600;
            color: var(--dark-color);
        }

        .payment-form {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-color);
        }

        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 1rem;
        }

        .card-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }

        .price-summary {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .price-total {
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 1.1rem;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            background: var(--success-color);
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
            width: 100%;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #27ae60;
        }

        @media (max-width: 768px) {
            .card-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1>Payment Details</h1>
        <p>Complete your booking by providing payment information</p>
    </div>

    <div class="booking-summary">
        <h3><i class="fas fa-calendar-alt"></i> Booking Summary</h3>
        <div class="summary-item">
            <span class="summary-label">Room Type:</span>
            <span><%=booking.getRoom().getRoomType()%></span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Room Number:</span>
            <span><%=booking.getRoom().getRoomNumber()%></span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Check-in Date:</span>
            <span><%=booking.getCheckInDate()%></span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Check-out Date:</span>
            <span><%=booking.getCheckOutDate()%></span>
        </div>
    </div>

    <form action="PaymentServlet" method="post" class="payment-form">
        <input type="hidden" name="action" value="payForBooking" />
        <input type="hidden" name="bookingId" value="<%=booking.getBookingId()%>">

        <div class="form-group">
            <label for="paymentMethod"><i class="fas fa-credit-card"></i> Payment Method:</label>
            <select id="paymentMethod" name="paymentMethod" required>
                <option value="">Select Payment Method</option>
                <option value="credit_card">Credit Card</option>
                <option value="debit_card">Debit Card</option>
            </select>
        </div>

        <div class="price-summary">
            <h3><i class="fas fa-receipt"></i> Payment Summary</h3>
            <div class="price-row">
                <span>Subtotal:</span>
                <span><%=booking.getRoom().getPrice()%> (per Night)</span>
            </div>
            <div class="price-row">
                <span>Nights Stayed:</span>
                <span>x<%=booking.getNumOfDays()%></span>
            </div>
            <div class="price-row">
                <span>Sub Total:</span>
                <span>Rs. <%=booking.getRoom().getPrice() * booking.getNumOfDays()%></span>
            </div>

            <%if (booking.getRoom().getRoomType().equals("deluxe")) { %>
            <div class="price-row">
                <span>Premium Charge (20%): </span>
                <span>Rs. <%= booking.getRoom().getPrice() * booking.getNumOfDays() * 0.2 %></span>

            </div>
            <% } %>

            <div class="price-total">
                <span>Total: </span>
                <span>Rs. <%= booking.getRoom().calculatePrice() * booking.getNumOfDays() %></span>

            </div>

        </div>

        <button type="submit" class="btn">
            <i class="fas fa-check-circle"></i> Check Out
        </button>
    </form>
</div>
</body>
</html>
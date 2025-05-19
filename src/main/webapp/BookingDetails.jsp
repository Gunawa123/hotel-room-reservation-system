<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modal.Room" %>
<%@ page import="utils.RoomHandle" %>
<%@ page import="modal.User" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.LocalDate" %>

<%
    // check if a user is logged in
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Room room = RoomHandle.findRoomByNumber(request.getParameter("roomNumber"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Booking Details</title>
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

        .booking-container {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }

        .room-info {
            flex: 1;
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .booking-form {
            flex: 1;
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .room-type {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 10px;
        }

        .room-number {
            font-size: 1rem;
            color: var(--gray-color);
            margin-bottom: 15px;
        }

        .room-price {
            color: var(--primary-color);
            font-weight: bold;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }

        .room-features {
            margin-bottom: 20px;
        }

        .room-features div {
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .room-features i {
            color: var(--primary-color);
            width: 20px;
            text-align: center;
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

        input[type="date"], input[type="number"], textarea, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 1rem;
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
            background: var(--primary-color);
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
            background-color: var(--secondary-color);
        }

        @media (max-width: 768px) {
            .booking-container {
                flex-direction: column;
            }
        }
    </style>
    <script>
        function calculatePrice() {
            const checkIn = document.getElementById('checkIn').value;
            const checkOut = document.getElementById('checkOut').value;
            const roomPrice = <%= room.getPrice() %>;

            if (checkIn && checkOut) {
                const startDate = new Date(checkIn);
                const endDate = new Date(checkOut);
                const timeDiff = endDate.getTime() - startDate.getTime();
                const numOfDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

                if (numOfDays > 0) {
                    const subtotal = roomPrice * numOfDays;
                    let premiumCharge = 0;
                    let total = subtotal;

                    <% if (room.getRoomType().equals("deluxe")) { %>
                    premiumCharge = subtotal * 0.2;
                    total = subtotal + premiumCharge;
                    <% } %>

                    document.getElementById('numOfDays').textContent = 'x' + numOfDays;
                    document.getElementById('subtotal').textContent = 'Rs. ' + subtotal.toFixed(2);

                    <% if (room.getRoomType().equals("deluxe")) { %>
                    document.getElementById('premiumCharge').textContent = 'Rs. ' + premiumCharge.toFixed(2);
                    document.getElementById('premiumRow').style.display = 'flex';
                    <% } else { %>
                    document.getElementById('premiumRow').style.display = 'none';
                    <% } %>

                    document.getElementById('total').textContent = 'Rs. ' + total.toFixed(2);
                }
            }
        }
    </script>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1>Booking Details</h1>
        <p>Please provide your booking information</p>
    </div>

    <div class="booking-container">
        <div class="room-info">
            <div class="room-type"><%=room.getRoomType()%> Room</div>
            <div class="room-number">Room Number <%= room.getRoomNumber()%></div>
            <div class="room-price">Rs. <%= room.getPrice()%> per night</div>
            <div class="room-features">
                <div><i class="fas fa-user-friends"></i> <%= room.getCapacity()%> Person</div>
                <div>
                    <p><%= room.getDescription()%></p>
                </div>
            </div>
        </div>

        <form action="BookingServlet" method="post" class="booking-form">
            <input type="hidden" name="roomNumber" value="<%= room.getRoomNumber()%>">
            <input type="hidden" name="action" value="createBooking">

            <div class="form-group">
                <label for="checkIn"><i class="fas fa-calendar-check"></i> Check-in Date:</label>
                <input type="date" id="checkIn" name="checkIn" required onchange="calculatePrice()">
            </div>

            <div class="form-group">
                <label for="checkOut"><i class="fas fa-calendar-times"></i> Check-out Date:</label>
                <input type="date" id="checkOut" name="checkOut" required onchange="calculatePrice()">
            </div>

            <div class="price-summary">
                <h3><i class="fas fa-receipt"></i> Price Summary</h3>
                <div class="price-row">
                    <span>Subtotal:</span>
                    <span>Rs. <%= room.getPrice() %> (per Night)</span>
                </div>
                <div class="price-row">
                    <span>Nights Stayed:</span>
                    <span id="numOfDays">x0</span>
                </div>
                <div class="price-row">
                    <span>Sub Total:</span>
                    <span id="subtotal">Rs. 0.00</span>
                </div>

                <div class="price-row" id="premiumRow" style="display: <%= room.getRoomType().equals("deluxe") ? "flex" : "none" %>;">
                    <span>Premium Charge (20%): </span>
                    <span id="premiumCharge">Rs. 0.00</span>
                </div>

                <div class="price-total">
                    <span>Total: </span>
                    <span id="total">Rs. 0.00</span>
                </div>
            </div>

            <button type="submit" class="btn">
                <i class="fa-solid fa-door-closed"></i> Book Now
            </button>
        </form>
    </div>
</div>
</body>

</html>
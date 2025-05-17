<%@ page import="utils.RoomHandle" %>
<%@ page import="modal.Room" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.User" %>
<!DOCTYPE html>
<%
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    RoomHandle.loadFromFile();
    LinkedList<Room> availableRooms = RoomHandle.getAvailableRooms();
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Available Rooms</title>
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

        /* Room Cards */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .room-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }

        .room-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .room-type {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 5px;
        }

        .room-number {
            font-size: 0.9rem;
            color: var(--gray-color);
            margin-bottom: 10px;
        }

        .room-price {
            color: var(--primary-color);
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 1rem;
        }

        .room-features {
            margin-bottom: 15px;
            font-size: 0.85rem;
            color: var(--gray-color);
        }

        .room-features div {
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .room-features i {
            color: var(--primary-color);
            width: 16px;
            text-align: center;
        }

        .room-actions {
            text-align: right;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9rem;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: var(--secondary-color);
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
            .room-grid {
                grid-template-columns: 1fr;
            }

            .nav-menu {
                flex-direction: column;
                gap: 5px;
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
        <a href="RoomList.jsp" class="active"><i class="fas fa-search"></i> Browse Rooms</a>
        <a href="MyBookings.jsp"><i class="fas fa-calendar-alt"></i> My Bookings</a>
        <a href="MyPayments.jsp"><i class="fas fa-credit-card"></i> My Payments </a>
        <a href="HotelServices.jsp"><i class="fas fa-concierge-bell"></i> Hotel Services</a>
        <a href="MyReviews.jsp"><i class="fas fa-star"></i> My Reviews</a>
        <a href="Profile.jsp"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <div class="page-header">
        <h1>Available Rooms</h1>
        <p>Choose from our selection of comfortable and well-appointed rooms</p>
    </div>

    <h2>Standard Rooms</h2>
    <div class="room-grid">

        <% for (Room room : availableRooms) {
            if (room != null && room.getRoomType().equals("standard")) {
        %>

        <!-- Room 1 -->
        <div class="room-card">
            <div class="room-type">Standard Room</div>
            <div class="room-number">Room <%= room.getRoomNumber() %></div>
            <div class="room-price">Rs. <%= room.getPrice() %> per night</div>
            <div class="room-features">
                <div><i class="fas fa-user-friends"></i> <%= room.getCapacity() %> guests</div>
                <div><i class="fas fa-wifi"></i> Free WiFi</div>
                <div><i class="fas fa-tv"></i> Smart TV</div>
            </div>
            <div class="room-actions">
                <a href="BookingDetails.jsp?roomNumber=<%=room.getRoomNumber()%>" class="btn">
                    <i class="fas fa-calendar-check"></i> Book Now
                </a>
            </div>
        </div>
        <% }
        }%>

    </div>

    <h2>Deluxe Rooms</h2>
    <div class="room-grid">
        <!-- Room 4 -->

        <% for (Room room : availableRooms) {
            if (room != null && room.getRoomType().equals("deluxe")) {
        %>

        <div class="room-card">
            <div class="room-type">Deluxe Room</div>
            <div class="room-number">Room <%= room.getRoomNumber() %></div>
            <div class="room-price">Rs. <%= room.getPrice() %> + 20% per night</div>
            <div class="room-features">
                <div><i class="fas fa-user-friends"></i><%= room.getCapacity() %> guests</div>
                <div><i class="fas fa-wifi"></i> Premium WiFi</div>
                <div><i class="fas fa-hot-tub"></i> Hot Tub </div>
                <div><i class="fas fa-utensils"></i> Breakfast included</div>
            </div>
            <div class="room-actions">
                <a href="BookingDetails.jsp?roomNumber=<%=room.getRoomNumber()%>" class="btn">
                    <i class="fas fa-calendar-check"></i> Book Now
                </a>
            </div>
        </div>

        <% }
        } %>
    </div>
</div>
</body>
</html>
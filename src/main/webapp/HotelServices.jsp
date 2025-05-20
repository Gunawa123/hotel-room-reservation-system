<%@ page import="utils.ServiceHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.Service" %>
<%@ page import="modal.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // check if a user is logged in
    User loggedUser = null;

    if (session.getAttribute("USER") != null) {
        loggedUser = (User) session.getAttribute("USER");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ServiceHandle.loadFromFile();
    LinkedList<Service> services = ServiceHandle.getActiveServices();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Hotel Services</title>
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

        /* Services Grid */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
            /* Prevent layout shifts */
            contain: content;
        }

        .service-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s;
            /* Ensure content doesn't overflow */
            overflow: hidden;
            /* Ensure consistent height for cards */
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .service-card:hover {
            transform: translateY(-5px);
        }

        /* Ensure text doesn't overflow */
        .service-card h3,
        .service-card p {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: normal;
        }

        /* Optional: Limit description length */
        .service-card p {
            max-height: 4.8em; /* Approx 3 lines at 1.6 line-height */
            line-height: 1.6;
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

            .services-grid {
                grid-template-columns: 1fr;
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
        <a href="MyPayments.jsp"><i class="fas fa-credit-card"></i> My Payments </a>
        <a href="HotelServices.jsp" class="active"><i class="fas fa-concierge-bell"></i> Hotel Services</a>
        <a href="MyReviews.jsp"><i class="fas fa-star"></i> My Reviews</a>
        <a href="Profile.jsp"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <div class="page-header">
        <h1>Hotel Services</h1>
        <p>Explore and book additional services to enhance your stay</p>
    </div>

    <% if (services == null || services.isEmpty()) { %>
    <p>No services available at the moment.</p>
    <% } else { %>
    <div class="services-grid">
        <%
            for (Service service : services) {
                if (service != null) {
        %>
        <div class="service-card">
            <h3><%= service.getServiceName() %></h3>
            <p><%= service.getServiceDescription() %></p>
            <div class="service-price">Rs. <%= service.getServicePrice() %></div>
            <a href="ServicePaymentDetails.jsp?serviceId=<%= service.getServiceId() %>">
                <button class="btn btn-primary"><i class="fas fa-plus"></i> Book Now</button>
            </a>
        </div>
        <%
                }
            }
        %>
    </div>
    <% } %>
</div>
</body>
</html>
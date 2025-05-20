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

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin Dashboard</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container">
    <header>
        <h1>Hotel Management Admin Dashboard</h1>
    </header>

    <div class="welcome-message">
        Welcome back, Administrator! Manage your hotel efficiently with our tools.
    </div>

    <div class="dashboard-grid">

        <!-- User Management Card -->
        <div class="dashboard-card card-user">
            <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp">
                <i class="fas fa-users-cog"></i>
                <span class="card-title">User Management</span>
            </a>
        </div>

        <!-- Room Management Card -->
        <div class="dashboard-card card-room">
            <a href="<%=request.getContextPath()%>/admin/ManageRooms.jsp">
                <i class="fas fa-bed"></i>
                <span class="card-title">Room Management</span>
            </a>
        </div>

        <!-- Booking Management Card -->
        <div class="dashboard-card card-booking">
            <a href="<%=request.getContextPath()%>/admin/ManageBookings.jsp">
                <i class="fas fa-calendar-check"></i>
                <span class="card-title">Booking Management</span>
            </a>
        </div>

        <!-- Payment Management Card -->
        <div class="dashboard-card card-payment">
            <a href="<%=request.getContextPath()%>/admin/ManagePayments.jsp">
                <i class="fas fa-credit-card"></i>
                <span class="card-title">Payment Management</span>
            </a>
        </div>

        <!-- Feedback Management Card -->
        <div class="dashboard-card card-feedback">
            <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp">
                <i class="fas fa-comment-alt"></i>
                <span class="card-title">Feedback Management</span>
            </a>
        </div>

        <!-- Reports Card -->
        <div class="dashboard-card card-reports">
            <a href="<%=request.getContextPath()%>/admin/ManageServices.jsp">
                <i class="fa-solid fa-bell-concierge"></i>
                <span class="card-title">Services Management</span>
            </a>
        </div>

        <div class="dashboard-card card-service-requests">
            <a href="<%=request.getContextPath()%>/admin/ManageServiceRequests.jsp">
                <i class="fa-solid fa-reply-all"></i>
                <span class="card-title">Service Requests Management</span>
            </a>
        </div>

        <!-- Logout Card -->
        <div class="dashboard-card card-logout">
            <a href="<%=request.getContextPath()%>/LogoutServlet">
                <i class="fas fa-sign-out-alt"></i>
                <span class="card-title">Logout</span>
            </a>
        </div>
    </div>

    <footer>
        &copy; 2023 Hotel Management System | Admin Panel
    </footer>
</div>
</body>
</html>
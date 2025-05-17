<%@ page import="utils.ReviewHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.Review" %>
<%@ page import="modal.User" %>
<%@ page import="utils.BookingHandle" %>
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

    ReviewHandle.loadFromFile();
    BookingHandle.loadFromFile();
    LinkedList<Review> userReviews = ReviewHandle.findReviewsByUser(loggedUser.getUserId());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - My Reviews</title>
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

        /* Reviews Section */
        .reviews-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
        }

        .review-card {
            padding: 20px 0;
            border-bottom: 1px solid #eee;
        }

        .review-card:last-child {
            border-bottom: none;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .review-room {
            font-weight: 600;
            color: var(--dark-color);
        }

        .review-date {
            color: var(--gray-color);
            font-size: 0.85rem;
        }

        .review-rating {
            color: var(--warning-color);
            margin-bottom: 10px;
        }

        .review-text {
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .review-images {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .review-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .review-image:hover {
            transform: scale(1.05);
        }

        .review-actions {
            display: flex;
            gap: 10px;
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

        /* No Reviews */
        .no-reviews {
            text-align: center;
            padding: 40px;
            color: var(--gray-color);
        }

        .no-reviews i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--light-color);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .close-modal {
            color: var(--gray-color);
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close-modal:hover {
            color: var(--dark-color);
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
        }

        select, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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

            .review-header {
                flex-direction: column;
                align-items: flex-start;
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
        <a href="RoomList.jsp"><i class="fas fa-search"></i> Browse Rooms</a>
        <a href="MyBookings.jsp"><i class="fas fa-calendar-alt"></i> My Bookings</a>
        <a href="MyPayments.jsp"><i class="fas fa-credit-card"></i> My Payments </a>
        <a href="HotelServices.jsp"><i class="fas fa-concierge-bell"></i> Hotel Services</a>
        <a href="MyReviews.jsp" class="active"><i class="fas fa-star"></i> My Reviews</a>
        <a href="Profile.jsp"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <div class="page-header">
        <h1>My Reviews</h1>
        <p>View and manage your past reviews of our hotel and services</p>
    </div>

    <div class="reviews-container">

        <%

        for (Review review : userReviews) {
            if (review != null) {

        %>

        <div class="review-card">
            <div class="review-header">
                <div class="review-room"><%= review.getBooking().getRoom().getRoomType() %> Room (Room <%= review.getBooking().getRoom().getRoomNumber() %>)</div>
                <div class="review-date">Posted on <%= review.getReviewDate() %></div>
            </div>
            <div class="review-rating">
                Rating: <% for (int i = 0; i < review.getRating(); i++) { %>
                <i class="fas fa-star"></i>
                <% } %>
            </div>
            <div class="review-text">
                <%= review.getReviewText() %>
            </div>
            <div class="review-actions">
                <button class="btn btn-primary" onclick="openEditModal()"><i class="fas fa-edit"></i> Edit Review</button>
                <a href="ReviewServlet?action=delete&reviewId=<%=review.getReviewId()%>">
                    <button class="btn btn-danger" onclick="openDeleteModal()"><i class="fas fa-trash"></i> Delete </button>
                </a>

            </div>
        </div>

        <% }
        } %>

    </div>

    <!-- Edit Review Modal -->
    <div id="editReviewModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeEditModal()">&times;</span>
            <h2><i class="fas fa-edit"></i> Edit Review</h2>
            <form id="editReviewForm">
                <div class="form-group">
                    <label for="editRating">Rating:</label>
                    <select id="editRating" name="rating">
                        <option value="1">1 - Poor</option>
                        <option value="2">2 - Fair</option>
                        <option value="3">3 - Good</option>
                        <option value="4" selected>4 - Very Good</option>
                        <option value="5">5 - Excellent</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="editReviewText">Review:</label>
                    <textarea id="editReviewText" name="reviewText">The deluxe room was spacious and comfortable with a great view of the city. Housekeeping was excellent, though the minibar selection could be improved. Would definitely stay here again!</textarea>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                    <button type="button" class="btn btn-danger" onclick="closeEditModal()"><i class="fas fa-times"></i> Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Review Modal -->
    <div id="deleteReviewModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeDeleteModal()">&times;</span>
            <h2><i class="fas fa-exclamation-triangle"></i> Delete Review</h2>
            <p>Are you sure you want to delete this review? This action cannot be undone.</p>
            <div class="modal-actions">
                <button type="button" class="btn btn-danger"><i class="fas fa-trash"></i> Delete</button>
                <button type="button" class="btn btn-primary" onclick="closeDeleteModal()"><i class="fas fa-times"></i> Cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Modal control functions
    function openEditModal() {
        document.getElementById('editReviewModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editReviewModal').style.display = 'none';
    }

    function openDeleteModal() {
        document.getElementById('deleteReviewModal').style.display = 'block';
    }

    function closeDeleteModal() {
        document.getElementById('deleteReviewModal').style.display = 'none';
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }

</script>
</body>
</html>
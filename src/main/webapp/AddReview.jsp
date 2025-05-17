<%@ page import="utils.BookingHandle" %>
<%@ page import="modal.Booking" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    BookingHandle.loadFromFile();
    Booking booking = BookingHandle.findBookingById(request.getParameter("bookingId"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LuxStay - Create Review</title>
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
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
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
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
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

        /* Review Form */
        .review-form {
            background: white;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            padding: 30px;
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

        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
        }

        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            min-height: 150px;
            resize: vertical;
        }

        .image-preview {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .preview-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
        }

        .remove-image {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--danger-color);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            cursor: pointer;
        }

        .image-container {
            position: relative;
            margin-bottom: 10px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 1rem;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            width: 100%;
        }

        .btn-primary {
            background: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
        }

        /* Booking Info */
        .booking-info {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .booking-info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .booking-info-label {
            font-weight: 600;
            color: var(--dark-color);
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .nav-menu {
                flex-direction: column;
                gap: 5px;
                padding: 10px;
            }

            .container {
                padding: 0 15px;
            }

            .review-form {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h1>Write a Review</h1>
        <p>Share your experience about your recent stay with us</p>
    </div>

    <div class="review-form">
        <div class="booking-info">
            <div class="booking-info-item">
                <span class="booking-info-label">Room Type:</span>
                <span><%=booking.getRoom().getRoomType()%> Room</span>
            </div>
            <div class="booking-info-item">
                <span class="booking-info-label">Room Number:</span>
                <span><%= booking.getRoom().getRoomNumber() %></span>
            </div>
            <div class="booking-info-item">
                <span class="booking-info-label">Stay Dates:</span>
                <span><%=booking.getCheckInDate()%> - <%=booking.getCheckOutDate()%></span>
            </div>
        </div>

        <form action="ReviewServlet" method="post">
            <input type="hidden" name="action" value="addReview">
            <input type="hidden" name="bookingId" value="<%=booking.getBookingId()%>">

            <div class="form-group">
                <label for="rating">Rating:</label>
                <select id="rating" name="rating" required>
                    <option value="">Select a rating</option>
                    <option value="1">1 - Poor</option>
                    <option value="2">2 - Fair</option>
                    <option value="3">3 - Good</option>
                    <option value="4">4 - Very Good</option>
                    <option value="5">5 - Excellent</option>
                </select>
            </div>

            <div class="form-group">
                <label for="reviewText">Review:</label>
                <textarea id="reviewText" name="reviewText" placeholder="Tell us about your experience..." required></textarea>
            </div>

            <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit Review</button>
        </form>
    </div>
</div>

</body>
</html>
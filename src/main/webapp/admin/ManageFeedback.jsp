<%@ page import="utils.ReviewHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.Review" %>
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

    ReviewHandle.loadFromFile();
    LinkedList<Review> reviews = ReviewHandle.getReviews();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Feedback Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/manage-feedback.css">
    <style>
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            width: 60%;
            max-width: 600px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .feedback-details {
            margin: 20px 0;
        }

        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }

        .detail-label {
            font-weight: bold;
            width: 150px;
        }

        .feedback-comment {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
    </style>
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
        <a href="<%=request.getContextPath()%>/admin/ManagePayments.jsp"><i class="fas fa-credit-card"></i> Payment Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServices.jsp"><i class="fas fa-concierge-bell"></i> Services Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServiceRequests.jsp"><i class="fas fa-reply-all"></i> Service Request Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp" class="active"><i class="fas fa-comment-alt"></i> Feedback Management</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <!-- Main Content Area -->
    <main class="admin-content">
        <div class="header">
            <h1>Feedback Management</h1>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Feedback ID</th>
                    <th>Guest</th>
                    <th>Rating</th>
                    <th>Booking Reference</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Review review : reviews) {
                        if (review != null) {
                %>
                <tr>
                    <td><%= review.getReviewId() %></td>
                    <td>
                        <strong><%=review.getBooking().getUser().getFirstName() + " " + review.getBooking().getUser().getLastName() %></strong>

                    <% if (review.getBooking().getRoom() != null) { %>
                        <div class="text-muted">Room <%= review.getBooking().getRoom().getRoomNumber() %> (<%=review.getBooking().getRoom().getRoomType()%>)</div>
                    <% } else { %>
                        <div class="text-muted">Room N/A (N/A)</div>
                    <% } %>

                    </td>
                    <td>
                        <div class="rating">
                            <span class="rating-value">
                                <% for (int i = 0; i < review.getRating(); i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                            </span>
                        </div>
                    </td>
                    <td><%= review.getBooking().getBookingId() %></td>
                    <td><%= review.getReviewDate() %></td>
                    <td class="actions">
                        <button class="btn btn-view" onclick="openViewFeedbackModal('<%= review.getReviewId() %>',
                                '<%= review.getBooking().getUser().getFirstName() + " " + review.getBooking().getUser().getLastName() %>',
                                '<%= review.getBooking().getBookingId() %>',
                                'Room <%= review.getBooking().getRoom().getRoomNumber() %> (<%=review.getBooking().getRoom().getRoomType()%>)',
                                '<%= review.getRating() %>',
                                '<%= review.getReviewDate() %>',
                                '<%= review.getReviewText() %>')">
                            <i class="fas fa-eye"></i> View
                        </button>
                        <a href="<%= request.getContextPath() %>/ReviewServlet?action=adminDelete&reviewId=<%= review.getReviewId() %>">
                            <button class="btn btn-archive" onclick="return confirm('Remove Review?');">
                                <i class="fas fa-archive"></i> Remove
                            </button>
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

<!-- View Feedback Modal -->
<div id="viewFeedbackModal" class="modal">
    <div class="modal-content">
        <h2>Feedback Details</h2>
        <div class="feedback-details">
            <div class="detail-row">
                <div class="detail-label">Feedback ID:</div>
                <div class="detail-value" id="modal-review-id"></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Guest Name:</div>
                <div class="detail-value" id="modal-guest-name"></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Booking Reference:</div>
                <div class="detail-value" id="modal-booking-ref"></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Room:</div>
                <div class="detail-value" id="modal-room-info"></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Rating:</div>
                <div class="detail-value">
                    <div class="rating" id="modal-rating">
                        <!-- Stars will be inserted here by JavaScript -->
                    </div>
                </div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Submitted:</div>
                <div class="detail-value" id="modal-review-date"></div>
            </div>

            <div class="feedback-comment">
                <strong>Guest Comment:</strong>
                <p id="modal-comment"></p>
            </div>
        </div>
        <div class="form-actions">
            <button type="button" class="btn" onclick="closeModal('viewFeedbackModal')">
                <i class="fas fa-times"></i> Close
            </button>
        </div>
    </div>
</div>

<script>
    function openViewFeedbackModal(reviewId, guestName, bookingRef, roomInfo, rating, reviewDate, comment) {
        // Set the modal content with the passed parameters
        document.getElementById('modal-review-id').textContent = reviewId;
        document.getElementById('modal-guest-name').textContent = guestName;
        document.getElementById('modal-booking-ref').textContent = bookingRef;
        document.getElementById('modal-room-info').textContent = roomInfo;
        document.getElementById('modal-review-date').textContent = reviewDate;
        document.getElementById('modal-comment').textContent = comment;

        // Create rating stars
        const ratingContainer = document.getElementById('modal-rating');
        ratingContainer.innerHTML = '';
        for (let i = 0; i < rating; i++) {
            const star = document.createElement('i');
            star.className = 'fas fa-star';
            ratingContainer.appendChild(star);
        }

        // Show the modal
        document.getElementById('viewFeedbackModal').style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>
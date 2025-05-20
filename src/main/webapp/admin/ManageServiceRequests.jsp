<%@ page import="modal.ServiceRequest" %>
<%@ page import="utils.ServiceRequestHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="utils.UserHandle" %>
<%@ page import="utils.ServiceHandle" %>
<%@ page import="utils.PaymentHandle" %>
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

    ServiceRequestHandle.loadFromFile();
    LinkedList<ServiceRequest> serviceRequests = ServiceRequestHandle.getServiceRequests();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Service Request Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/manage-bookings.css">
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
        <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp"><i class="fas fa-comment-alt"></i> Feedback Management</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <!-- Main Content Area -->
    <main class="admin-content">
        <div class="header">
            <h1>Service Request Management</h1>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Guest</th>
                    <th>Service</th>
                    <th>Purchase Date</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>

                <%
                    for (ServiceRequest serviceRequest : serviceRequests) {
                        if (serviceRequest != null) {
                %>

                <tr>
                    <td><%= serviceRequest.getServiceRequestId() %></td>
                    <td>
                        <strong><%= serviceRequest.getUser().getFirstName() + " " + serviceRequest.getUser().getLastName() %></strong>
                        <div class="text-muted"><%= serviceRequest.getUser().getEmail() %></div>
                    </td>


                    <% if (serviceRequest.getService() != null) { %>
                        <td><%= serviceRequest.getService().getServiceName() %></td>
                    <% } else { %>
                    <td>N/A</td>
                    <% } %>

                    <% if (serviceRequest.getPayment() != null) { %>
                        <td><%= serviceRequest.getPayment().getPaymentDate() %></td>
                        <td>Rs. <%= serviceRequest.getPayment().getPaymentAmount() %></td>
                    <% } else { %>
                        <td>N/A </td>
                        <td>Rs. N/A </td>
                    <% } %>

                    <td class="actions">
                        <a href="<%=request.getContextPath()%>/ServiceRequestServlet?action=deleteServiceRequest&serviceRequestId=<%= serviceRequest.getServiceRequestId() %>">
                            <button class="btn btn-delete" onclick="return confirm('Delete Service Request?');">
                                <i class="fas fa-times"></i> Delete
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

</body>
</html>
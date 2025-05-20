<%@ page import="modal.Service" %>
<%@ page import="utils.ServiceHandle" %>
<%@ page import="java.util.LinkedList" %>
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

    ServiceHandle.loadFromFile();
    LinkedList<Service> services = ServiceHandle.getServices();

    if (services == null) {
        services = new LinkedList<Service>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Services Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/manage-services.css">
</head>
<body>
<div class="container">
    <nav class="admin-menu">
        <h2>Hotel Admin</h2>
        <a href="<%=request.getContextPath()%>/admin/index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp"><i class="fas fa-users-cog"></i> User Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageRooms.jsp"><i class="fas fa-bed"></i> Room Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageBookings.jsp"><i class="fas fa-calendar-check"></i> Booking Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManagePayments.jsp"><i class="fas fa-credit-card"></i> Payment Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServices.jsp" class="active"><i class="fas fa-concierge-bell"></i> Services Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageServiceRequests.jsp"><i class="fas fa-reply-all"></i> Service Request Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageFeedback.jsp"><i class="fas fa-comment-alt"></i> Feedback Management</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <main class="admin-content">
        <div class="header">
            <h1>Services Management</h1>
        </div>

        <div class="toolbar">
            <div class="filter-options">
                <button onclick="openModal('addServiceModal')">
                    <i class="fas fa-plus"></i> Add Service
                </button>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Service ID</th>
                    <th>Service Name</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (services.isEmpty()) {
                %>
                <tr>
                    <td colspan="5" style="text-align:center;">No services available.</td>
                </tr>
                <%
                } else {
                    for (Service service : services) {
                        if (service != null) {
                            String statusClass = "active".equalsIgnoreCase(service.getServiceStatus()) ? "status-active" : "status-inactive";
                %>
                <tr>
                    <td><%= service.getServiceId() %></td>
                    <td><strong><%= service.getServiceName() %></strong></td>
                    <td>Rs. <%= String.format("%.2f", service.getServicePrice()) %></td>
                    <td><span class="status <%= statusClass %>"><%= service.getServiceStatus() %></span></td>
                    <td class="actions">

                           <button class="btn btn-edit" onclick="openEditServiceModal('<%= service.getServiceId() %>')">
                            <i class="fas fa-edit"></i> Edit
                            </button>

                        <a href="<%=request.getContextPath()%>/ServiceServlet?action=delete&serviceId=<%=service.getServiceId()%>">
                            <button class="btn btn-delete" onclick="return confirm('Delete Service?');">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </a>
                    </td>
                </tr>
                <%
                            }
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div id="addServiceModal" class="modal">
    <div class="modal-content">
        <h2>Add New Service</h2>
        <form action="<%= request.getContextPath() %>/ServiceServlet" method="post">
            <input type="hidden" name="action" value="addService">
            <div class="form-group">
                <label for="addServiceName">Service Name</label>
                <input type="text" name="serviceName" id="addServiceName" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="addServicePrice">Price (Rs.)</label>
                    <input type="number" name="servicePrice" id="addServicePrice" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="addServiceStatus">Status</label>
                    <select id="addServiceStatus" name="serviceStatus" required>
                        <option value="active" selected>Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="addServiceDescription">Description</label>
                <textarea id="addServiceDescription" name="serviceDescription" rows="3"></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn" onclick="closeModal('addServiceModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Save Service</button>
            </div>
        </form>
    </div>
</div>

<%
    for (Service service : services) {
        if (service != null) {
%>
<div id="editServiceModal_<%= service.getServiceId() %>" class="modal">
    <div class="modal-content">
        <h2>Edit Service</h2>
        <form action="<%= request.getContextPath() %>/ServiceServlet" method="post">
            <input type="hidden" name="action" value="editService">
            <input type="hidden" name="serviceId" value="<%= service.getServiceId() %>">

            <div class="form-group">
                <label for="editServiceName_<%= service.getServiceId() %>">Service Name</label>
                <input type="text" id="editServiceName_<%= service.getServiceId() %>" name="serviceName" value="<%= service.getServiceName() %>" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="editServicePrice_<%= service.getServiceId() %>">Price (Rs.)</label>
                    <input type="number" id="editServicePrice_<%= service.getServiceId() %>" name="servicePrice" value="<%= service.getServicePrice() %>" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="editServiceStatus_<%= service.getServiceId() %>">Status</label>
                    <select id="editServiceStatus_<%= service.getServiceId() %>" name="serviceStatus" required>
                        <option value="active" <%="active".equalsIgnoreCase(service.getServiceStatus()) ? "selected" : "" %>>Active</option>
                        <option value="inactive" <%="inactive".equalsIgnoreCase(service.getServiceStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="editServiceDescription_<%= service.getServiceId() %>">Description</label>
                <textarea id="editServiceDescription_<%= service.getServiceId() %>" name="serviceDescription" rows="3"><%= service.getServiceDescription() != null ? service.getServiceDescription() : "" %></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn" onclick="closeModal('editServiceModal_<%= service.getServiceId() %>')">Cancel</button>
                <button type="submit" class="btn btn-success">Save Changes</button>
            </div>
        </form>
    </div>
</div>
<%
        }
    }
%>

<form id="deleteServiceForm" action="<%= request.getContextPath() %>/ServiceServlet" method="post" style="display:none;">
    <input type="hidden" name="action" value="deleteService">
    <input type="hidden" name="serviceId" id="deleteServiceId">
</form>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'flex';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    function openEditServiceModal(serviceId) {
        const modalId = 'editServiceModal_' + serviceId;
        openModal(modalId);
    }

    // function confirmDeleteService(serviceId, serviceName) {
    //     if (confirm("Are you sure you want to delete the service: '" + serviceName + "' (ID: " + serviceId + ")?")) {
    //         document.getElementById('deleteServiceId').value = serviceId;
    //         document.getElementById('deleteServiceForm').submit();
    //     }
    // }

    window.onclick = function(event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(function(modal) {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        });
    }

</script>

</body>
</html>
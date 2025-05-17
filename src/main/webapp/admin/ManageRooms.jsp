<%@ page import="utils.RoomHandle" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="modal.Room" %>
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

    RoomHandle.loadFromFile();
    LinkedList<Room> rooms = RoomHandle.getRooms();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Admin - Room Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/admin/css/manage-rooms.css">
</head>
<body>
<div class="container">
    <!-- Sidebar Navigation -->
    <nav class="admin-menu">
        <h2>Hotel Admin</h2>
        <a href="<%=request.getContextPath()%>/admin/index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp"><i class="fas fa-users-cog"></i> User Management</a>
        <a href="<%=request.getContextPath()%>/admin/ManageRooms.jsp" class="active"><i class="fas fa-bed"></i> Room Management</a>
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
            <h1>Room Management</h1>
        </div>

        <div class="toolbar">
            <div class="filter-options">
                <button onclick="openAddRoomModal()">
                    <i class="fas fa-plus"></i> Add Room
                </button>
            </div>
        </div>

        <%-- Display error message if deletion fails --%>
        <% String message = (String) request.getAttribute("message");
            if (message != null) { %>
        <div class="error"> <%=message%> </div>
        <% } %>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Room No.</th>
                    <th>Type</th>
                    <th>Price/Night</th>
                    <th>Capacity</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <% for (Room room : rooms) {
                        if (room != null) {
                    %>
                    <td><%=room.getRoomNumber()%></td>
                    <td><%=room.getRoomType()%></td>
                    <td>Rs. <%=room.getPrice() %></td>
                    <td><%=room.getCapacity()%></td>

                     <% if (room.isAvailable()) { %>
                    <td><span class="status status-available">Available</span></td>
                    <% } else { %>
                    <td><span class="status status-unavailable">Unavailable</span></td>
                    <% } %>

                    <td class="actions">
                        <a href="<%=request.getContextPath()%>/RoomServlet?action=delete&roomNumber=<%=room.getRoomNumber()%>">
                        <button class="btn btn-delete" onclick="return confirm('Delete Room?');">
                            <i class="fas fa-trash"></i> Delete
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

<!-- Add Room Modal -->
<div id="addRoomModal" class="modal">
    <div class="modal-content">
        <h2>Add New Room</h2>
        <form action="<%=request.getContextPath()%>/RoomServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="roomNumber">Room Number</label>
                <input type="text" id="roomNumber" name="roomNumber" required>
            </div>
            <div class="form-group">
                <label for="roomType">Room Type</label>
                <select id="roomType" name="roomType" required>
                    <option value="">Select Type</option>
                    <option value="standard">Standard</option>
                    <option value="deluxe">Deluxe</option>
                </select>
            </div>
            <div class="form-group">
                <label for="price">Price per Night (Rs.)</label>
                <input type="number" id="price" name="price" required>
            </div>
            <div class="form-group">
                <label for="capacity">Capacity</label>
                <input type="number" id="capacity" name="capacity" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" rows="3" name="description"></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn" onclick="closeModal('addRoomModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Save Room</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Room Modal -->
<div id="editRoomModal" class="modal">
    <div class="modal-content">
        <h2>Edit Room</h2>
        <form action="RoomServlet" method="post">
            <div class="form-group">
                <label for="editRoomNumber">Room Number</label>
                <input type="text" id="editRoomNumber" value="101" required>
            </div>
            <div class="form-group">
                <label for="editRoomType">Room Type</label>
                <select id="editRoomType" required>
                    <option value="standard">Standard</option>
                    <option value="deluxe">Deluxe</option>
                </select>
            </div>
            <div class="form-group">
                <label for="editPrice">Price per Night ($)</label>
                <input type="number" id="editPrice" value="120" required>
            </div>
            <div class="form-group">
                <label for="editCapacity">Capacity</label>
                <input type="number" id="editCapacity" value="2" required>
            </div>
            <div class="form-group">
                <label for="editDescription">Description</label>
                <textarea id="editDescription" rows="3">Standard room with all basic amenities</textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn" onclick="closeModal('editRoomModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddRoomModal() {
        document.getElementById('addRoomModal').style.display = 'flex';
    }

    function openEditRoomModal() {
        document.getElementById('editRoomModal').style.display = 'flex';
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
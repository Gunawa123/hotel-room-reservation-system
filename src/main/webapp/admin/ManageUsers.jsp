<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modal.User"%>
<%@ page import="utils.UserHandle" %>
<%@ page import="java.util.LinkedList" %>


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


  UserHandle.loadFromFile();
  LinkedList<User> users = UserHandle.getUsers();

%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Hotel Admin - User Management</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="css/manage-users.css">
</head>
<body>
<div class="container">
  <!-- Sidebar Navigation -->
  <nav class="admin-menu">
    <h2>Hotel Admin</h2>
    <a href="<%=request.getContextPath()%>/admin/index.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
    <a href="<%=request.getContextPath()%>/admin/ManageUsers.jsp" class="active"><i class="fas fa-users-cog"></i> User Management</a>
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
      <div>
        <h1>User Management</h1>
      </div>
    </div>

    <div class="toolbar">
      <div class="filter-options">
        <button onclick="openAddUserModal()">
          <i class="fas fa-plus"></i> Add User
        </button>
      </div>
    </div>

    <!-- Users Table -->
    <div class="table-container">
      <table>
        <thead>
        <tr>
          <th>ID</th>
          <th>User</th>
          <th>Contact</th>
          <th>Role</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>

        <%
          for (User user : users) {
            if(user != null) {
        %>
        <tr>
          <td>#<%= user.getUserId() %></td>
          <td>
            <strong><%=user.getFirstName() + " " + user.getLastName()%></strong>
            <div class="text-muted"><%=user.getEmail()%></div>
          </td>
          <td><%=user.getPhoneNumber()%></td>

          <% if (user.isAdmin()) { %>
            <td>Admin</td>
          <% } else { %>
          <td>User</td>
          <% } %>

          <td class="actions">
            <button class="btn btn-edit" onclick="openEditModal(<%=user.getUserId()%>, '<%=user.getFirstName()%>', '<%=user.getLastName()%>', '<%=user.getEmail()%>', '<%=user.getPhoneNumber()%>', '<%=user.getPassword()%>')">
              <i class="fas fa-edit"></i>Edit
            </button>
            <button class="btn btn-delete" onclick="openDeleteModal(<%=user.getUserId()%>, '<%=user.getFirstName()%> <%=user.getLastName()%>')">
              <i class="fas fa-trash"></i>Delete
            </button>
          </td>
        </tr>
        <% }
        } %>
        </tbody>
      </table>
    </div>
  </main>
</div>

<!-- Add User Modal -->
<div id="addUserModal" class="modal">
  <div class="modal-content">
    <div class="modal-header">
      <h2>Add New User</h2>
      <span class="close" onclick="closeAddUserModal()">&times;</span>
    </div>
    <form id="addUserForm" action="../UserServlet" method="POST">
      <input type="hidden" name="action" value="add">
      <div class="form-group">
        <label for="addFirstName">First Name</label>
        <input type="text" id="addFirstName" name="firstName" required>
      </div>
      <div class="form-group">
        <label for="addLastName">Last Name</label>
        <input type="text" id="addLastName" name="lastName" required>
      </div>
      <div class="form-group">
        <label for="addEmail">Email</label>
        <input type="email" id="addEmail" name="email" required>
      </div>
      <div class="form-group">
        <label for="addPhone">Phone Number</label>
        <input type="tel" id="addPhone" name="phoneNumber" required>
      </div>
      <div class="form-group">
        <label for="addPassword">Password</label>
        <input type="password" id="addPassword" name="editPassword" required>
      </div>
      <div class="form-group">
        <label for="addRole">Role</label>
        <select id="addRole" name="role" required>
          <option value="user">User</option>
          <option value="admin">Admin</option>
        </select>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeAddUserModal()">Cancel</button>
        <button type="submit" class="btn btn-primary">Add User</button>
      </div>
    </form>
  </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" class="modal">
  <div class="modal-content">
    <div class="modal-header">
      <h2>Edit User</h2>
      <span class="close" onclick="closeEditModal()">&times;</span>
    </div>
    <form id="editUserForm" action="../UserServlet" method="POST">
      <input type="hidden" id="editUserId" name="userId" value="update">
      <input type="hidden" id="action" name="action" value="update">
      <div class="form-group">
        <label for="editFirstName">First Name</label>
        <input type="text" id="editFirstName" name="firstName" required>
      </div>
      <div class="form-group">
        <label for="editLastName">Last Name</label>
        <input type="text" id="editLastName" name="lastName" required>
      </div>
      <div class="form-group">
        <label for="editEmail">Email</label>
        <input type="email" id="editEmail" name="email" required>
      </div>
      <div class="form-group">
        <label for="editPhone">Phone Number</label>
        <input type="tel" id="editPhone" name="phoneNumber" required>
      </div>
      <div class="form-group">
        <label for="editPassword">Password</label>
        <input type="password" id="editPassword" name="editPassword" required>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>

<!-- Delete User Modal -->
<div id="deleteUserModal" class="modal">
  <div class="modal-content">
    <div class="modal-header">
      <h2>Delete User</h2>
      <span class="close" onclick="closeDeleteModal()">&times;</span>
    </div>
    <form id="deleteUserForm" action="../UserServlet" method="POST">
      <input type="hidden" id="deleteUserId" name="userId">
      <input type="hidden" name="action" value="delete">
      <p>Are you sure you want to delete user <strong id="deleteUserName"></strong>?</p>
      <p class="text-muted">This action cannot be undone.</p>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
        <button type="submit" class="btn btn-danger">Delete</button>
      </div>
    </form>
  </div>
</div>

<script>

  function openAddUserModal() {
    document.getElementById('addUserModal').style.display = 'block';
  }

  function closeAddUserModal() {
    document.getElementById('addUserModal').style.display = 'none';
  }

  // Edit User Modal Functions
  function openEditModal(userId, firstName, lastName, email, phone, password) {
    document.getElementById('editUserId').value = userId;
    document.getElementById('editFirstName').value = firstName;
    document.getElementById('editLastName').value = lastName;
    document.getElementById('editEmail').value = email;
    document.getElementById('editPhone').value = phone;
    document.getElementById('editPassword').value = password;
    document.getElementById('editUserModal').style.display = 'block';
  }

  function closeEditModal() {
    document.getElementById('editUserModal').style.display = 'none';
  }

  // Delete User Modal Functions
  function openDeleteModal(userId, userName) {
    document.getElementById('deleteUserId').value = userId;
    document.getElementById('deleteUserName').textContent = userName;
    document.getElementById('deleteUserModal').style.display = 'block';
  }

  function closeDeleteModal() {
    document.getElementById('deleteUserModal').style.display = 'none';
  }

  // Close modals when clicking outside of them
  window.onclick = function(event) {
    if (event.target.className === 'modal') {
      event.target.style.display = 'none';
    }
  }
</script>
</body>
</html>
package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.Admin;
import modal.User;
import utils.UserHandle;

import java.io.IOException;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("USER");
        String action = request.getParameter("action");
        System.out.println("action: " + action);

        if (action.equals("add")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phoneNumber");
            String password = request.getParameter("editPassword");
            String role = request.getParameter("role");

            if (role.equals("admin")) {
                Admin newAdmin = new Admin(firstName, lastName, email, phone, password);
                UserHandle.addUser(newAdmin);
            }

            if (role.equals("user")) {
                User newUser = new User(firstName, lastName, email, phone, password);
                UserHandle.addUser(newUser);
            }

            response.sendRedirect(request.getContextPath() + "/admin/ManageUsers.jsp");
        }

        if (action.equals("update")) {

            int userId = Integer.parseInt(request.getParameter("userId"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phoneNumber");
            String password = request.getParameter("editPassword");

            UserHandle.updateUser(userId, firstName, lastName, email, phone, password);
            System.out.println(UserHandle.findUserById(userId).getFirstName() + " " + UserHandle.findUserById(userId).getLastName() + " Data Was Updated");

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/ManageUsers.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/Profile.jsp");
            }
        }

        if (action.equals("delete")) {

            int userId = Integer.parseInt(request.getParameter("userId"));
            String role = request.getParameter("role");

            UserHandle.removeUser(UserHandle.findUserById(userId));

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/ManageUsers.jsp");
            } else {
                response.sendRedirect(request.getContextPath());
            }
        }
    }

}

package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.DeluxeRoom;
import modal.StandardRoom;
import utils.RoomHandle;

import java.io.IOException;

    @WebServlet("/RoomServlet")
    public class RoomServlet extends HttpServlet {

        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String roomName = request.getParameter("roomName");
            String roomType = request.getParameter("roomType");
            String roomNumber = request.getParameter("roomNumber");
            double price = Double.parseDouble(request.getParameter("price"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String description = request.getParameter("description");

            String action = request.getParameter("action");
            System.out.println("action: " + action);

            if (action.equals("add")) {
                if (roomType.equals("standard")) {
                    StandardRoom room = new StandardRoom(roomNumber, price, capacity, description);
                    RoomHandle.addRoom(room);
                    System.out.println("Standard Room (" + room.getRoomNumber() + ") added");
                }

                if (roomType.equals("deluxe")) {
                    DeluxeRoom room = new DeluxeRoom(roomNumber, price, capacity, description);
                    RoomHandle.addRoom(room);
                    System.out.println("Deluxe Room (" + room.getRoomNumber() + ") added");
                }

                response.sendRedirect("admin/ManageRooms.jsp");
            }


    }

        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String action = request.getParameter("action");
            System.out.println("action: " + action);
            String roomNumber = request.getParameter("roomNumber");

            if (action.equals("delete")) {
                boolean message = RoomHandle.deleteRoom(roomNumber);

                if (message) {
                    request.setAttribute("message", roomNumber + " has been deleted");
                } else {
                    request.setAttribute("message", roomNumber + " has not been deleted");
                }

                RequestDispatcher rd = request.getRequestDispatcher("admin/ManageRooms.jsp");
                rd.forward(request, response);

            }


        }

}

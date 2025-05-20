package servlets;

import com.sun.net.httpserver.Request;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.Service;
import modal.User;
import utils.ServiceHandle;

import java.io.IOException;

@WebServlet("/ServiceServlet")
public class ServiceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String serviceId = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String serviceDescription = request.getParameter("serviceDescription");
        String serviceStatus = request.getParameter("serviceStatus");
        double servicePrice = Double.parseDouble(request.getParameter("servicePrice"));

        if (action.equals("addService")) {
            Service service = new Service(serviceName, serviceDescription, serviceStatus, servicePrice);
            ServiceHandle.addService(service);

            System.out.println(service.getServiceId() + " Service added");

            response.sendRedirect(request.getContextPath() + "/admin/ManageServices.jsp");

        } else if (action.equals("editService")) {
            ServiceHandle.updateService(serviceId, serviceName, serviceDescription, serviceStatus, servicePrice);
            response.sendRedirect(request.getContextPath() + "/admin/ManageServices.jsp");
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String serviceId = request.getParameter("serviceId");
        Service service_to_delete = ServiceHandle.findServiceById(serviceId);

        if (action.equals("delete")) {
            if (service_to_delete != null) {
                ServiceHandle.removeService(service_to_delete);
                response.sendRedirect(request.getContextPath() + "/admin/ManageServices.jsp");
            }
        }
    }

}

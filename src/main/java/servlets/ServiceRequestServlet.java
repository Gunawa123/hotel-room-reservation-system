package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.Payment;
import modal.Service;
import modal.ServiceRequest;
import modal.User;
import utils.PaymentHandle;
import utils.ServiceRequestHandle;
import utils.ServiceHandle;

import java.io.IOException;

@WebServlet("/ServiceRequestServlet")
public class ServiceRequestServlet extends HttpServlet {

    @Override
    public void init() {

        try {
            ServiceRequestHandle.loadFromFile();
            ServiceHandle.loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("USER");
        Service service = ServiceHandle.findServiceById(request.getParameter("serviceId"));
        String paymentMethod = request.getParameter("paymentMethod");

        if (action.equals("createServiceRequest")) {
            Double paymentAmount = service.getServicePrice();
            Payment payment = new Payment(paymentAmount, paymentMethod, user);
            PaymentHandle.addPayment(payment);

            ServiceRequest serviceRequest = new ServiceRequest(user, service, payment);
            ServiceRequestHandle.addServiceRequest(serviceRequest);
            ServiceRequestHandle.setServiceRequestPaymentStatus(serviceRequest.getServiceRequestId(), "PAID");

            response.sendRedirect(request.getContextPath() + "/MyBookings.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServiceRequest serviceRequest = ServiceRequestHandle.findServiceRequestById(request.getParameter("serviceRequestId"));
        String action = request.getParameter("action");

        if (action.equals("deleteServiceRequest")) {
            ServiceRequestHandle.removeServiceRequest(serviceRequest);
            response.sendRedirect(request.getContextPath() + "/admin/ManageServiceRequests.jsp");
        }
    }
}
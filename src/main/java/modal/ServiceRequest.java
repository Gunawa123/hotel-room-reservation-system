package modal;

import java.time.LocalDate;

public class ServiceRequest {
    private String serviceRequestId;
    private User user;
    private Service service;
    private Payment payment;

    public ServiceRequest(User user, Service service, Payment payment) {
        this.serviceRequestId = null;
        this.user = user;
        this.service = service;
        this.payment = payment;
    }

    public ServiceRequest(String serviceRequestId, User user, Service service, Payment payment) {
        this.serviceRequestId = serviceRequestId;
        this.user = user;
        this.service = service;
        this.payment = payment;
    }

    // Getters and Setters
    public String getServiceRequestId() {
        return serviceRequestId;
    }

    public void setServiceRequestId(String serviceRequestId) {
        this.serviceRequestId = serviceRequestId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public String serviceRequestToString() {
        String paymentId = (payment == null) ? "null" : payment.getPaymentId();

        return serviceRequestId + "|" + user.getUserId() + "|" + service.getServiceId() + "|" + paymentId;
    }
}
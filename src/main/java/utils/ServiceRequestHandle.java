package utils;

import modal.Service;
import modal.ServiceRequest;
import modal.Payment;

import java.io.IOException;
import java.util.LinkedList;

public class ServiceRequestHandle {
    private static LinkedList<ServiceRequest> serviceRequests = new LinkedList<>();
    private static int lastServiceRequestId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String generateServiceRequestId() {
        lastServiceRequestId++;
        return String.format("SR%03d", lastServiceRequestId);
    }

    public static void addServiceRequest(ServiceRequest serviceRequest) throws IOException {
        if (serviceRequest.getServiceRequestId() == null || serviceRequest.getServiceRequestId().equals("")) {
            serviceRequest.setServiceRequestId(generateServiceRequestId());
        }
        serviceRequests.add(serviceRequest);
        saveToFile();
    }

    public static void removeServiceRequest(ServiceRequest serviceRequest) throws IOException {
        serviceRequests.remove(serviceRequest);
        saveToFile();
    }

    public static ServiceRequest findServiceRequestById(String serviceRequestId) throws IOException {
        for (ServiceRequest serviceRequest : serviceRequests) {
            if (serviceRequest.getServiceRequestId().equals(serviceRequestId)) {
                return serviceRequest;
            }
        }
        System.out.println("Service Request not found");
        return null;
    }

    public static LinkedList<ServiceRequest> getServiceRequestsByUser(int userId) throws IOException {
        LinkedList<ServiceRequest> userServices = new LinkedList<>();
        for (ServiceRequest serviceRequest : serviceRequests) {
            if (serviceRequest.getUser().getUserId() == userId) {
                userServices.add(serviceRequest);
            }
        }
        return userServices;
    }

    public static void setServiceRequestPaymentStatus(String serviceRequestId, String status) throws IOException {
        ServiceRequest serviceRequest = findServiceRequestById(serviceRequestId);
        if (serviceRequest != null) {
            serviceRequest.getPayment().setPaymentStatus(status);
            PaymentHandle.saveToFile();
        } else {
            System.out.println("Service Request not found");
        }

        saveToFile();
    }

    public static LinkedList<ServiceRequest> getServiceRequests() {
        return serviceRequests;
    }

    public static void saveToFile() throws IOException {
        DataHandle.serviceRequestsDataSaveToFile(serviceRequests);
        System.out.println("Service Requests saved to file");
    }

    public static void loadFromFile() throws IOException {
        serviceRequests = DataHandle.serviceRequestsDataLoadFromFile();

        for (ServiceRequest serviceRequest : serviceRequests) {
            String idNumStr = serviceRequest.getServiceRequestId().replace("SR", "");
            int idNum = Integer.parseInt(idNumStr);
            lastServiceRequestId = Math.max(lastServiceRequestId, idNum);
        }
        System.out.println("Service Requests loaded");
    }
}
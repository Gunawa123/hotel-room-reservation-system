package utils;

import modal.Service;

import java.io.IOException;
import java.util.LinkedList;

public class ServiceHandle {
    private static LinkedList<Service> services = new LinkedList<>();
    public static int lastServiceId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String generateUserId() {
        lastServiceId++;
        return String.format("SRV%04d", lastServiceId);
    }

    public static LinkedList<Service> getServices() {
        return services;
    }

    public static LinkedList<Service> getActiveServices() {
        LinkedList<Service> activeServices = new LinkedList<>();
        for (Service service : services) {
            if (service.getServiceStatus().equals("active")) {
                activeServices.add(service);
            }
        }
        return activeServices;
    }

    public static void addService(Service service) throws IOException {
        if (service.getServiceId() == null || service.getServiceId().isEmpty()) {
            service.setServiceId(generateUserId());
        }

        services.add(service);
        SaveToFile();
    }

    public static void removeService(Service service) throws IOException {
        services.remove(service);
        SaveToFile();
    }

    public static Service findServiceById(String serviceId) {
        for (Service service : services) {
            if (service.getServiceId().equals(serviceId)) {
                return service;
            }
        }
        System.out.println("Service not found");
        return null;
    }

    public static void updateService(String serviceId, String serviceName, String serviceDescription, String serviceStatus, double servicePrice) throws IOException {
        Service service = findServiceById(serviceId);
        if (service != null) {
            service.setServiceName(serviceName);
            service.setServiceDescription(serviceDescription);
            service.setServiceStatus(serviceStatus);
            service.setServicePrice(servicePrice);

            SaveToFile();
        }
    }

    public static void loadFromFile() throws IOException {
        services = DataHandle.serviceDataLoadFromFile();
        System.out.println("Services loaded");

        for (Service service : services) {
            int idNo = Integer.parseInt(service.getServiceId().replace("SRV", ""));
            lastServiceId = Math.max(idNo, lastServiceId);
        }
    }

    public static void SaveToFile() throws IOException {
        DataHandle.servicesDataSaveToFile(services);
        System.out.println("Services Data saved");
    }

}

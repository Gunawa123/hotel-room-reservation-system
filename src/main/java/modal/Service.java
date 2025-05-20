package modal;

import utils.UserHandle;

public class Service {
    private String serviceId;
    private String serviceName;
    private String serviceType;
    private String serviceDescription;
    private String serviceStatus;
    private double servicePrice;

    public Service() {}

    public Service(String serviceName, String serviceDescription, String serviceStatus, double servicePrice) {
        this.serviceId = null;
        this.serviceName = serviceName;
        this.serviceDescription = serviceDescription;
        this.serviceStatus = serviceStatus;
        this.servicePrice = servicePrice;
    }

    public Service(String serviceId, String serviceName, String serviceDescription, String serviceStatus, double servicePrice) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceDescription = serviceDescription;
        this.serviceStatus = serviceStatus;
        this.servicePrice = servicePrice;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceDescription() {
        return serviceDescription;
    }

    public void setServiceDescription(String serviceDescription) {
        this.serviceDescription = serviceDescription;
    }

    public String getServiceStatus() {
        return serviceStatus;
    }

    public void setServiceStatus(String serviceStatus) {
        this.serviceStatus = serviceStatus;
    }

    public double getServicePrice() {
        return servicePrice;
    }

    public void setServicePrice(double servicePrice) {
        this.servicePrice = servicePrice;
    }

    public String serviceToString() {
        return serviceId + "|" + serviceName + "|" + serviceDescription + "|" + serviceStatus + "|" + servicePrice;
    }

    public static Service fromString(String string) {
        String[] parts = string.split("\\|");

        String serviceId = parts[0];
        String serviceName = parts[1];
        String serviceDescription = parts[2];
        String serviceStatus = parts[3];
        double servicePrice = Double.parseDouble(parts[4]);

        return new Service(serviceId, serviceName, serviceDescription, serviceStatus, servicePrice);
    }

}

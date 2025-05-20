package utils;

import modal.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.LinkedList;

public class DataHandle {
    private static final String basePath = "E:/Projects/Data/";
    private static final String userFilePath = basePath + "users.txt";
    private static final String roomsFilePath = basePath + "rooms.txt";
    private static final String bookingsFilePath = basePath + "bookings.txt";
    private static final String paymentsFilePath = basePath + "payments.txt";
    private static final String servicesFilePath = basePath + "services.txt";
    private static final String reviewsFilePath = basePath + "reviews.txt";
    private static final String serviceRequestsFilePath = basePath + "service-requests.txt";

    static {
        try {
            ensureFileExists(userFilePath);
            ensureFileExists(roomsFilePath);
            ensureFileExists(bookingsFilePath);
            ensureFileExists(paymentsFilePath);
            ensureFileExists(servicesFilePath);
            ensureFileExists(reviewsFilePath);
            ensureFileExists(serviceRequestsFilePath);
            System.out.println("All files are OK");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void ensureFileExists(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        Path parentDir = path.getParent();

        if (parentDir != null && !Files.exists(parentDir)) {
            Files.createDirectories(parentDir);
        }

        if (!Files.exists(path)) {
            Files.createFile(path);
        }
    }

    public static void userDataSaveToFile(LinkedList<User> users) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(userFilePath))) {
            for (User user : users) {
                if (user != null) {
                    writer.write(user.userToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<User> userDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(userFilePath))) {
            LinkedList<User> users = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] data = line.split("\\|");

                    if (data[0].equals("standardUser")) {
                        User user = User.stringToUser(line);
                        users.add(user);
                    }

                    if (data[0].equals("adminUser")) {
                        Admin admin = Admin.stringToUser(line);
                        users.add(admin);
                    }

                } catch (Exception e) {
                    System.err.println("Error parsing user from line: " + line);
                }
            }

            return users;
        }
    }

    public static void saveRoomsToFile(LinkedList<Room> rooms) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(roomsFilePath))) {
            for (Room room : rooms) {
                if (room != null) {
                    writer.write(room.roomToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<Room> roomDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(roomsFilePath))) {
            LinkedList<Room> loadRooms = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] split = line.split("\\|");

                    if (split[0].equals("standard")) {
                        StandardRoom room = new StandardRoom(split[1], Double.parseDouble(split[2]), Integer.parseInt(split[3]), Boolean.parseBoolean(split[4]), split[5]);
                        loadRooms.add(room);
                    }

                    if (split[0].equals("deluxe")) {
                        DeluxeRoom room = new DeluxeRoom(split[1], Double.parseDouble(split[2]), Integer.parseInt(split[3]), Boolean.parseBoolean(split[4]), split[5]);
                        loadRooms.add(room);
                    }

                } catch (Exception e) {
                    System.err.println("Error parsing user from line: " + line);
                }
            }
            return loadRooms;
        }
    }

    public static void bookingsDataSaveToFile(LinkedList<Booking> bookings) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(bookingsFilePath))) {
            for (Booking booking : bookings) {
                if (booking != null) {
                    writer.write(booking.bookingToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<Booking> bookingsDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFilePath))) {
            LinkedList<Booking> loadBookings = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] split = line.split("\\|");

                    String bookingId = split[0];
                    int userId = Integer.parseInt(split[1]);
                    String roomNumber = split[2];
                    String checkInDate = split[3];
                    String checkOutDate = split[4];
                    int numOfDays = Integer.parseInt(split[5]);
                    String paymentId = split[6];
                    String status = split[7];
                    String reviewId = split[8];

                    User user = UserHandle.findUserById(userId);
                    Room room = RoomHandle.findRoomByNumber(roomNumber);
                    Payment payment = null;
                    Review review = null;

                    if (paymentId != null) {
                        payment = PaymentHandle.findPaymentById(paymentId);
                    }

                    if (reviewId != null) {
                        review = ReviewHandle.findReviewById(reviewId);
                    }

                    LocalDate checkIn = LocalDate.parse(checkInDate);
                    LocalDate checkOut = LocalDate.parse(checkOutDate);

                    Booking booking = new Booking(bookingId, user, room, checkIn, checkOut, numOfDays, payment, status, review);

                    loadBookings.add(booking);

                } catch (Exception e) {
                    System.err.println("Error parsing user from line: " + line);
                }
            }
            return loadBookings;
        }
    }

    public static void paymentsDataSaveToFile(LinkedList<Payment> payments) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(paymentsFilePath))) {
            for (Payment payment : payments) {
                if (payment != null) {
                    writer.write(payment.paymentToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<Payment> paymentDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(paymentsFilePath))) {
            LinkedList<Payment> loadPayments = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] split = line.split("\\|");
                    Payment payment = Payment.fromString(line);
                    loadPayments.add(payment);

                } catch (Exception e) {
                    System.err.println("Error parsing user from line: " + line);
                }
            }
            return loadPayments;
        }
    }

    public static void servicesDataSaveToFile(LinkedList<Service> services) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(servicesFilePath))) {
            for (Service service : services) {
                if (service != null) {
                    writer.write(service.serviceToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<Service> serviceDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(servicesFilePath))) {
            LinkedList<Service> loadServices = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {

                    Service service = Service.fromString(line);
                    loadServices.add(service);

                } catch (Exception e) {
                    System.err.println("Error parsing user from line: " + line);
                }
            }
            return loadServices;
        }
    }

    public static void serviceRequestsDataSaveToFile(LinkedList<ServiceRequest> serviceRequests) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(serviceRequestsFilePath))) {
            for (ServiceRequest serviceRequest : serviceRequests) {
                if (serviceRequest != null) {
                    writer.write(serviceRequest.serviceRequestToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<ServiceRequest> serviceRequestsDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(serviceRequestsFilePath))) {
            LinkedList<ServiceRequest> loadServiceRequests = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] split = line.split("\\|");

                    String serviceRequestId = split[0];
                    int userId = Integer.parseInt(split[1]);
                    String serviceId = split[2];
                    String paymentId = split[3];

                    User user = UserHandle.findUserById(userId);
                    Service service = ServiceHandle.findServiceById(serviceId);
                    Payment payment = null;

                    if (!paymentId.equals("null")) {
                        payment = PaymentHandle.findPaymentById(paymentId);
                    }

                    ServiceRequest serviceRequest = new ServiceRequest(serviceRequestId, user, service, payment);
                    loadServiceRequests.add(serviceRequest);
                } catch (Exception e) {
                    System.err.println("Error parsing service request from line: " + line);
                }
            }
            return loadServiceRequests;
        }
    }

    public static void reviewsDataSaveToFile(LinkedList<Review> reviews) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(reviewsFilePath))) {
            for (Review review : reviews) {
                if (review != null) {
                    writer.write(review.reviewToString());
                    writer.newLine();
                }
            }
        }
    }

    public static LinkedList<Review> reviewDataLoadFromFile() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(reviewsFilePath))) {
            LinkedList<Review> loadedReviews = new LinkedList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    Review review = Review.stringToReview(line);
                    loadedReviews.add(review);
                } catch (Exception e) {
                    System.err.println("Error parsing review from line: " + line);
                }
            }
            return loadedReviews;
        }
    }


}
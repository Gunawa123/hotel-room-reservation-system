package utils;

import modal.Payment;

import java.io.*;
import java.util.Date;
import java.util.LinkedList;

public class PaymentHandle {
    private static LinkedList<Payment> payments = new LinkedList<>();
    private static int lastPaymentId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String generatePaymentId() {
        lastPaymentId++;
        return String.format("PAY%04d", lastPaymentId);
    }

    public static LinkedList<Payment> getPayments() {
        return payments;
    }

    public static void addPayment(Payment payment) throws IOException {
        if (payment == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }

        if (payment.getPaymentId() == null || payment.getPaymentId().isEmpty()) {
            payment.setPaymentId(generatePaymentId());
        }

        payments.add(payment);
        saveToFile();
    }

    public static void pay(String paymentId) throws IOException {
        Payment payment = findPaymentById(paymentId);
        if (payment != null) {
            payment.setPaymentStatus("PAID");
        }

        saveToFile();

    }

    public static void removePayment(Payment payment) throws IOException {
        if (payment == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }

        payments.remove(payment);
        saveToFile();
    }

    public static Payment findPaymentById(String paymentId) {
        for (Payment payment : payments) {
            if (payment.getPaymentId().equals(paymentId)) {
                return payment;
            }
        }
        return null;
    }

    public static void updatePaymentDetails(String paymentId, String paymentMethod, String status) throws IOException {
        Payment payment = findPaymentById(paymentId);
        if (payment != null) {
            payment.setPaymentStatus(status);
            payment.setPaymentMethod(paymentMethod);
        }
        saveToFile();
    }

    public static void updatePaymentStatus(String paymentId, String status) throws IOException {
        Payment payment = findPaymentById(paymentId);
        if (payment != null) {
            payment.setPaymentStatus(status);
        }
        saveToFile();
    }

    public static void saveToFile() throws IOException {
        DataHandle.paymentsDataSaveToFile(payments);
        System.out.println("Payments saved to file");
    }

    public static void loadFromFile() throws IOException {
        payments = DataHandle.paymentDataLoadFromFile();
        for (Payment payment : payments) {
            String idNumStr = payment.getPaymentId().replace("PAY", "");
            int idNum = Integer.parseInt(idNumStr);
            lastPaymentId = Math.max(lastPaymentId, idNum);
        }
        System.out.println("Payments loaded");
    }
}

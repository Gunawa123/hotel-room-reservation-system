package utils;

import modal.Booking;
import modal.Payment;
import modal.Review;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedList;

public class BookingHandle {
    private static LinkedList<Booking> bookings = new LinkedList<>();
    private static int lastBookingId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String generateBookingId() {
        lastBookingId++;
        return String.format("BK%03d", lastBookingId);
    }

    public static void addBooking(Booking booking) throws IOException {
        if (booking.getBookingId() == null || booking.getBookingId().equals("")) {
            booking.setBookingId(generateBookingId());
        }
        bookings.add(booking);
        saveToFile();
    }

    public static void removeBooking(Booking booking) throws IOException {
        bookings.remove(booking);
        saveToFile();
    }

    public static void setBookingPayment(String bookingId ,Payment payment) throws IOException {
        Booking booking = findBookingById(bookingId);
        booking.setPayment(payment);
        System.out.println(booking.getBookingId() + " Booking Payment Set to " + booking.getPayment().getPaymentId());
        saveToFile();
    }

    public static void setBookingReview(String bookingId , Review review) throws IOException {
        Booking booking = findBookingById(bookingId);
        booking.setReview(review);
        saveToFile();
    }

    public static Booking findBookingById(String bookingId) throws IOException {
        for (Booking booking : bookings) {
            if (booking.getBookingId().equals(bookingId)) {
                return booking;
            }
        }
        System.out.println("Booking not found");
        return null;
    }

    public static LinkedList<Booking> getBookings() {
        return bookings;
    }

    public static LinkedList<Booking> getBookingsByUserId(int userId) throws IOException {
        LinkedList<Booking> userBookings = new LinkedList<>();
        for (Booking booking : bookings) {
            if (booking.getUser().getUserId() == userId) {
                userBookings.add(booking);
            }
        }
        LinkedList<Booking> sortedBookings = new LinkedList<>(userBookings);
        quickSort(sortedBookings, 0, sortedBookings.size() - 1);
        return sortedBookings;
    }

    public static void saveToFile() throws IOException {
        DataHandle.bookingsDataSaveToFile(bookings);
        System.out.println("Bookings saved to file");
    }

    public static void loadFromFile() throws IOException {
        bookings = DataHandle.bookingsDataLoadFromFile();
        for (Booking booking : bookings) {
            String idNumStr = booking.getBookingId().replace("BK", "");
            int idNum = Integer.parseInt(idNumStr);
            lastBookingId = Math.max(lastBookingId, idNum);
        }

        System.out.println("Bookings loaded");
    }

//    /**
//     * Returns a NEW LinkedList<Booking> sorted by check-in date (ascending).
//     * Original list remains unchanged.
//     */
//    public static LinkedList<Booking> getBookingsSortedByCheckInDate() {
//        if (bookings == null || bookings.isEmpty()) {
//            return new LinkedList<>(); // Return empty list if no bookings
//        }
//
//        // Create a deep copy to avoid modifying the original list
//        LinkedList<Booking> sortedBookings = new LinkedList<>(bookings);
//        quickSort(sortedBookings, 0, sortedBookings.size() - 1);
//        return sortedBookings;
//    }

    public static LinkedList<Booking> SortBookingsByCheckInDate(LinkedList<Booking> unsortedBookings) {
        if (unsortedBookings == null || unsortedBookings.isEmpty()) {
            return new LinkedList<>(); // Return empty list if no bookings
        }

        // Create a deep copy to avoid modifying the original list
        LinkedList<Booking> sortedBookings = new LinkedList<>(unsortedBookings);
        quickSort(sortedBookings, 0, sortedBookings.size() - 1);
        return sortedBookings;
    }

    /**
     * Recursive quicksort implementation for a LinkedList<Booking>.
     * @param list  The list to sort
     * @param low   Starting index
     * @param high  Ending index
     */
    private static void quickSort(LinkedList<Booking> list, int low, int high) {
        if (low < high) {
            int partitionIndex = partition(list, low, high);
            quickSort(list, low, partitionIndex - 1);  // Sort left sublist
            quickSort(list, partitionIndex + 1, high); // Sort right sublist
        }
    }

    /**
     * Partitions the list around a pivot (last element).
     * @param list  The list to partition
     * @param low   Starting index
     * @param high  Ending index
     * @return      The pivot index
     */
    private static int partition(LinkedList<Booking> list, int low, int high) {
        LocalDate pivot = list.get(high).getCheckInDate();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (list.get(j).getCheckInDate().compareTo(pivot) <= 0) {
                i++;
                swap(list, i, j); // Swap if current element is <= pivot
            }
        }
        swap(list, i + 1, high); // Place pivot in correct position
        return i + 1;
    }

    /**
     * Swaps two elements in a LinkedList<Booking>.
     * @param list  The list to modify
     * @param i     Index of the first element
     * @param j     Index of the second element
     */
    private static void swap(LinkedList<Booking> list, int i, int j) {
        Booking temp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, temp);
    }

    public static void setBookingStatus(String bookingId, String status) throws IOException {
        Booking booking = findBookingById(bookingId);
        booking.setStatus(status);
        saveToFile();
    }
}

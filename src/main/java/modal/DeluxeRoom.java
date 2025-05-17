package modal;

public class DeluxeRoom extends Room {
    public DeluxeRoom(String roomNumber, double price, int capacity, String description) {
        super("deluxe", roomNumber, price, capacity, description);
    }

    public DeluxeRoom(String roomNumber, double price, int capacity, boolean isAvailable, String description) {
        super("deluxe", roomNumber, price, capacity, isAvailable, description);
    }

    @Override

    // Deluxe Rooms Cost 20% More
    public double calculatePrice() {
        return super.getPrice() + (super.getPrice() * 0.2);
    }

    public double calculatePrice(double additionalCharges) {
        return calculatePrice() + additionalCharges;
    }

    @Override
    public String roomToString() {
        return "deluxe" + "|" + roomNumber + "|" + price + "|" + capacity + "|" + isAvailable + "|" + description;
    }
}

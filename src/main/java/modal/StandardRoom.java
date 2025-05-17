package modal;

public class StandardRoom extends Room {
    public StandardRoom(String roomNumber, double price, int capacity, String description) {
        super("standard", roomNumber, price, capacity, description);
    }

    public StandardRoom(String roomNumber, double price, int capacity, boolean isAvailable, String description) {
        super("standard", roomNumber, price, capacity, isAvailable, description);
    }

    @Override
    public double calculatePrice() {
        return super.getPrice();
    }

    public double calculatePrice(double additionalCharges) {
        return super.getPrice() + additionalCharges;
    }

    @Override
    public String roomToString() {
        return "standard" + "|" + roomNumber + "|" + price + "|" + capacity + "|" + isAvailable + "|" + description;
    }

}

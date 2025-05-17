package utils;

import modal.DeluxeRoom;
import modal.Room;
import modal.StandardRoom;

import java.io.IOException;
import java.util.LinkedList;

public class RoomHandle {
    private static LinkedList<Room> rooms = new LinkedList<>();
    private static RoomNode root = null;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static LinkedList<Room> getRooms() {
        return rooms;
    }

    // Add a new room
    public static void addRoom(Room room) throws IOException {
        rooms.add(room);
        if (room.isAvailable()) {
            root = insertIntoBST(root, room);
        }
        saveToFile();
    }

    public static Room findRoomByNumber(String roomNumber) throws IOException {
        for (Room room : rooms) {
            if (room.getRoomNumber().equals(roomNumber)) {
                return room;
            }
        }
        System.out.println("Room not found");
        return null;
    }

    // Helper method to insert a room into the BST
    private static RoomNode insertIntoBST(RoomNode node, Room room) {
        if (node == null) {
            return new RoomNode(room);
        }

        int compare = room.getRoomNumber().compareTo(node.room.getRoomNumber());
        if (compare < 0) {
            node.left = insertIntoBST(node.left, room);
        } else if (compare > 0) {
            node.right = insertIntoBST(node.right, room);
        }
        return node;
    }

    // View only available rooms (in-order traversal of BST)
    public static LinkedList<Room> getAvailableRooms() {
        LinkedList<Room> availableRooms = new LinkedList<>();
        inOrderTraversal(root, availableRooms);
        return availableRooms;
    }

    // Helper method for in-order traversal
    private static void inOrderTraversal(RoomNode node, LinkedList<Room> result) {
        if (node != null) {
            inOrderTraversal(node.left, result);
            result.add(node.room);
            inOrderTraversal(node.right, result);
        }
    }

    // Update room details
    public static boolean updateRoom(String roomNumber, double price, boolean isAvailable, String description) throws IOException {
        // Find the room in allRooms
        for (Room room : rooms) {
            if (room.getRoomNumber().equals(roomNumber)) {
                // Update room details
                room.setPrice(price);
                room.setDescription(description);
                // Handle availability change
                if (room.isAvailable() != isAvailable) {
                    room.setAvailable(isAvailable);
                    // Remove from BST if no longer available
                    if (!isAvailable) {
                        root = deleteFromBST(root, roomNumber);
                    } else {
                        // Add to BST if now available
                        root = insertIntoBST(root, room);
                    }
                }
                saveToFile();
                return true;
            }
        }
        return false;
    }

    public static void updateAvailability(String roomNumber, Boolean isAvailable) throws IOException {
        Room room = findRoomByNumber(roomNumber);
        room.setAvailable(isAvailable);
        saveToFile();
    }

    // Delete a room
    public static boolean deleteRoom(String roomNumber) throws IOException {
        // Remove from allRooms
        boolean removed = rooms.removeIf(room -> room.getRoomNumber().equals(roomNumber));
        // Remove from BST if it was available
        if (removed) {
            root = deleteFromBST(root, roomNumber);
            saveToFile();
        }
        return removed;
    }

    // Helper method to delete a room from the BST
    private static RoomNode deleteFromBST(RoomNode node, String roomNumber) {
        if (node == null) {
            return null;
        }
        int compare = roomNumber.compareTo(node.room.getRoomNumber());
        if (compare < 0) {
            node.left = deleteFromBST(node.left, roomNumber);
        } else if (compare > 0) {
            node.right = deleteFromBST(node.right, roomNumber);
        } else {
            // Node to delete found
            if (node.left == null) {
                return node.right;
            } else if (node.right == null) {
                return node.left;
            }
            // Node has two children
            RoomNode minNode = findMin(node.right);
            node.room = minNode.room;
            node.right = deleteFromBST(node.right, minNode.room.getRoomNumber());
        }
        return node;
    }

    // Helper method to find the minimum node in a subtree
    private static RoomNode findMin(RoomNode node) {
        while (node.left != null) {
            node = node.left;
        }
        return node;
    }

    public static void saveToFile() throws IOException {
        DataHandle.saveRoomsToFile(rooms);
        System.out.println("Room Data Saved to file");
    }

    public static void loadFromFile() throws IOException {
        rooms = DataHandle.roomDataLoadFromFile();

        // Rebuild the BST from loaded rooms
        root = null;
        for (Room room : rooms) {
            if (room.isAvailable()) {
                root = insertIntoBST(root, room);
            }
        }

        System.out.println("Room Data Loaded from File");
    }

}

class RoomNode {
    Room room;
    RoomNode left;
    RoomNode right;

    public RoomNode(Room room) {
        this.room = room;
        this.left = null;
        this.right = null;
    }
}


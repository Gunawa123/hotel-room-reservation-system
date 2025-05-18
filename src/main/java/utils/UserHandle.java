package utils;

import modal.User;

import java.io.IOException;
import java.util.LinkedList;

public class UserHandle {
    private static LinkedList<User> users = new LinkedList<>();
    private static int lastUserId = 0;

    static {
        try {
            loadFromFile();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static int generateUserId() {
        lastUserId++;
        return lastUserId;
    }

    public static LinkedList<User> getUsers() {
        return users;
    }

    public static void addUser(User user) throws IOException {
        if (user.getUserId() == -99) {
            user.setUserId(generateUserId());
        }
        users.add(user);
        SaveToFile();
    }

    public static void removeUser(User user) throws IOException {
        users.remove(user);
        SaveToFile();
    }

    public static User findUserById(int userId) {
        for (User user : users) {
            if (user.getUserId() == userId) {
                return user;
            }
        }
        System.out.println("User not found");
        return null;
    }

    public static User findUserByEmail(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        System.out.println("User not found");
        return null;
    }

    public static void updateUser(int userId, String firstName, String lastName, String email, String phoneNumber, String password) throws IOException {
        User user = findUserById(userId);
        if (user != null) {
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhoneNumber(phoneNumber);
            user.setPassword(password);
        }

        SaveToFile();
    }

    public static void loadFromFile() throws IOException {
        users = DataHandle.userDataLoadFromFile();
        System.out.println("Users loaded");

        for (User user : users) {
            lastUserId = Math.max(lastUserId, user.getUserId());
        }


    }

    public static void SaveToFile() throws IOException {
        DataHandle.userDataSaveToFile(users);
        System.out.println("Users Data saved");
    }

}

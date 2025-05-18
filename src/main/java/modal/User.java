package modal;

import java.sql.SQLOutput;
import java.util.UUID;

public class User {
    protected int userId;
    protected String firstName;
    protected String lastName;
    protected String email;
    protected String phoneNumber;
    protected String password;

    public User(String firstName, String lastName, String email, String phoneNumber, String password) {
        this.userId = -99;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
    }

    public User(int userId, String firstName, String lastName, String email, String phoneNumber, String password) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isAdmin() {
        return false;
    }

    public String getRoleDescription() {
        return "Standard User";
    }

    public String userToString() {
        return "standardUser" + "|" + userId + "|" + firstName + "|" + lastName + "|" + email + "|" + phoneNumber + "|" + password;
    }

    public static User stringToUser(String str) {
        String[] strArr = str.split("\\|");
        if (strArr.length == 7) {
            return new User(Integer.parseInt(strArr[1]), strArr[2], strArr[3], strArr[4], strArr[5], strArr[6]);
        } else {
            System.out.println("Invalid user string format");
            return null;
        }
    }
}

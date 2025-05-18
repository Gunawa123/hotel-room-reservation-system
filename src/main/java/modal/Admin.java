package modal;

public class Admin extends User {
    public Admin(String firstName, String lastName, String email, String phoneNumber, String password) {
        super(firstName, lastName, email, phoneNumber, password);
    }

    public Admin(int userId, String firstName, String lastName, String email, String phoneNumber, String password) {
        super(userId, firstName, lastName, email, phoneNumber, password);
    }

    @Override
    public boolean isAdmin() {
        return true;
    }

    @Override
    public String getRoleDescription() {
        return "Administrator";
    }

    @Override
    public String userToString() {
        return "adminUser" + "|" + userId + "|" + firstName + "|" + lastName + "|" + email + "|" + phoneNumber + "|" + password;
    }

    public static Admin stringToUser(String str) {
        String[] strArr = str.split("\\|");
        if (strArr.length == 7) {
            return new Admin(Integer.parseInt(strArr[1]), strArr[2], strArr[3], strArr[4], strArr[5], strArr[6]);
        } else {
            System.out.println("Invalid user string format");
            return null;
        }
    }
}

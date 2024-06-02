package main;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static main.WindowSize.*;

public class DodajKlienta {
    private String firstName;
    private String lastName;
    private long contact;
    private String birthDate;

    public DodajKlienta(String firstName, String lastName, long contact, String birthDate) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.contact = contact;
        this.birthDate = birthDate;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query;
            if (birthDate != null) {
                query = "SELECT wstaw_klienta('" + firstName + "', '" + lastName + "', " + contact + ", '" + birthDate + "')";
            } else {
                query = "SELECT wstaw_klienta('" + firstName + "', '" + lastName + "', " + contact + ", NULL)";
            }            ResultSet resultSet = statement.executeQuery(query);

            boolean result = false;
            if (resultSet.next()) {
                result = resultSet.getBoolean(1);
            }

            // Tworzenie okna i wyświetlanie wiadomości
            JFrame frame = new JFrame("Dodaj klienta");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.setSize(SMALL_WIDTH, SMALL_HEIGHT);
            frame.setLayout(new BorderLayout());
            frame.setLocationRelativeTo(null);
            JLabel messageLabel = new JLabel();
            messageLabel.setHorizontalAlignment(SwingConstants.CENTER);

            if (result) {
                messageLabel.setText("Klient został dodany pomyślnie");
            } else {
                messageLabel.setText("Klient już jest w bazie danych");
            }

            frame.add(messageLabel, BorderLayout.CENTER);
            frame.setVisible(true);

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

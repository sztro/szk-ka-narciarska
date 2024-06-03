package main;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static main.WindowSize.*;

public class UmowDoKonkretnego {
    private int instructorId;
    private String date;
    private int startHour;
    private int endHour;
    private int clientId;
    private int sportId;

    public UmowDoKonkretnego(int instructorId, String date, int startHour, int endHour, int clientId, int sportId) {
        this.instructorId = instructorId;
        this.date = date;
        this.startHour = startHour;
        this.endHour = endHour;
        this.clientId = clientId;
        this.sportId = sportId;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();

            String query = "SELECT umow_konkretny(" + instructorId + ", '" + date + "', " + startHour + ", " + endHour + ", " + clientId + ", " + sportId + ")";

            ResultSet resultSet = statement.executeQuery(query);

            boolean result = false;
            if (resultSet.next()) {
                result = resultSet.getBoolean(1);
            }

            JFrame frame = new JFrame("Umów na lekcję z konkretnym instruktorem");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.setSize(SMALL_WIDTH, SMALL_HEIGHT);
            frame.setLocationRelativeTo(null);
            frame.setLayout(new BorderLayout());

            JLabel messageLabel = new JLabel();
            messageLabel.setHorizontalAlignment(SwingConstants.CENTER);

            if (result) {
                messageLabel.setText("Lekcja została umówiona pomyślnie.");
            } else {
                messageLabel.setText("Niestety nie udało się umówić lekcji.");
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

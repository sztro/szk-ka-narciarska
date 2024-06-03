package main;

import javax.swing.*;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static main.WindowSize.*;
import static main.WindowSize.SMALL_HEIGHT;

public class UmowDoDowolnego {
    private int instructorId;
    private String date;
    private int startHour;
    private int endHour;
    private int clientId;
    private int sportId;

    public UmowDoDowolnego( String date, int startHour, int endHour, int clientId, int sportId) {
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

            String query = "SELECT umow_dowolny(" + clientId + ", '" + date + "', " + startHour + ", " + endHour + ", " + sportId + ")";

            ResultSet resultSet = statement.executeQuery(query);

            String result = "Brak instruktora";
            if (resultSet.next()) {
                result = resultSet.getString(1);
            }

            JFrame frame = new JFrame("Umów na lekcję z konkretnym instruktorem");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.setSize(500, SMALL_HEIGHT);
            frame.setLocationRelativeTo(null);
            frame.setLayout(new BorderLayout());

            JLabel messageLabel = new JLabel();
            messageLabel.setHorizontalAlignment(SwingConstants.CENTER);

            if (result.equals("Brak instruktora")) {
                messageLabel.setText("Niestety nie udało się umówić lekcji. Nie ma w tym terminie dostępnych instruktorów.");
            } else {
                messageLabel.setText("Lekcja została umówiona pomyślnie. Do instruktora: " + result);
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

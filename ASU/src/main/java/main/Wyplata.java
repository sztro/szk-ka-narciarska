package main;

import javax.swing.*;
import java.awt.*;
import java.sql.*;


import static main.WindowSize.SMALL_WIDTH;
import static main.WindowSize.SMALL_HEIGHT;

public class Wyplata {
    private Integer id;
    private String data;

    public Wyplata(int id, String data) {
        this.id = id;
        this.data = data;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;
        int wynik = 0;
        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            String query = "SELECT wyplata(" + id + ", '" + data + "')";
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(query);
            if (resultSet.next()) {
                wynik = resultSet.getInt(1);
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        JFrame frame = new JFrame("Wyświetl wypłatę");
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.setSize(SMALL_WIDTH, SMALL_HEIGHT);
        frame.setLayout(new BorderLayout());
        frame.setLocationRelativeTo(null);
        JLabel messageLabel = new JLabel();
        messageLabel.setHorizontalAlignment(SwingConstants.CENTER);
        messageLabel.setText("Wypłata: " + wynik);
        frame.add(messageLabel, BorderLayout.CENTER);
        frame.setVisible(true);
    }
}

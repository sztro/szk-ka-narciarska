package main;

import javax.swing.*;
import java.awt.*;
import java.sql.*;


import static main.WindowSize.SMALL_WIDTH;
import static main.WindowSize.SMALL_HEIGHT;

public class Nieobecnosc {
    private Integer id;
    private String data;
    private int h_od;
    private int h_do;

    public Nieobecnosc(int id, String data, int h_od, int h_do) {
        this.id = id;
        this.data = data;
        this.h_od = h_od;
        this.h_do = h_do;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;
        boolean wynik = false;
        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            String query = "SELECT dodaj_nieobecnosc(" + id + ", '" + data + "', " + h_od + ", " +  h_do + ")";
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(query);
            if (resultSet.next()) {
                wynik = resultSet.getBoolean(1);
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        JFrame frame = new JFrame("Dodaj nieobecnosć");
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.setSize(SMALL_WIDTH, SMALL_HEIGHT);
        frame.setLayout(new BorderLayout());
        frame.setLocationRelativeTo(null);
        JLabel messageLabel = new JLabel();
        messageLabel.setHorizontalAlignment(SwingConstants.CENTER);
        if (wynik) {
            messageLabel.setText("Dodano nieobecnosć pomyślnie");
        } else {
            messageLabel.setText("Nie można dodać nieobecnosci");
        }
        frame.add(messageLabel, BorderLayout.CENTER);
        frame.setVisible(true);
    }
}


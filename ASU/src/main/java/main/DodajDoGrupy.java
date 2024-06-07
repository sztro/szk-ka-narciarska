package main;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Objects;

import static main.WindowSize.*;

public class DodajDoGrupy {
    private String date;
    private int clientId;
    private int badgeId;

    public DodajDoGrupy(int clientId, String date , int badgeId) {
        this.date = date;
        this.clientId = clientId;
        this.badgeId = badgeId;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();

            String query = "SELECT dodaj_do_grupy(" + clientId + ", " + badgeId + ", '"  + date  +  "' )";

            ResultSet resultSet = statement.executeQuery(query);

            String result = null;
            if (resultSet.next()) {
                result = resultSet.getString(1);
            }

            JFrame frame = new JFrame(result);
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.setSize(300, SMALL_HEIGHT);
            frame.setLocationRelativeTo(null);
            frame.setLayout(new BorderLayout());

            JLabel messageLabel = new JLabel();
            messageLabel.setHorizontalAlignment(SwingConstants.CENTER);
            messageLabel.setText(result);
            if (result.equals("Dodano do poczekani")) {
                Poczekalnia poczekalnia = new Poczekalnia(clientId, date);
                poczekalnia.show();
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
package main;

import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import javax.swing.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static main.WindowSize.CURRENT_DATE;

public class PrzyznajOdznaki {
    public void show() {
        Stage stage = new Stage();
        stage.setTitle("Przyznawanie Odznak");

        Label idKlientaLabel = new Label("ID Klienta:");
        TextField idKlientaField = new TextField();

        Label idOdznakiLabel = new Label("ID Odznaki:");
        TextField idOdznakiField = new TextField();

        Label dataUzyskaniaLabel = new Label("Data Uzyskania:");
        DatePicker dataUzyskaniaPicker = new DatePicker();
        dataUzyskaniaPicker.setValue(CURRENT_DATE);

        Button submitButton = new Button("Przyznaj Odznakę");

        VBox vbox = new VBox(idKlientaLabel, idKlientaField, idOdznakiLabel, idOdznakiField,
                dataUzyskaniaLabel, dataUzyskaniaPicker, submitButton);
        vbox.setSpacing(10);
        vbox.setPadding(new Insets(10));

        Scene scene = new Scene(vbox, 300, 400);
        stage.setScene(scene);
        stage.show();

        submitButton.setOnAction(e -> {
            int idKlienta = Integer.parseInt(idKlientaField.getText());
            int idOdznaki = Integer.parseInt(idOdznakiField.getText());
            String dataUzyskania = dataUzyskaniaPicker.getValue().toString();

            boolean result = nadajOdznake(idKlienta, idOdznaki, dataUzyskania);
//            JLabel messageLabel = new JLabel();
//            messageLabel.setHorizontalAlignment(SwingConstants.CENTER);
            if (result) {
                JOptionPane.showMessageDialog(null, "Odznaka przyznana pomyślnie.");
            } else {
                JOptionPane.showMessageDialog(null, "Niestety, nie udało się przyznać odznaki.");
            }
        });
    }

    private boolean nadajOdznake(int idKlienta, int idOdznaki, String dataUzyskania) {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            String query = "SELECT nadaj_odznake(?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setInt(1, idKlienta);
            statement.setInt(2, idOdznaki);
            statement.setDate(3, java.sql.Date.valueOf(dataUzyskania));

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getBoolean(1);
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}

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
import java.sql.*;
import java.time.LocalDate;

import static main.WindowSize.*;


public class DodajGrupe {
    public void show() {
        Stage stage = new Stage();
        stage.setTitle("Dodaj Grupę");

        Label idInstruktoraLabel = new Label("ID Instruktora:");
        TextField idInstruktoraField = new TextField();

        Label idOdznakiLabel = new Label("ID Odznaki:");
        TextField idOdznakiField = new TextField();

        Label dataRozpoczeciaLabel = new Label("Data Rozpoczęcia:");
        DatePicker dataRozpoczeciaPicker = new DatePicker();
        dataRozpoczeciaPicker.setValue(CURRENT_DATE);

        Label maksDzieciLabel = new Label("Maks. Dzieci:");
        TextField maksDzieciField = new TextField();

        Label minDzieciLabel = new Label("Min. Dzieci:");
        TextField minDzieciField = new TextField();

        Button submitButton = new Button("Dodaj Grupę");

        VBox vbox = new VBox(idInstruktoraLabel, idInstruktoraField, idOdznakiLabel, idOdznakiField,
                dataRozpoczeciaLabel, dataRozpoczeciaPicker, maksDzieciLabel, maksDzieciField, minDzieciLabel, minDzieciField, submitButton);
        vbox.setSpacing(10);
        vbox.setPadding(new Insets(10));

        Scene scene = new Scene(vbox, 300, 400);
        stage.setScene(scene);
        stage.show();

        submitButton.setOnAction(e -> {
            int idInstruktora = Integer.parseInt(idInstruktoraField.getText());
            int idOdznaki = Integer.parseInt(idOdznakiField.getText());
            int maksDzieci = Integer.parseInt(maksDzieciField.getText());
            int minDzieci = Integer.parseInt(minDzieciField.getText());
            String dataRozpoczecia = dataRozpoczeciaPicker.getValue().toString();

            String result = dodajGrupe(idInstruktora, idOdznaki, dataRozpoczecia, maksDzieci, minDzieci);
            JOptionPane.showMessageDialog(null, result);
        });
    }

    private String dodajGrupe(int idInstruktora, int idOdznaki, String dataRozpoczecia, int maksDzieci, int minDzieci) {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT dodaj_grupe(" + idInstruktora + ", " +  idOdznaki + ", '" + dataRozpoczecia + "', " + maksDzieci + ", " + minDzieci + ")";


            ResultSet resultSet = statement.executeQuery(query);
            if (resultSet.next()) {
                return resultSet.getString(1);
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "Wystąpił błąd.";
    }
}
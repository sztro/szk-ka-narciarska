package main;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.time.LocalDate;

public class Menu extends Application {

    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("Menu");

        Button btnHarmonogram = new Button("Harmonogram");
        Button btnDodajKlienta = new Button("Dodaj klienta");
        Button btnUmowNaLekcjeZInstruktorem = new Button("Umów na lekcję z konkretnym instruktorem");
        Button btnUmowNaLekcjeZDowolnymInstruktorem = new Button("Umów na lekcję z dowolnym instruktorem");
        Button btnDodajDoGrupy = new Button("Dodaj do grupy");
        Button btnDodajNieobecnosc = new Button("Dodaj nieobecność godzinową");
        Button btnWyswietlWyplateDzienna = new Button("Wyświetl wypłatę dzienną");

        VBox vbox = new VBox();
        vbox.getChildren().addAll(btnHarmonogram, btnDodajKlienta, btnUmowNaLekcjeZInstruktorem,
                btnUmowNaLekcjeZDowolnymInstruktorem, btnDodajDoGrupy, btnDodajNieobecnosc, btnWyswietlWyplateDzienna);
        vbox.setSpacing(10); // Dodanie odstępów między przyciskami
        vbox.setPadding(new Insets(10)); // Dodanie marginesów do kontenera

        vbox.setAlignment(javafx.geometry.Pos.CENTER); // Wyśrodkowanie przycisków

        Scene scene = new Scene(vbox, 300, 250);
        primaryStage.setScene(scene);
        primaryStage.show();

        // Obsługa zdarzeń dla przycisku "Harmonogram"
        btnHarmonogram.setOnAction(e -> {
            // Tworzenie DatePicker
            DatePicker datePicker = new DatePicker();
            // Obsługa wybrania daty
            datePicker.setOnAction(event -> {
                // Pobranie wybranej daty
                LocalDate selectedDate = datePicker.getValue();
                // Tworzenie obiektu klasy Harmonogram z wybraną datą
                Harmonogram harmonogram = new Harmonogram(selectedDate.toString());
                // Wyświetlenie zawartości harmonogramu w nowym oknie
                harmonogram.show();
            });

            // Tworzenie nowego okna i dodanie DatePicker
            Stage stage = new Stage();
            stage.setTitle("Wybierz datę");
            stage.setScene(new Scene(datePicker, 300, 250));
            stage.show();
        });
    }

    public static void main(String[] args) {
        launch(args);
    }
}
package main;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import javax.swing.*;
import java.time.LocalDate;

public class Menu extends Application {
    private static final double BUTTON_WIDTH = 250; // Stała szerokość dla przycisków

    @Override
    public void start(Stage primaryStage) {

        primaryStage.setTitle("Menu");

        Button btnHarmonogram = new Button("Harmonogram");
        Button btnZnajdzKlienta = new Button("Znajdź ID klienta");
        Button btnZnajdzInstruktora = new Button("Znajdź ID instruktora");
        Button btnWyswietlGrupy = new Button("Wyswietl dostępne grupy");
        Button btnDodajKlienta = new Button("Dodaj klienta");
        Button btnUmowNaLekcjeZInstruktorem = new Button("Umów na lekcję z konkretnym instruktorem");
        Button btnUmowNaLekcjeZDowolnymInstruktorem = new Button("Umów na lekcję z dowolnym instruktorem");
        Button btnDodajDoGrupy = new Button("Dodaj do grupy");
        Button btnDodajGrupe = new Button("Dodaj grupe");
        Button btnDodajNieobecnosc = new Button("Dodaj nieobecność godzinową");
        Button btnWyswietlWyplateDzienna = new Button("Wyświetl wypłatę dzienną");
        Button btnPrzyznajOdznaki = new Button("Przyznawanie odznak");

        Button[] buttons = {btnHarmonogram, btnZnajdzKlienta, btnZnajdzInstruktora, btnWyswietlGrupy,
                btnDodajKlienta, btnUmowNaLekcjeZInstruktorem, btnUmowNaLekcjeZDowolnymInstruktorem,
                btnDodajDoGrupy, btnDodajGrupe, btnDodajNieobecnosc, btnWyswietlWyplateDzienna, btnPrzyznajOdznaki};

        for (Button button : buttons) {
            button.setPrefWidth(BUTTON_WIDTH);
        }

        // Kolumna 1
        VBox col1 = new VBox(btnHarmonogram, btnZnajdzInstruktora, btnDodajNieobecnosc, btnWyswietlWyplateDzienna);
        col1.setSpacing(10);
        col1.setPadding(new Insets(10));
        col1.setAlignment(javafx.geometry.Pos.CENTER);

        // Kolumna 2
        VBox col2 = new VBox(btnZnajdzKlienta, btnDodajKlienta, btnUmowNaLekcjeZInstruktorem, btnUmowNaLekcjeZDowolnymInstruktorem);
        col2.setSpacing(10);
        col2.setPadding(new Insets(10));
        col2.setAlignment(javafx.geometry.Pos.CENTER);

        // Kolumna 3
        VBox col3 = new VBox(btnWyswietlGrupy, btnDodajDoGrupy, btnDodajGrupe, btnPrzyznajOdznaki);
        col3.setSpacing(10);
        col3.setPadding(new Insets(10));
        col3.setAlignment(javafx.geometry.Pos.CENTER);

        // HBox do przechowywania kolumn
        HBox hbox = new HBox(col1, col2, col3);
        hbox.setSpacing(20); // Odstęp między kolumnami
        hbox.setPadding(new Insets(10)); // Marginesy wokół HBox

        Scene scene = new Scene(hbox, 880, 500);
        primaryStage.setScene(scene);
        primaryStage.show();

        // Obsługa zdarzeń dla przycisku "Harmonogram"
        btnHarmonogram.setOnAction(e -> {
            DatePicker datePicker = new DatePicker();

            Button okButton = new Button("OK");

            VBox datePickerVBox = new VBox(datePicker, okButton);
            datePickerVBox.setSpacing(10);
            datePickerVBox.setPadding(new Insets(10));
            datePickerVBox.setAlignment(javafx.geometry.Pos.CENTER);

            Stage dateStage = new Stage();
            dateStage.setTitle("Wybierz datę");
            dateStage.setScene(new Scene(datePickerVBox, 300, 150));
            dateStage.show();

            // Tworzenie nowego okna i dodanie DatePicker
            okButton.setOnAction(event -> {
                // Pobranie wybranej daty
                LocalDate selectedDate = datePicker.getValue();
                if (selectedDate != null) {
                    // Tworzenie obiektu klasy Harmonogram z wybraną datą i oknem menu
                    Harmonogram harmonogram = new Harmonogram(selectedDate.toString());
                    // Wyświetlenie zawartości harmonogramu w nowym oknie
                    harmonogram.show();
                    // Zamknięcie okna wyboru daty
                    dateStage.close();
                } else {
                    // Obsłuż brak wybranej daty (opcjonalne)
                    System.out.println("Brak wybranej daty");
                }
            });
        });
    }

    public static void main(String[] args) {
        launch(args);
    }
}
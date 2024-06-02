package main;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.time.LocalDate;

import static main.WindowSize.WIDTH;
import static main.WindowSize.HEIGHT;

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

        Scene scene = new Scene(hbox, WIDTH, HEIGHT);
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
                LocalDate selectedDate = datePicker.getValue();
                if (selectedDate != null) {
                    Harmonogram harmonogram = new Harmonogram(selectedDate.toString());
                    harmonogram.show();
                    dateStage.close();
                } else {
                    System.out.println("Brak wybranej daty");
                }
            });
        });

        // Obsługa zdarzeń dla przycisku "Znajdz ID Instruktora"
        btnZnajdzInstruktora.setOnAction(e -> {
            TextField textField = new TextField();
            textField.setPromptText("Wpisz imię");
            Button okButton = new Button("Szukaj");
            VBox vBox = new VBox(textField, okButton);
            vBox.setSpacing(10);
            vBox.setPadding(new Insets(10));
            vBox.setAlignment(Pos.CENTER);
            Stage stage = new Stage();
            stage.setTitle("Wpisz imię");
            stage.setScene(new Scene(vBox, 300, 150));
            stage.show();

            // Obsługa przycisku Szukaj
            okButton.setOnAction(event -> {
                String name = textField.getText();
                if (!name.isEmpty()) {
                    ZnajdzInstruktora znajdzInstruktora = new ZnajdzInstruktora(name);
                    znajdzInstruktora.show();
                    stage.close();
                } else {
                    System.out.println("Nie wpisano imienia");
                }
            });
        });

        // Obsługa zdarzeń dla przycisku "Znajdz ID Klienta"
        btnZnajdzKlienta.setOnAction((e) -> {
            TextField firstNameField = new TextField();
            TextField lastNameField = new TextField();
            VBox inputVBox = new VBox(new Node[]{new Label("Imię"), firstNameField, new Label("Nazwisko"), lastNameField});
            inputVBox.setSpacing(10.0);
            inputVBox.setPadding(new Insets(10.0));
            Button searchButton = new Button("Szukaj");
            VBox searchVBox = new VBox(new Node[]{inputVBox, searchButton});
            searchVBox.setSpacing(10.0);
            searchVBox.setPadding(new Insets(10.0));
            searchVBox.setAlignment(Pos.CENTER);
            Stage searchStage = new Stage();
            searchStage.setTitle("Znajdź ID klienta");
            searchStage.setScene(new Scene(searchVBox, 300.0, 200.0));
            searchStage.show();
            searchButton.setOnAction((event) -> {
                String firstName = firstNameField.getText();
                String lastName = lastNameField.getText();
                if (!firstName.isEmpty() && !lastName.isEmpty()) {
                    ZnajdzKlienta findClientID = new ZnajdzKlienta(firstName, lastName);
                    findClientID.show();
                    searchStage.close();
                } else {
                    System.out.println("Proszę podać zarówno imię, jak i nazwisko");
                }

            });
        });
    }

    public static void main(String[] args) {
        launch(args);
    }
}
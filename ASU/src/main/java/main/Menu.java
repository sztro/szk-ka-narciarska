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
import javafx.scene.effect.Blend;
import javafx.scene.effect.BlendMode;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.stage.Stage;

import java.time.LocalDate;

import static main.WindowSize.*;

public class Menu extends Application {
    private static final double BUTTON_WIDTH = 250; // Stała szerokość dla przycisków

    @Override
    public void start(Stage primaryStage) {

        primaryStage.setTitle("Menu");

        Button btnHarmonogram = new Button("Harmonogram");
        Button btnZnajdzKlienta = new Button("Znajdź ID klienta");
        Button btnZnajdzInstruktora = new Button("Znajdź ID instruktora");
        Button btnWyswietlGrupy = new Button("Wyświetl dostępne grupy");
        Button btnDodajKlienta = new Button("Dodaj klienta");
        Button btnUmowNaLekcjeZInstruktorem = new Button("Umów na lekcję z konkretnym instruktorem");
        Button btnUmowNaLekcjeZDowolnymInstruktorem = new Button("Umów na lekcję z dowolnym instruktorem");
        Button btnDodajDoGrupy = new Button("Dodaj do grupy");
        Button btnDodajGrupe = new Button("Dodaj grupe");
        Button btnDodajNieobecnosc = new Button("Dodaj nieobecność godzinową");
        Button btnWyswietlWyplateDzienna = new Button("Wyświetl wypłatę dzienną");
        Button btnPrzyznajOdznaki = new Button("Przyznawanie odznak");
        Button btnWyswietlPoczekalnie = new Button("Wyświetl poczekalnię");

        btnHarmonogram.setFont(new Font(15));
        btnHarmonogram.setPrefWidth(WIDTH-500);

        Button[] buttons = {btnWyswietlPoczekalnie, btnZnajdzKlienta, btnZnajdzInstruktora, btnWyswietlGrupy,
                btnDodajKlienta, btnUmowNaLekcjeZInstruktorem, btnUmowNaLekcjeZDowolnymInstruktorem,
                btnDodajDoGrupy, btnDodajGrupe, btnDodajNieobecnosc, btnWyswietlWyplateDzienna, btnPrzyznajOdznaki};

        for (Button button : buttons) {
            button.setPrefWidth(BUTTON_WIDTH);
        }

        // Kolumna 1
        VBox col1 = new VBox(btnZnajdzKlienta, btnZnajdzInstruktora, btnDodajNieobecnosc, btnWyswietlWyplateDzienna);
        col1.setSpacing(10);
        col1.setPadding(new Insets(10));
        col1.setAlignment(javafx.geometry.Pos.CENTER);

        // Kolumna 2
        VBox col2 = new VBox(btnHarmonogram, btnDodajKlienta, btnUmowNaLekcjeZInstruktorem, btnUmowNaLekcjeZDowolnymInstruktorem, btnPrzyznajOdznaki);
        col2.setSpacing(10);
        col2.setPadding(new Insets(10));
        col2.setAlignment(javafx.geometry.Pos.CENTER);

        // Kolumna 3
        VBox col3 = new VBox(btnWyswietlGrupy, btnDodajDoGrupy, btnDodajGrupe, btnWyswietlPoczekalnie);
        col3.setSpacing(10);
        col3.setPadding(new Insets(10));
        col3.setAlignment(javafx.geometry.Pos.CENTER);

        // HBox do przechowywania kolumn
        HBox hbox = new HBox(col1, col2, col3);
        hbox.setSpacing(20); // Odstęp między kolumnami
        hbox.setPadding(new Insets(10)); // Marginesy wokół HBox

        // Zdjęcie
        ImageView gora = new ImageView("/gora.png");
        gora.setFitWidth(WIDTH);
        gora.setPreserveRatio(true);

        VBox vbox = new VBox(gora, btnHarmonogram, hbox);
        vbox.setAlignment(javafx.geometry.Pos.CENTER);

//        // BorderPane jako główny kontener
//        BorderPane borderPane = new BorderPane();
//        borderPane.setTop(gora);
//        borderPane.setCenter(vbox);
//        borderPane.;

        Scene scene = new Scene(vbox, WIDTH, HEIGHT);
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
            Label label = new Label("Imię");
            VBox input = new VBox(label, textField);
            input.setSpacing(10);
            input.setPadding(new Insets(10));
            VBox vBox = new VBox(input, okButton);
            vBox.setAlignment(Pos.CENTER);
            Stage stage = new Stage();
            stage.setTitle("Znajdz Instruktora");
            stage.setScene(new Scene(vBox, 300, 150));
            stage.show();
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

        // Obsługa zdarzeń dla przycisku "Dodaj klienta"
        btnDodajKlienta.setOnAction(e -> {
            TextField firstNameField = new TextField();
            TextField lastNameField = new TextField();
            TextField contactField = new TextField();
            DatePicker birthDatePicker = new DatePicker();

            VBox inputVBox = new VBox(new javafx.scene.control.Label("Imię"), firstNameField,
                    new javafx.scene.control.Label("Nazwisko"), lastNameField,
                    new javafx.scene.control.Label("Kontakt"), contactField,
                    new javafx.scene.control.Label("Data urodzenia"), birthDatePicker);
            inputVBox.setSpacing(10);
            inputVBox.setPadding(new Insets(10));

            Button addButton = new Button("Dodaj");

            VBox addVBox = new VBox(inputVBox, addButton);
            addVBox.setSpacing(10);
            addVBox.setPadding(new Insets(10));
            addVBox.setAlignment(javafx.geometry.Pos.CENTER);

            Stage addStage = new Stage();
            addStage.setTitle("Dodaj klienta");
            addStage.setScene(new Scene(addVBox, 300, 300));
            addStage.show();

            addButton.setOnAction(event -> {
                String firstName = firstNameField.getText();
                String lastName = lastNameField.getText();
                String contact = contactField.getText();
                LocalDate birthDate = birthDatePicker.getValue();
                if (!firstName.isEmpty() && !lastName.isEmpty() && !contact.isEmpty()) {
                    long contactNumber;
                    try {
                        contactNumber = Long.parseLong(contact);
                        String birthDateString = (birthDate != null) ? birthDate.toString() : null;
                        DodajKlienta addClient = new DodajKlienta(firstName, lastName, contactNumber, birthDateString);
                        addClient.show();
                        addStage.close();
                    } catch (NumberFormatException ex) {
                        System.out.println("Nieprawidłowy format numeru kontaktowego");
                    }
                } else {
                    System.out.println("Proszę wypełnić wszystkie pola z wyjątkiem daty urodzenia, jeśli nie jest dostępna");
                }
            });
        });


        // Obsługa zdarzeń dla przycisku "Wyplata"
        btnWyswietlWyplateDzienna.setOnAction(e -> {
            TextField idField = new TextField();
            DatePicker datePicker = new DatePicker();
            VBox inputVBox = new VBox(
                    new Label("ID Instruktora"),
                    idField,
                    new Label("Data"),
                    datePicker
            );
            inputVBox.setSpacing(10);
            inputVBox.setPadding(new Insets(10));
            Button addButton = new Button("Pokaż");
            VBox addVBox = new VBox(inputVBox, addButton);
            addVBox.setSpacing(10);
            addVBox.setPadding(new Insets(10));
            addVBox.setAlignment(Pos.CENTER);
            Stage addStage = new Stage();
            addStage.setTitle("Wyświetl wypłatę");
            addStage.setScene(new Scene(addVBox, 300, 200));
            addStage.show();
            addButton.setOnAction(event -> {
                String idText = idField.getText();
                LocalDate selectedDate = datePicker.getValue();
                if (!idText.isEmpty() && selectedDate != null) {
                    try {
                        int id = Integer.parseInt(idText);
                        Wyplata wyplata = new Wyplata(id, selectedDate.toString());
                        wyplata.show();
                        addStage.close();
                    } catch (NumberFormatException ex) {
                        System.out.println("Nieprawidłowy format ID");
                    }
                } else {
                    System.out.println("Proszę wypełnić wszystkie pola.");
                }
            });
        });

        // Obsługa zdarzeń dla przycisku "Umów na lekcję z konkretnym instruktorem"
        btnUmowNaLekcjeZInstruktorem.setOnAction(e -> {
            // Tworzenie pól tekstowych i innych kontrolek potrzebnych do wprowadzenia danych
            TextField instructorIdField = new TextField();
            DatePicker datePicker = new DatePicker();
            TextField startHourField = new TextField();
            TextField endHourField = new TextField();
            TextField clientIdField = new TextField();
            TextField sportIdField = new TextField();

            // Tworzenie VBox do ułożenia kontrolek
            VBox inputVBox = new VBox(
                    new Label("ID instruktora"), instructorIdField,
                    new Label("Data lekcji"), datePicker,
                    new Label("Godzina rozpoczęcia"), startHourField,
                    new Label("Godzina zakończenia"), endHourField,
                    new Label("ID klienta"), clientIdField,
                    new Label("ID sportu"), sportIdField
            );
            inputVBox.setSpacing(10);
            inputVBox.setPadding(new Insets(10));

            // Tworzenie przycisku do potwierdzenia danych
            Button confirmButton = new Button("Potwierdź");

            // Tworzenie VBox do ułożenia VBox z polami tekstowymi i przyciskiem
            VBox confirmVBox = new VBox(inputVBox, confirmButton);
            confirmVBox.setSpacing(10);
            confirmVBox.setPadding(new Insets(10));
            confirmVBox.setAlignment(Pos.CENTER);

            // Tworzenie nowego okna dialogowego
            Stage confirmStage = new Stage();
            confirmStage.setTitle("Umów na lekcję z konkretnym instruktorem");
            confirmStage.setScene(new Scene(confirmVBox, 400, 500));
            confirmStage.show();

            // Obsługa zdarzenia po kliknięciu przycisku "Potwierdź"
            confirmButton.setOnAction(event -> {
                // Pobranie danych wprowadzonych przez użytkownika
                int instructorId = Integer.parseInt(instructorIdField.getText());
                LocalDate selectedDate = datePicker.getValue();
                int startHour = Integer.parseInt(startHourField.getText());
                int endHour = Integer.parseInt(endHourField.getText());
                int clientId = Integer.parseInt(clientIdField.getText());
                int sportId = Integer.parseInt(sportIdField.getText());

                // Wywołanie funkcji do umówienia lekcji z konkretnym instruktorem
                UmowDoKonkretnego scheduleLesson = new UmowDoKonkretnego(instructorId, selectedDate.toString(), startHour, endHour, clientId, sportId);
                scheduleLesson.show();

                // Zamknięcie okna dialogowego
                confirmStage.close();
            });
        });

        // Obsługa zdarzeń dla przycisku "Dodaj nieobecnosc"
        btnDodajNieobecnosc.setOnAction(e -> {
            TextField idField = new TextField();
            DatePicker datePicker = new DatePicker();
            TextField godzinaRozpoczeciaField = new TextField();
            TextField godzinaZakonczeniaField = new TextField();

            VBox inputVBox = new VBox(
                    new Label("ID Instruktora"),
                    idField,
                    new Label("Data"),
                    datePicker,
                    new Label("Godzina rozpoczęcia"),
                    godzinaRozpoczeciaField,
                    new Label("Godzina zakończenia"),
                    godzinaZakonczeniaField
            );
            inputVBox.setSpacing(10);
            inputVBox.setPadding(new Insets(10));

            Button addButton = new Button("Zatwierdź");
            VBox addVBox = new VBox(inputVBox, addButton);
            addVBox.setSpacing(10);
            addVBox.setPadding(new Insets(10));
            addVBox.setAlignment(Pos.CENTER);

            Stage addStage = new Stage();
            addStage.setTitle("Dodaj nieobecność");
            addStage.setScene(new Scene(addVBox, 300, 300));
            addStage.show();

            addButton.setOnAction(event -> {
                String idText = idField.getText();
                LocalDate selectedDate = datePicker.getValue();
                String godzinaRozpoczeciaText = godzinaRozpoczeciaField.getText();
                String godzinaZakonczeniaText = godzinaZakonczeniaField.getText();

                if (!idText.isEmpty() && selectedDate != null && !godzinaRozpoczeciaText.isEmpty() && !godzinaZakonczeniaText.isEmpty()) {
                    try {
                        int id = Integer.parseInt(idText);
                        int godzinaRozpoczecia = Integer.parseInt(godzinaRozpoczeciaText);
                        int godzinaZakonczenia = Integer.parseInt(godzinaZakonczeniaText);

                        Nieobecnosc nieobecnosc = new Nieobecnosc(id, selectedDate.toString(), godzinaRozpoczecia, godzinaZakonczenia);
                        nieobecnosc.show();
                        addStage.close();
                    } catch (NumberFormatException ex) {
                        System.out.println("Nieprawidłowy format ID lub godziny");
                    }
                } else {
                    System.out.println("Proszę wypełnić wszystkie pola.");
                }
            });
        });

        // Obsługa zdarzeń dla przycisku "Umow z dowolnym"
        btnUmowNaLekcjeZDowolnymInstruktorem.setOnAction(e -> {
            // Tworzenie pól tekstowych i innych kontrolek potrzebnych do wprowadzenia danych
            DatePicker datePicker = new DatePicker();
            TextField startHourField = new TextField();
            TextField endHourField = new TextField();
            TextField clientIdField = new TextField();
            TextField sportIdField = new TextField();

            // Tworzenie VBox do ułożenia kontrolek
            VBox inputVBox = new VBox(
                    new Label("Data lekcji"), datePicker,
                    new Label("Godzina rozpoczęcia"), startHourField,
                    new Label("Godzina zakończenia"), endHourField,
                    new Label("ID klienta"), clientIdField,
                    new Label("ID sportu"), sportIdField
            );
            inputVBox.setSpacing(10);
            inputVBox.setPadding(new Insets(10));

            // Tworzenie przycisku do potwierdzenia danych
            Button confirmButton = new Button("Potwierdź");

            // Tworzenie VBox do ułożenia VBox z polami tekstowymi i przyciskiem
            VBox confirmVBox = new VBox(inputVBox, confirmButton);
            confirmVBox.setSpacing(10);
            confirmVBox.setPadding(new Insets(10));
            confirmVBox.setAlignment(Pos.CENTER);

            // Tworzenie nowego okna dialogowego
            Stage confirmStage = new Stage();
            confirmStage.setTitle("Umów na lekcję z konkretnym instruktorem");
            confirmStage.setScene(new Scene(confirmVBox, 400, 500));
            confirmStage.show();

            // Obsługa zdarzenia po kliknięciu przycisku "Potwierdź"
            confirmButton.setOnAction(event -> {
                // Pobranie danych wprowadzonych przez użytkownika
                LocalDate selectedDate = datePicker.getValue();
                int startHour = Integer.parseInt(startHourField.getText());
                int endHour = Integer.parseInt(endHourField.getText());
                int clientId = Integer.parseInt(clientIdField.getText());
                int sportId = Integer.parseInt(sportIdField.getText());

                // Wywołanie funkcji do umówienia lekcji z konkretnym instruktorem
                UmowDoDowolnego scheduleLesson = new UmowDoDowolnego(selectedDate.toString(), startHour, endHour, clientId, sportId);
                scheduleLesson.show();

                // Zamknięcie okna dialogowego
                confirmStage.close();
            });
        });

        // Obsługa zdarzeń dla przycisku "Wyswietl dostepne grupy"
        btnWyswietlGrupy.setOnAction(e -> {
            DatePicker datePicker = new DatePicker();
            Button okButton = new Button("OK");

            VBox datePickerVBox = new VBox(datePicker, okButton);
            datePickerVBox.setSpacing(10);
            datePickerVBox.setPadding(new Insets(10));
            datePickerVBox.setAlignment(Pos.CENTER);

            Stage dateStage = new Stage();
            dateStage.setTitle("Wybierz datę");
            dateStage.setScene(new Scene(datePickerVBox, SMALL_WIDTH, SMALL_HEIGHT));
            dateStage.show();

            okButton.setOnAction(event -> {
                LocalDate selectedDate = datePicker.getValue();
                if (selectedDate != null) {
                    WyswietlGrupy availableGroups = new WyswietlGrupy(selectedDate.toString());
                    availableGroups.show();
                    dateStage.close();
                } else {
                    System.out.println("Brak wybranej daty");
                }
            });
        });

        // Obsługa zdarzeń dla przycisku "Dodaj do grupy"
        btnDodajDoGrupy.setOnAction(e -> {

        });

        // Obsługa zdarzeń dla przycisku "Dodaj grupe"
        btnDodajGrupe.setOnAction(e -> {

        });

        // Obsługa zdarzeń dla przycisku "Przyzawanie odznak"
        btnPrzyznajOdznaki.setOnAction(e -> {

        });
    }

    public static void main(String[] args) {
        launch(args);
    }
}
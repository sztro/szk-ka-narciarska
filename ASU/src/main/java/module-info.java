module ASU {
    requires java.desktop;
    requires java.sql;
    requires javafx.graphics;
    requires javafx.controls;

    opens main to javafx.graphics;
}
module ASU {
    requires java.desktop;
    requires java.sql;
    requires javafx.graphics;
    requires javafx.controls;
    requires org.postgresql.jdbc;

    opens main to javafx.graphics;
}
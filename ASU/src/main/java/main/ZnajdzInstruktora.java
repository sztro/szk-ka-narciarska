package main;

import javax.swing.*;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


import static main.WindowSize.WIDTH;
import static main.WindowSize.HIGH;

public class ZnajdzInstruktora {
    private String imie;
    public ZnajdzInstruktora(String imie) {
        this.imie = imie;
    }
    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM znajdz_instruktora('" + imie + "')";
            ResultSet resultSet = statement.executeQuery(query);

            // Pobranie metadanych kolumn
            int columnCount = resultSet.getMetaData().getColumnCount();
            String[] columnNames = new String[columnCount];
            for (int i = 1; i <= columnCount; i++) {
                columnNames[i - 1] = resultSet.getMetaData().getColumnName(i);
            }

            // Pobranie danych
            NonEditableTableModel tableModel = new NonEditableTableModel(columnNames, 0);
            while (resultSet.next()) {
                String[] rowData = new String[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    rowData[i - 1] = resultSet.getString(i);
                }
                tableModel.addRow(rowData);
            }

            // Tworzenie JTable
            JTable table = new JTable(tableModel);
            JScrollPane scrollPane = new JScrollPane(table);

            // Ustawienie szerokości pierwszej kolumny na szerokość najszerszego tekstu
            TableColumn column = table.getColumnModel().getColumn(0);
            int preferredWidth = 0;
            for (int row = 0; row < table.getRowCount(); row++) {
                TableCellRenderer cellRenderer = table.getCellRenderer(row, 0);
                Component c = table.prepareRenderer(cellRenderer, row, 0);
                preferredWidth = Math.max(c.getPreferredSize().width, preferredWidth);
            }
            column.setPreferredWidth(preferredWidth + 10); // Dodajemy 10 pikseli, aby zachować odstęp


            // Ustawienie niestandardowego renderera dla wszystkich kolumn
            CustomCellRenderer renderer = new CustomCellRenderer();
            for (int i = 1; i < table.getColumnCount(); i++) {
                table.getColumnModel().getColumn(i).setCellRenderer(renderer);
            }

            // Tworzenie okna i dodanie tabeli
            JFrame frame = new JFrame("Znajdz Instruktora");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.add(scrollPane);
            frame.setSize(WIDTH, HIGH);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
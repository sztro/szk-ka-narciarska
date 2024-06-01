package main;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

class CustomCellRenderer extends DefaultTableCellRenderer {
    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,
                                                   boolean hasFocus, int row, int column) {
        Component c = super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);

        if (value == null) {
            c.setBackground(Color.WHITE);
            c.setForeground(Color.BLACK);
        } else if ("nieobecność".equals(value)) {
            c.setBackground(Color.decode("#6077A1"));
            c.setForeground(Color.BLACK);
        } else {
            c.setBackground(Color.decode("#8EB1ED"));
            c.setForeground(Color.BLACK);
        }

        return c;
    }
}

public class Harmonogram {
    private String data;
    public Harmonogram(String data) {
        this.data = data;
    }
    public void show() {
        String url = "jdbc:postgresql://localhost:5432/szkolka";
        String user = "ula";
        String password = "ula";

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM wyswietl_harmonogram('" + data + "')";
            ResultSet resultSet = statement.executeQuery(query);

            // Pobranie metadanych kolumn
            int columnCount = resultSet.getMetaData().getColumnCount();
            String[] columnNames = new String[columnCount];
            for (int i = 1; i <= columnCount; i++) {
                columnNames[i - 1] = resultSet.getMetaData().getColumnName(i);
            }

            // Pobranie danych
            DefaultTableModel tableModel = new DefaultTableModel(columnNames, 0);
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

            // Ustawienie niestandardowego renderera dla wszystkich kolumn
            CustomCellRenderer renderer = new CustomCellRenderer();
            for (int i = 1; i < table.getColumnCount(); i++) {
                table.getColumnModel().getColumn(i).setCellRenderer(renderer);
            }

            // Tworzenie okna i dodanie tabeli
            JFrame frame = new JFrame("PostgreSQL Table");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add(scrollPane);
            frame.setSize(800, 600);
            frame.setVisible(true);

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
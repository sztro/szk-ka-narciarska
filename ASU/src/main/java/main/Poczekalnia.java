package main;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import static main.WindowSize.*;

public class Poczekalnia {
    Integer id;
    String dzien;
    Poczekalnia(Integer id_odz,String dzien) {
        this.id = id_odz;
        this.dzien = dzien;
    }
    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM wyswietl_poczekalnie(" + id.toString() + ", '" + dzien + "')";
            ResultSet resultSet = statement.executeQuery(query);

            int columnCount = resultSet.getMetaData().getColumnCount();
            String[] columnNames = new String[columnCount];
            for (int i = 1; i <= columnCount; i++) {
                columnNames[i - 1] = resultSet.getMetaData().getColumnName(i);
            }

            NonEditableTableModel tableModel = new NonEditableTableModel(columnNames, 0);
            List<String> groupKeys = new ArrayList<>();
            while (resultSet.next()) {
                String[] rowData = new String[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    rowData[i - 1] = resultSet.getString(i);
                }
                tableModel.addRow(rowData);

                // Create group key based on date and badge
                String groupKey = rowData[1] + rowData[2];
                if (!groupKeys.contains(groupKey)) {
                    groupKeys.add(groupKey);
                }
            }

            JTable table = new JTable(tableModel);
            table.setDefaultRenderer(Object.class, new CustomTableCellRenderer(groupKeys));
            JScrollPane scrollPane = new JScrollPane(table);

            TableColumn column = table.getColumnModel().getColumn(0);
            int preferredWidth = 0;
            for (int row = 0; row < table.getRowCount(); row++) {
                TableCellRenderer cellRenderer = table.getCellRenderer(row, 0);
                Component c = table.prepareRenderer(cellRenderer, row, 0);
                preferredWidth = Math.max(c.getPreferredSize().width, preferredWidth);
            }
            column.setPreferredWidth(preferredWidth + 10);

            JFrame frame = new JFrame("Poczekalnia");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.add(scrollPane);
            frame.setSize(WIDTH, HEIGHT);
            frame.setVisible(true);
            frame.setLocationRelativeTo(null);

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static class CustomTableCellRenderer extends DefaultTableCellRenderer {
        private final List<String> groupKeys;

        public CustomTableCellRenderer(List<String> groupKeys) {
            this.groupKeys = groupKeys;
        }

        @Override
        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
            Component c = super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);

            String groupKey = table.getValueAt(row, 1).toString() + table.getValueAt(row, 2).toString();
            int groupIndex = groupKeys.indexOf(groupKey);

            if (groupIndex % 2 == 0) {
                c.setBackground(Color.decode("#E2E2E2"));
            } else {
                c.setBackground(Color.WHITE);
            }

            if (isSelected) {
                c.setBackground(table.getSelectionBackground());
            }

            return c;
        }
    }
}

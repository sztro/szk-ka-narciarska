package main;

import javax.swing.*;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static main.WindowSize.HEIGHT;
import static main.WindowSize.WIDTH;

public class DzieciGrupy {
    private int grupa;
    public DzieciGrupy(int grupa) {
        this.grupa = grupa;
    }
    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM wyswietl_dzieci_grupy(" + grupa + ")";
            ResultSet resultSet = statement.executeQuery(query);

            int columnCount = resultSet.getMetaData().getColumnCount();
            String[] columnNames = new String[columnCount];
            for (int i = 1; i <= columnCount; i++) {
                columnNames[i - 1] = resultSet.getMetaData().getColumnName(i);
            }

            NonEditableTableModel tableModel = new NonEditableTableModel(columnNames, 0);
            while (resultSet.next()) {
                String[] rowData = new String[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    rowData[i - 1] = resultSet.getString(i);
                }
                tableModel.addRow(rowData);
            }

            JTable table = new JTable(tableModel);
            JScrollPane scrollPane = new JScrollPane(table);

            TableColumn column = table.getColumnModel().getColumn(0);
            int preferredWidth = 0;
            for (int row = 0; row < table.getRowCount(); row++) {
                TableCellRenderer cellRenderer = table.getCellRenderer(row, 0);
                Component c = table.prepareRenderer(cellRenderer, row, 0);
                preferredWidth = Math.max(c.getPreferredSize().width, preferredWidth);
            }
            column.setPreferredWidth(preferredWidth + 10);

            JFrame frame = new JFrame("Grupa");
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.add(scrollPane);
            frame.setSize(WIDTH, HEIGHT);
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
package main;
import java.awt.Component;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;

import static main.WindowSize.WIDTH;
import static main.WindowSize.HEIGHT;


public class ZnajdzKlienta {
    private String firstName;
    private String lastName;

    public ZnajdzKlienta(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM id_klienta('" + this.firstName + "', '" + this.lastName + "')";
            ResultSet resultSet = statement.executeQuery(query);
            int columnCount = resultSet.getMetaData().getColumnCount();
            String[] columnNames = new String[columnCount];

            for(int i = 1; i <= columnCount; ++i) {
                columnNames[i - 1] = resultSet.getMetaData().getColumnName(i);
            }

            NonEditableTableModel tableModel = new NonEditableTableModel(columnNames, 0);

            while(resultSet.next()) {
                String[] rowData = new String[columnCount];

                for(int i = 1; i <= columnCount; ++i) {
                    rowData[i - 1] = resultSet.getString(i);
                }

                tableModel.addRow(rowData);
            }

            JTable table = new JTable(tableModel);
            JScrollPane scrollPane = new JScrollPane(table);
            TableColumn column = table.getColumnModel().getColumn(0);
            int preferredWidth = 0;

            for(int row = 0; row < table.getRowCount(); ++row) {
                TableCellRenderer cellRenderer = table.getCellRenderer(row, 0);
                Component c = table.prepareRenderer(cellRenderer, row, 0);
                preferredWidth = Math.max(c.getPreferredSize().width, preferredWidth);
            }

            column.setPreferredWidth(preferredWidth + 10);
            CustomCellRenderer renderer = new CustomCellRenderer();

            for(int i = 1; i < table.getColumnCount(); ++i) {
                table.getColumnModel().getColumn(i).setCellRenderer(renderer);
            }

            JFrame frame = new JFrame("ID Klienta");
            frame.setDefaultCloseOperation(2);
            frame.add(scrollPane);
            frame.setSize(WIDTH, HEIGHT);
            frame.setVisible(true);
            frame.setLocationRelativeTo((Component)null);
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception var18) {
            Exception e = var18;
            e.printStackTrace();
        }

    }
}

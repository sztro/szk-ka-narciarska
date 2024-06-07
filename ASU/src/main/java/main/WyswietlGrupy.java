package main;

import javax.swing.*;
import javax.swing.event.MouseInputAdapter;
import javax.swing.table.TableColumn;
import javax.swing.table.TableColumnModel;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static main.WindowSize.*;

public class WyswietlGrupy {

    private String date;

    public WyswietlGrupy(String date) {
        this.date = date;
    }

    public void show() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;

        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM wyswietl_grupy('" + date + "')";
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

            TableColumnModel columnModel = table.getColumnModel();
            TableColumn firstColumn = columnModel.getColumn(0);
            firstColumn.setMaxWidth(22);

            table.addMouseListener(new MouseInputAdapter() {
                @Override
                public void mouseClicked(MouseEvent e) {
                    if (e.getClickCount() == 1) {
                        JTable target = (JTable) e.getSource();
                        int row = target.getSelectedRow();
                        String stringValue = (String) table.getValueAt(row, 0);
                        int value = Integer.parseInt(stringValue);
                        DzieciGrupy addgroup = new DzieciGrupy(value);
                        addgroup.show();
//                        JOptionPane.showMessageDialog(null, "Wartość z pierwszej kolumny: " + value);
                    }
                }
            });

            JLabel messageLabel = new JLabel("Kliknij w grupę, aby wyświetlić listę dzieci", JLabel.CENTER);
            messageLabel.setFont(new Font("Roboto", Font.PLAIN, 16));
            messageLabel.setBorder(BorderFactory.createEmptyBorder(10, 0, 10, 0));

            JFrame frame = new JFrame("Dostępne grupy od daty: " + date);
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
            frame.setSize(WIDTH, HEIGHT);
            frame.setLayout(new BorderLayout());
            frame.setLocationRelativeTo(null);
            frame.add(messageLabel, BorderLayout.NORTH); // Add the label to the north region of the border layout
            frame.add(scrollPane, BorderLayout.CENTER);
            frame.setVisible(true);

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

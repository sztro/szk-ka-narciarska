package main;

import javax.swing.*;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.*;
import java.time.LocalDate;

public class Harmonogram {
    private LocalDate data;
    private JFrame frame;

    public Harmonogram(String data) {
        this.data = LocalDate.parse(data);
    }

    public void show() {
        frame = new JFrame("Harmonogram               " + data.toString());
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
        frame.setSize(800, 600);
        updateHarmonogram();
        frame.setVisible(true);
    }

    private void updateHarmonogram() {
        String url = User.URL;
        String user = User.USERNAME;
        String password = User.PASSWORD;
        frame.setTitle("Harmonogram               " + data.toString());
        try {
            Connection connection = DriverManager.getConnection(url, user, password);
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM wyswietl_harmonogram('" + data.toString() + "')";
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

            table.addMouseListener(new MouseAdapter() {
                public void mouseClicked(MouseEvent e) {
                    if (e.getClickCount() == 2) {
                        JTable target = (JTable)e.getSource();
                        int row = target.getSelectedRow();
                        int column = target.getSelectedColumn();
                        Object value = target.getValueAt(row, column);

                        if (value != null && !value.toString().isEmpty()) {
                            String message = "Usunąć zajęcia?";
                            if ("nieobecność".equalsIgnoreCase(value.toString())) {
                                message = "Usunąć nieobecność?";
                            }
                            int response = JOptionPane.showConfirmDialog(frame, message, "Potwierdzenie", JOptionPane.YES_NO_OPTION);
                            if (response == JOptionPane.YES_OPTION) {
                                Object firstColumnValue = target.getValueAt(row, 0);
                                String godzina = target.getColumnName(column);
                                int index = firstColumnValue.toString().indexOf('.');
                                String id = firstColumnValue.toString().substring(0, index);
                                String query = "SELECT usun_zajecia(" + id + ", '" + data.toString() + "', " + godzina + ");";
                                System.out.println(query);
                                try {
                                    ResultSet resultSet = statement.executeQuery(query);
                                } catch (SQLException ex) {
                                    throw new RuntimeException(ex);
                                }
                            }
                        }
                    }
                }
            });

            TableColumn column = table.getColumnModel().getColumn(0);
            int preferredWidth = 0;
            for (int row = 0; row < table.getRowCount(); row++) {
                TableCellRenderer cellRenderer = table.getCellRenderer(row, 0);
                Component c = table.prepareRenderer(cellRenderer, row, 0);
                preferredWidth = Math.max(c.getPreferredSize().width, preferredWidth);
            }
            column.setPreferredWidth(preferredWidth + 10);

            CustomCellRenderer renderer = new CustomCellRenderer();
            for (int i = 1; i < table.getColumnCount(); i++) {
                table.getColumnModel().getColumn(i).setCellRenderer(renderer);
            }

            JPanel panel = new JPanel(new BorderLayout());
            panel.add(scrollPane, BorderLayout.CENTER);

            JButton previousButton = new JButton("Poprzedni dzień");
            JButton nextButton = new JButton("Następny dzień");

            previousButton.addActionListener(e -> {
                data = data.minusDays(1);
                updateHarmonogram();
            });

            nextButton.addActionListener(e -> {
                data = data.plusDays(1);
                updateHarmonogram();
            });

            JPanel buttonPanel = new JPanel();
            buttonPanel.add(previousButton);
            buttonPanel.add(nextButton);
            panel.add(buttonPanel, BorderLayout.SOUTH);

            frame.getContentPane().removeAll();
            frame.getContentPane().add(panel);
            frame.revalidate();
            frame.repaint();

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

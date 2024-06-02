package main;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import java.awt.*;

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

function variable = LineOptions(handle, variable, ui)

source=get(handle);
parent = get(source.Parent);
grandParent = get(parent.Parent);
idx = str2double(grandParent.Tag);

switch parent.Text
    case 'Line Color'
        lineColor = ColorDictionary(source.Text);
        variable(idx).color = lineColor;
        set(variable(idx).linePlotH, 'color', lineColor);
        set(ui.main.entryHelpH(idx), 'foregroundcolor', ...
            variable(idx).color);
    case 'Line Style'
        variable(idx).lineStyle = source.Text;
        set(variable(idx).linePlotH, 'LineStyle', source.Text);
    case 'Line Thickness'
        lineWidth = str2double(source.Text);
        variable(idx).lineWidth = lineWidth;
        set(variable(idx).linePlotH, 'lineWidth', lineWidth);
    case 'Marker Style'
        variable(idx).marker = source.Text;
        set(variable(idx).linePlotH, 'marker', source.Text);
    case 'Marker Size'
        markerSize = str2double(source.Text);
        variable(idx).markerSize = markerSize;
        set(variable(idx).linePlotH, 'MarkerSize', markerSize);
    case 'Marker Fill Color'
        fillColor = ColorDictionary(source.Text);
        variable(idx).markerFill = fillColor;
        set(variable(idx).linePlotH, 'MarkerFaceColor', fillColor);
end

% update check marks for menu items
MenuCheckMarks(handle);

end

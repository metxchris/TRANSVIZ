function variable = LineOptions(handle, variable, ui)

source=get(handle);
parent = get(source.Parent);
grandParent = get(parent.Parent);
idx = str2double(grandParent.Tag);

switch parent.Label
    case 'Line Color'
        lineColor = ColorDictionary(source.Label);
        variable(idx).color = lineColor;
        set(variable(idx).linePlotH, 'color', lineColor);
        set(ui.main.entryHelpH(idx), 'foregroundcolor', ...
            variable(idx).color);
    case 'Line Style'
        variable(idx).lineStyle = source.Label;
        set(variable(idx).linePlotH, 'LineStyle', source.Label);
    case 'Line Thickness'
        lineWidth = str2double(source.Label);
        variable(idx).lineWidth = lineWidth;
        set(variable(idx).linePlotH, 'lineWidth', lineWidth);
    case 'Marker Style'
        variable(idx).marker = source.Label;
        set(variable(idx).linePlotH, 'marker', source.Label);
    case 'Marker Size'
        markerSize = str2double(source.Label);
        variable(idx).markerSize = markerSize;
        set(variable(idx).linePlotH, 'MarkerSize', markerSize);
    case 'Marker Fill Color'
        fillColor = ColorDictionary(source.Label);
        variable(idx).markerFill = fillColor;
        set(variable(idx).linePlotH, 'MarkerFaceColor', fillColor);
end

% update check marks for menu items
MenuCheckMarks(handle);

end

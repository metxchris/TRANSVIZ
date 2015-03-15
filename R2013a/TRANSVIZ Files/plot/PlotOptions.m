function [variable, ui, option] = PlotOptions(handle, variable, option, ui)

SystemMsg('', '', ui); % clear systemMsg

source = get(handle);
sourceLabel = strrep(source.Label, '&', '');
parentName = strrep(get(source.Parent, 'Label'), '&', '');
switch parentName
    case 'Renderer'
        set(ui.main.figH, 'renderer', sourceLabel);
        if strcmp(option.plotMode, 'Surface Plot') && ...
                strcmp(sourceLabel, 'Painters');
            SystemMsg(...
                'Warning: Surface plotting using painters is extremely slow.', ...
                'Warning', ui)
            try
                set(ui.main.rotate3dH, 'RotateStyle', 'orbit');
            end
        end
    case 'Grid Lines'
        option.lineGrid = sourceLabel;
        set(ui.main.axesH, ...
            'xgrid', option.lineGrid, ...
            'ygrid', option.lineGrid)
    case 'Surface Grid Lines'
        option.surfaceGrid = sourceLabel;
        set(ui.main.axesH, ...
            'xgrid', option.surfaceGrid, ...
            'ygrid', option.surfaceGrid, ...
            'zgrid', option.surfaceGrid);
    case 'Axes Box'
        option.lineBox = sourceLabel;
        set(ui.main.axesH, 'Box', option.lineBox);
    case 'Surface Box'
        option.surfaceBox = sourceLabel;
        set(ui.main.axesH, 'Box', option.surfaceBox);
        
    case 'Legend Location'
        option.legendLocation = sourceLabel;
        try % silently avoid error if legend doesn't exist
            set(ui.main.legendH, 'location', option.legendLocation)
        end
    case 'Surface Style'
        option.surfaceStyle = sourceLabel;
        if ~isempty(variable(1).Y.name)
            [variable, ui] = UpdateDisplay(variable, option, ui);
        end
        
    case 'Color Map'
        option.colorMap = sourceLabel;
        colormap(option.colorMap);
end

% update check marks for menu items
MenuCheckMarks(handle);

end
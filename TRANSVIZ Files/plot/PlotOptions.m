function [ui, option] = PlotOptions(handle, ui, option)

SystemMsg('', '', ui, option); % clear systemMsg

source = get(handle);
sourceLabel = strrep(source.Label, '&', '');

parentName = strrep(get(source.Parent, 'Label'), '&', '');
switch parentName
    case 'Renderer'
        set(ui.main.figH, 'renderer', sourceLabel);
        if strcmp(option.plotMode, 'Surface Plot')
            SystemMsg(...
                'Warning: Surface plotting using painters is extremely slow.', ...
                'Warning', ui, option)
        end
    case 'Grid Lines'
        option.gridMode = sourceLabel;
        set(ui.main.axesH, ...
            'xgrid', option.gridMode, ...
            'ygrid', option.gridMode)
    case 'Axes Box'
        option.axesBoxMode = sourceLabel;
        set(ui.main.axesH, 'Box', option.axesBoxMode)
    case 'Legend Location'
        option.legendLocation = sourceLabel;
        try % silently avoid error if legend doesn't exist
            set(ui.main.legendH, 'location', option.legendLocation)
        end
end

% uncheck all related menu items
parentHandle = get(source.Parent);
set(parentHandle(:).Children, 'checked', 'off')
% check called menu item
set(handle, 'Checked', 'on');

end
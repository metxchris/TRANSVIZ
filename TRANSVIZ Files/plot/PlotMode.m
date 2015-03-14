function option = PlotMode(handle, variable, option, ui)

source = get(handle);
option.plotMode = strrep(source.Label, '&', '');

lineMenuHandles = [ui.menu.legendLocationMH, ui.menu.lineGridMH, ...
    ui.menu.lineBoxMH, ui.menu.lineTransparencyMH];
surfMenuHandles = [ui.menu.colorMapMH, ui.menu.surfaceGridMH, ...
    ui.menu.surfaceBoxMH, ui.menu.surfaceStyleMH];
cla; % clear axis
switch option.plotMode
    case 'Line Plot'
        set(ui.main.sliderH, 'visible', 'on');
        try
            set(ui.main.legendH,'visible','on')
        end
        for j = 1:numel(variable)
            if ~isempty(variable(j).Y.name)
                set(ui.main.entryHelpH(j), 'visible', 'on');
            end
        end
        set(ui.main.entryBoxH(2:end), 'visible', 'on');
        set(ui.main.entryLabelH(2:end), 'visible', 'on');
        set(ui.main.sliderModeB(:), 'visible', 'on');
        set(ui.main.textHeaderH(3), 'visible', 'on');
        set(ui.main.sliderModeH, 'visible', 'on');
        try
            set(ui.main.rotate3dH,'enable','off');
        end
        set(lineMenuHandles, 'visible', 'on');
        set(surfMenuHandles, 'visible', 'off');
    case 'Surface Plot'
        set(ui.main.sliderH, 'visible', 'off');
        try
            set(ui.main.legendH,'visible','off')
        end
        set(ui.main.entryHelpH(:), 'visible', 'off');
        try
            set([variable(:).linePlotH],'visible','off');
            set(ui.main.plotTimeH, 'visible', 'off');
        end
        set(ui.main.entryBoxH(2:end), 'visible', 'off');
        set(ui.main.entryLabelH(2:end), 'visible', 'off');
        set(ui.main.sliderModeB(:), 'visible', 'off');
        set(ui.main.textHeaderH(3), 'visible', 'off');
        set(ui.main.sliderModeH, 'visible', 'off');
        set(lineMenuHandles, 'visible', 'off');
        set(surfMenuHandles, 'visible', 'on');
        
end

% update check marks for menu items
MenuCheckMarks(handle);

end
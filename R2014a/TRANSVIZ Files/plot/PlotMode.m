function option = PlotMode(handle, variable, option, ui)

source = get(handle);
option.plotMode = strrep(source.Label, '&', '');

switch option.plotMode
    case 'Line Plot'
        SetLineHandles(ui, 'visible', 'on');
        SetEntryHandles(ui, variable, 'visible', 'on');
        SetSurfaceHandles(ui, 'visible', 'off');
        try set(ui.main.rotate3dH, 'enable', 'off'); end %#ok<*TRYNC>
    case 'Surface Plot'
        SetLineHandles(ui, 'visible', 'off');
        SetEntryHandles(ui, variable, 'visible', 'off');
        SetSurfaceHandles(ui, 'visible', 'on');
end

% update check marks for menu items
MenuCheckMarks(handle);

%% Internal functions

    function SetLineHandles(ui, type, state)
        set(ui.main.entryBoxH(2:end), type, state);
        set(ui.main.entryLabelH(2:end), type, state);
        set(ui.main.sliderModeB(:), type, state);
        set([ui.menu.legendLocationMH, ui.menu.lineGridMH, ...
            ui.menu.lineBoxMH, ui.main.sliderModeH, ...
            ui.main.sliderH, ui.main.textHeaderH(3)], type, state);
    end

    function SetSurfaceHandles(ui, type, state)
        set([ui.menu.colorMapMH, ui.menu.surfaceGridMH, ...
            ui.menu.surfaceBoxMH, ui.menu.surfaceStyleMH], type, state);
    end

    function SetEntryHandles(ui, variable, type, state)
        switch state
            case 'on'
                for j = 1:numel(variable)
                    if ~isempty(variable(j).Y.name)
                        set(ui.main.entryHelpH(j), 'visible', 'on');
                        HandHoverCursor(ui.main.entryHelpH(j));
                    end
                end
            case 'off'
                set(ui.main.entryHelpH(:), type, state);
        end
    end

end

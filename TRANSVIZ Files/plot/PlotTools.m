function [ui, option] = PlotTools(handle, ui, option)
SystemMsg('', '', ui, option); % clear systemMsg
source = get(handle);
sourceLabel = strrep(source.Label, '&', '');
currentState = source.Checked;
parentHandle = get(source.Parent);
set(parentHandle(:).Children, 'checked', 'off'); % uncheck all tools
switch sourceLabel
    case 'Reset View'
        % resets plot view and turns off all tools
        zoom out;
        zoom off;
        pan off;
    case 'Zoom In'
        % enables plot zooming
        switch currentState
            case 'on'
                zoom off
                switch option.plotMode
                    case 'Surface Plot'
                        rotate3d on;
                end
            case 'off'
                zoom on;
                set(handle, 'Checked', 'on');
        end
    case 'Pan'
        % enables plot panning
        switch currentState
            case 'on'
                pan off
                switch option.plotMode
                    case 'Surface Plot'
                        rotate3d on;
                end
            case 'off'
                pan on;
                set(handle, 'Checked', 'on');
        end
end

end

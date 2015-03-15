function sliderValue = SliderUpdate(sliderValue, variable, option, ui)
% Slider callback, Modifies the sliderValue

% skip repeat slider calls (due to Matlab bugs)
if  option.slider.value == sliderValue
    % disp('repeat slider call');
    return
end

% store and update slider value
option.slider.value = sliderValue;
set(ui.main.sliderH, 'Value', sliderValue);

% Clear msg area
SystemMsg('', '', ui);

% Map slider value to array index
sIdx = MapSlider(option, variable);

% update displayed time or position value.
dataString = SetSliderString(variable, option);
set(ui.main.plotTimeH, 'string', dataString);

% Update Plotted Data
% Faster to write the loop twice here instead of having the
% switch inside of a single for loop;
switch option.slider.mode
    case 'Time'
        for j = option.leadVar:numel(variable)
            if ishandle(variable(j).linePlotH)
                set(variable(j).linePlotH, ...
                    'YData', variable(j).Y.data(:, sIdx(j)));
            end
        end
    case 'Position'
        for j = option.leadVar:numel(variable)
            if ishandle(variable(j).linePlotH)
                set(variable(j).linePlotH, ...
                    'YData', variable(j).Y.data(sIdx(j), :));
            end
        end
end

end

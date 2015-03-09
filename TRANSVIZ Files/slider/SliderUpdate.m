function sliderValue = SliderUpdate(sliderValue, variable, option,ui)
% Slider callback, Modifies the sliderValue

% skip repeat slider calls (due to Matlab bugs)
if  option.slider.value == sliderValue
    % disp('repeat slider call');
    return
end

% store and update slider value
option.slider.value = sliderValue;
set(ui.main.sliderH,'Value',sliderValue);

% Hide msg area when appropriate
if strcmp(get(ui.main.systemMsgH,'visible'),'on') && ~option.errorLevel
    SystemMsg('', '', ui, option);
end

% Map slider value to array index
sIdx = MapSlider(option,variable);

varY=[variable.Y];varDataY = {varY.data};

% update displayed time or position value.
dataString = SetSliderString(variable, option);
set(ui.main.plotTimeH,'string',dataString);

% Update Plotted Data
% Faster to write the loop twice here instead of having the
% switch inside of a single for loop
switch option.slider.mode
    case 'Time'
        for j=option.leadVar:numel(variable)
            if ishandle(variable(j).linePlotH)
                set(variable(j).linePlotH,...
                    'YData',varDataY{j}(:,sIdx(j)));
            end
        end
    case 'Position'
        for j=option.leadVar:numel(variable)
            if ishandle(variable(j).linePlotH)
                set(variable(j).linePlotH,...
                    'YData',varDataY{j}(sIdx(j),:));
            end
        end
end

end
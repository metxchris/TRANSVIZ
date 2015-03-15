function option = SliderMode(handle, variable, option, ui)
if option.testMode
    disp('SliderMode.m called');
end

% Repeat button calls
if ~get(handle,'val')
    set(handle,'val',1) % To keep the Tab-like functioning.
    return
end

switch get(handle,'string')
    case 'Time'
        a = 1; b = 2;
        option.slider.mode = 'Time';
        option.slider.X.value = option.slider.value;
        newSlider = option.slider.T;
        % set([S.ax,S.pb1,L],{'visible'},{'on'})
    case 'Position'
        a = 2; b = 1;
        option.slider.mode = 'Position';
        option.slider.T.value = option.slider.value;
        newSlider = option.slider.X;
end

highlighted = [0.95 0.95 0.95]; gray = [0.9 0.9 0.9];
set(ui.main.sliderModeB(a), 'BackgroundColor', highlighted);
set(ui.main.sliderModeB(b), {'val','backgroundcolor'}, {0, gray});

% store current values
option.slider.value = newSlider.value;
option.slider.max   = newSlider.max;
option.slider.min   = newSlider.min;
option.slider.step  = newSlider.step;

option.slider.value = BoundSliderValue(option);

% update slider properties
set(ui.main.sliderH,...
    'Max', option.slider.max         ,...
    'Min', option.slider.min         ,...
    'sliderStep', option.slider.step,...
    'value', option.slider.value);

% update displayed time or position value.
if ~isempty(option.leadVar)
    sliderString = SetSliderString(variable, option);
    set(ui.main.plotTimeH, 'string', sliderString);
end

end 
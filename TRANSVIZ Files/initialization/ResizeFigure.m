function ResizeFigure(ui, option)
% Figure initial size/resize function
% Adjust object positions so that they maintain appropriate proportions
if option.testMode>0
    disp('ResizeFigure.m called');
end;

set(0, 'currentfigure', ui.main.figH);

ResizeAxes(ui,option);

fP = get(ui.main.figH, 'Position');
% fP(1) = figure x-position
% fP(2) = figure y-position
% fP(3) = figure width
% fP(4) = figure height

% Set GUI Positioning Variables
h(1) = fP(4) - 55;
h(2) = h(1) - 55;
h(3) = h(2) - 148;
gS = 17; % gui element spacing

% Entry Box Positions, Used for loading variables as well
width=90;
for j=1:1:numel(ui.main.entryBoxH)
    set(ui.main.entryBoxH(j), ...
        'Position', [fP(3)-110, h(2)-20*j, width, 18]);
end
for j=1:numel(ui.main.textHeaderH)
    set(ui.main.textHeaderH(j), ...
        'Position', [fP(3)-130, h(j), 100, 15]);
end
for j=1:numel(ui.main.entryLabelH)
    % must have ui.main.entryLabelH == ui.main.entryHelpH
    set(ui.main.entryLabelH(j), ...
        'Position', [fP(3)-125, h(2)-20*j, 20, 16]);
    set(ui.main.entryHelpH(j), ...
        'Position', [fP(3)-18, h(2)-20*j+1, 14, 16]);
end
set(ui.main.activeCdfH, 'Position', [fP(3)-125, h(1)-gS, 105, 16]);
set(ui.main.sliderH, 'Position', [70, 11, fP(3)-210, 21]);
set(ui.main.splashH, 'Position', [70, 84, fP(3)-215, fP(4)-125]);
set(ui.main.sliderModeH, 'Position', [fP(3)-125, h(3)-24, 110, 26]);
set(ui.main.sliderModeB(1), 'Position', [6 2 50 22]);
set(ui.main.sliderModeB(2), 'Position', [57 2 50 22]);
set(ui.main.systemMsgH, 'Position', [0,fP(4)-15, fP(3)+2, 16]);

aP=get(ui.main.axesH, 'position');
if ishandle(ui.main.plotTimeH)
    set(ui.main.plotTimeH,'Position',[aP(3), aP(4)+8]);
end

end

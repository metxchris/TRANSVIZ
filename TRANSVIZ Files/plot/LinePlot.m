function [variable, ui] = LinePlot(variable, option, ui)
if option.testMode>0
    disp('LinePlot.m called');
end;

% load data structures
switch option.slider.mode
    case 'Time'
        varStructX=[variable.X];
    case 'Position'
        varStructX=[variable.T];
end
varStructY = [variable.Y];

% map slider value to array index value
sIdx = MapSlider(option, variable);

% set x- and y-axis bounds
maxX = max([varStructX.max]);
minX = min([varStructX.min]);
maxY = max([varStructY.max]);
minY = min([varStructY.min]);

% slightly tweak y-axis limits
range = maxY - minY;
if range == 0
    minY = minY - minY/200 - 1;
    maxY = maxY + maxY/200 + 1;
else
    maxY = maxY + range/100;
    minY = minY - range/200;
end

varDataX = {varStructX.data};
varDataY = {varStructY.data};
initialPlot = 1;
% Plotting Loop
for j = option.leadVar:numel(variable)
    if isempty(variable(j).Y.name)
        continue;
    end
    try
        switch option.slider.mode
            case 'Time'
                varX = varDataX{j}(:, sIdx(j));
                varY = varDataY{j}(:, sIdx(j));
            case 'Position'
                varX = varDataX{j}(1, :); % TIME data, only one row
                varY = varDataY{j}(sIdx(j), :);
        end
        varName = strrep(variable(j).Y.name, '_', '\_');
        displayName = [' ', varName, ...
            '\color[rgb]{0.4 0.4 0.4} (', variable(j).cdfName, ')'];
        variable(j).linePlotH = plot(ui.main.axesH, ...
            varX, varY, ...
            'DisplayName', displayName, ...
            'lineWidth', variable(j).lineWidth, ...
            'LineStyle', variable(j).lineStyle, ...
            'marker', variable(j).marker, ...
            'MarkerSize', variable(j).markerSize, ...
            'MarkerFaceColor', variable(j).markerFill, ...
            'color', variable(j).color, ...
            'LineSmoothing', 'on', ...
            'tag', num2str(j), ...
            'buttonDownFcn', @linePlotCB, ...
            'uicontextmenu', ui.line(j).menuH ...
            );  % 'uicontextmenu', cmenu, ...
    catch errorMsg
        getReport(errorMsg, 'extended', 'hyperlinks', 'on')
    end
    if initialPlot
        hold on; % draw multiple plots on one axis
        initialPlot = 0;
    end
end % plotting loop
hold off;

ui.main.plotTimeH = text(...
    1, 1, '', ...
    'units', 'pixels', ...
    'horiz', 'right', ...
    'vert', 'baseline', ...
    'fontsize', 10);

% update displayed time or position value.
sliderString = SetSliderString(variable, option);
set(ui.main.plotTimeH, 'string', sliderString);

set(ui.main.axesH, ...
    'xgrid', option.lineGrid, ...
    'ygrid', option.lineGrid, ...
    'TickDir', option.tickDirMode, ...
    'Box', option.lineBox, ...
    'xlim', [minX maxX], ...
    'ylim', [minY maxY]);

% generate plot labels
ylabel(ui.main.axesH, ...
    [variable(option.leadVar).Y.label, variable(option.leadVar).Y.units], ...
    'FontSize', 12, 'buttonDownFcn', @editFigureLabelCB);
xlabel(ui.main.axesH, ...
    [varStructX(option.leadVar).label, varStructX(option.leadVar).units], ...
    'FontSize', 12, 'buttonDownFcn', @editFigureLabelCB);
% why is xlabel different form than ylabel?
% ans: because varStructX depends on if slider is Time or Pos mode

% create legend; legend entries = displayName from plotting loop
ui.main.legendH = legend(ui.main.axesH, 'show');
set(ui.main.legendH, ...
    'FontSize', 8, ...
    'Box', 'On', ...
    'location', option.legendLocation, ...
    'orientation', option.legendOrientation, ...
    'edgeColor', [1 1 1], ...
    'color', 'none', ...
    'interpreter', 'tex' ...
    );
legendshrink(0.6, 'best'); % shrink legend lines 

% % % Random MATLAB bug: OpenGL fails for data values of magnitude >= 10^22
if strcmp(get(ui.main.figH, 'renderer'), 'OpenGL') && (maxY >= 10^(22) || (minY < -10^(22)))
    set(ui.main.figH, 'renderer', 'painters')
    SystemMsg('OpenGL fails for magnitudes of 10^22 or greater, switching renderer to Painters.', 'Msg', ui, option);
% %     for j=1:numel(ui.main.rendererH)
% %         set(ui.main.rendererH{j}, 'checked', 'off');
% %     end
% %     set(ui.main.rendererH{3}, 'Checked', 'on');
end

ResizeFigure(ui, option); %hacky type of fix - don't remember what for though.

    function linePlotCB(varargin)
    
    end
end %linePlotF
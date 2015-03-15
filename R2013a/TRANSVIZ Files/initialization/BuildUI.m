function ui = BuildUI(option, variable)
%% Create user interface (ui)
ui = struct;

% main interface
ui.main.figH = figure(  ...
    'name', 'TRANSVIZ', ...
    'menubar',   'none', ...
    'Units'     , 'Pixels'    , ...
    'toolbar', 'none', ...
    'Position', option.figSize, ...
    'renderer', 'opengl', ...
    'DefaultTextInterpreter', 'TeX');
ui.main.axesH = axes(                 ...
    'Units', 'Pixels'     , ...
    'visible', 'off');
ui.main.activeCdfH = uicontrol(...
    'Style', 'popupmenu', ...
    'String', option.cdfList, ...
    'Units', 'Pixels', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.splashH = uicontrol(...
    'style', 'edit', ...
    'BackgroundColor', [1 1 1], ...
    'max', 5);
ui.main.sliderH = uicontrol( ...
    'Style'     , 'Slider'    , ...
    'Units'     , 'Pixels'    , ...
    'Min'       , 1           , ...
    'Max'       , 10           , ...
    'Value'     , option.slider.value  , ...
    'enable', 'off'...
    );
ui.main.plotTimeH = text(...
    1, 1, '', ...
    'units', 'pixels', ...
    'horiz', 'right', ...
    'vert', 'baseline', ...
    'fontsize', 8 );
ui.main.textHeaderH(1) = uicontrol(...
    'Style', 'text', ...
    'String', 'Active CDF:', ...
    'Units', 'Pixels', ...
    'HorizontalAlignment', 'left', ...
    'enable', 'off', ...
    'FontWeight', 'bold');
ui.main.textHeaderH(2) = uicontrol(...
    'Style', 'text', ...
    'String', 'Variable Entry:', ...
    'Units', 'Pixels', ...
    'HorizontalAlignment', 'left', ...
    'enable', 'off', ...
    'FontWeight', 'bold');
ui.main.textHeaderH(3) = uicontrol(...
    'Style', 'text', ...
    'String', 'Slider Mode:', ...
    'Units', 'Pixels', ...
    'HorizontalAlignment', 'left', ...
    'enable', 'off', ...
    'FontWeight', 'bold');
ui.main.entryLabelH(1) = uicontrol(...
    'Style', 'text', ...
    'String', '1)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryLabelH(2) = uicontrol(...
    'Style', 'text', ...
    'String', '2)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryLabelH(3) = uicontrol(...
    'Style', 'text', ...
    'String', '3)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryLabelH(4) = uicontrol(...
    'Style', 'text', ...
    'String', '4)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryLabelH(5) = uicontrol(...
    'Style', 'text', ...
    'String', '5)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryLabelH(6) = uicontrol(...
    'Style', 'text', ...
    'String', '6)', ...
    'Units', 'Pixels', ...
    'enable', 'off', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(1) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(2) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(3) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(4) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(5) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryHelpH(6) = uicontrol(...
    'Style', 'pushbutton', ...
    'String', '+', ...
    'Units', 'Pixels', ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left');
ui.main.entryBoxH(1) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '1', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.entryBoxH(2) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '2', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.entryBoxH(3) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '3', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.entryBoxH(4) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '4', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.entryBoxH(5) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '5', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.entryBoxH(6) = uicontrol(...
    'style', 'edit', ...
    'string' , '', ...
    'tag', '6', ...
    'BackgroundColor', [1 1 1], ...
    'enable', 'off');
ui.main.sliderModeH = uibuttongroup(...
    'visible', 'on', ...
    'units', 'pixels', ...
    'bordertype', 'none', ...
    'SelectedObject', []);
ui.main.sliderModeB(1) = uicontrol('style', 'toggle', ...
    'units', 'pixels', ...
    'string', 'Time', ...
    'parent', ui.main.sliderModeH, ...
    'backgroundcolor', [241/255 241/255 241/255], ...
    'val', 1, ...
    'enable', 'off');
ui.main.sliderModeB(2) = uicontrol('style', 'toggle', ...
    'units', 'pixels', ...
    'string', 'Position', ...
    'value', 0, ...
    'parent', ui.main.sliderModeH, ...
    'enable', 'off');
ui.main.systemMsgH = uicontrol(...
    'Style', 'text', ...
    'string', '', ...
    'Units', 'Pixels', ...
    'HorizontalAlignment', 'center', ...
    'fontsize', 9);
% line menu choices
lineColor = {'Blue', 'Orange', 'Yellow', 'Purple',  'Green', 'Red',  ...
          'Cyan', 'Brown', 'Light Gray', 'Dark Gray', 'Black'};
% lineColor = {'Blue', 'Red', 'Green', 'Purple', 'Orange', 'Cyan', ...
%         'Yellow', 'Brown', 'Light Gray', 'Dark Gray', 'Black'};
lineThickness = {'0.50', '1.00', '1.25', '1.50', '1.75', '2.00', ...
    '2.50', '3.00', '4.00', '5.00'};
lineStyle = {'-', '-.', '--', ':', 'None'};
markerStyle = {'+', 'o', '*', '.', 'x', 's', 'd', '^', ...
        '>', '<', 'p', 'h', 'None'};
markerSize = {'4', '5', '6', '8', '10', '12', '15'};
markerFill = lineColor;
% loop for setting line menus (a different context menu for each line)
for i = 1:numel(variable)
    % tag is later used to figure out what line the context menu call 
    % belongs to.
    ui.line(i).menuH = uicontextmenu('tag', num2str(i)); 
    % Define the context menu items
    ui.line(i).colorMH = uimenu(ui.line(i).menuH, 'Label', 'Line Color');
    ui.line(i).styleMH = uimenu(ui.line(i).menuH, 'Label', 'Line Style');
    ui.line(i).thickMH = uimenu(ui.line(i).menuH, 'Label', 'Line Thickness');
    ui.line(i).markerMH = uimenu(ui.line(i).menuH, 'Label', 'Marker Style');
    ui.line(i).sizeMH = uimenu(ui.line(i).menuH, 'Label', 'Marker Size');
    ui.line(i).fillMH = uimenu(ui.line(i).menuH, 'Label', 'Marker Fill Color');
    % line menu item options
    for j = 1:numel(lineColor)
        ui.line(i).colorH(j) = uimenu(ui.line(i).colorMH, 'Label', lineColor{j});
    end
    for j = 1:numel(lineThickness)
        ui.line(i).thickH(j) = uimenu(ui.line(i).thickMH, 'Label', lineThickness{j});
    end
    for j = 1:numel(lineStyle)
        ui.line(i).styleH(j) = uimenu(ui.line(i).styleMH, 'Label', lineStyle{j});
    end
    for j = 1:numel(markerStyle)
        ui.line(i).markerH(j) = uimenu(ui.line(i).markerMH, 'Label', markerStyle{j});
    end
    for j = 1:numel(markerSize)
        ui.line(i).sizeH(j) = uimenu(ui.line(i).sizeMH, 'Label', markerSize{j});
    end
    for j = 1:numel(markerFill)
        ui.line(i).fillH(j) = uimenu(ui.line(i).fillMH, 'Label', markerFill{j});
    end
    ui.line(i).fillH(j+1) = uimenu(ui.line(i).fillMH, 'Label', 'None');
    set(ui.main.entryHelpH(i), 'uicontextmenu', ui.line(i).menuH);
end

% create top menu
ui.menu.fileMH = uimenu(ui.main.figH, ...
    'Label', '&File');
ui.menu.openFMH = uimenu(ui.menu.fileMH, ...
    'Label', '&Open CDF...');
ui.menu.exportFigureMH = uimenu(ui.menu.fileMH, ...
    'Label', 'Export &Figure', ...
    'separator', 'on',...
    'enable', 'off');
ui.menu.exportDataMH = uimenu(ui.menu.fileMH, ...
    'Label', 'Export &Data', ...
    'enable', 'off');
ui.menu.editMH = uimenu(ui.main.figH, ...
    'Label', '&Edit',...
    'enable', 'off');
ui.menu.plotModeMH = uimenu(ui.menu.editMH, ...
    'Label', '&Plot Mode');
ui.menu.plotModeH(1) = uimenu(ui.menu.plotModeMH, ...
    'Label', '&Line Plot');
ui.menu.plotModeH(2) = uimenu(ui.menu.plotModeMH, ...
    'Label', '&Surface Plot', ...
    'enable', 'on');
ui.menu.rendererMH = uimenu(ui.menu.editMH, ...
    'Label', '&Renderer');
ui.menu.rendererH(1) = uimenu(ui.menu.rendererMH, ...
    'Label', '&OpenGL');
ui.menu.rendererH(2) = uimenu(ui.menu.rendererMH, ...
    'Label', '&Painters');
% surface plot menu options
ui.menu.surfaceGridMH = uimenu(ui.menu.editMH, ...
    'Label', 'Surface &Grid Lines', ...
    'visible', 'off', ...
    'separator', 'on');
ui.menu.surfaceGridH(1) = uimenu(ui.menu.surfaceGridMH, 'Label', 'O&n');
ui.menu.surfaceGridH(2) = uimenu(ui.menu.surfaceGridMH, 'Label', 'O&ff');
ui.menu.surfaceBoxMH = uimenu(ui.menu.editMH, ...
    'Label', 'Surface &Box', ...
    'visible', 'off');
ui.menu.surfaceBoxH(1) = uimenu(ui.menu.surfaceBoxMH, 'Label', 'O&n');
ui.menu.surfaceBoxH(2) = uimenu(ui.menu.surfaceBoxMH, 'Label', 'O&ff');
ui.menu.surfaceStyleMH = uimenu(ui.menu.editMH, ...
    'Label', '&Surface Style', ...
    'visible', 'off');
ui.menu.surfaceStyleH(1) = uimenu(ui.menu.surfaceStyleMH, ...
    'Label', '&Surface Texture');
ui.menu.surfaceStyleH(2) = uimenu(ui.menu.surfaceStyleMH, ...
    'Label', '&Surface Grid');
ui.menu.surfaceStyleH(3) = uimenu(ui.menu.surfaceStyleMH, ...
    'Label', '&Mesh Grid');
ui.menu.colorMapMH = uimenu(ui.menu.editMH, ...
    'Label', '&Color Map', ...
    'visible', 'off');
ui.menu.colorMapH(1) = uimenu(ui.menu.colorMapMH, 'Label', '&Paruly');
ui.menu.colorMapH(2) = uimenu(ui.menu.colorMapMH, 'Label', '&Jet');
ui.menu.colorMapH(3) = uimenu(ui.menu.colorMapMH, 'Label', 'Hs&v');
ui.menu.colorMapH(4) = uimenu(ui.menu.colorMapMH, 'Label', '&Bone');
ui.menu.colorMapH(5) = uimenu(ui.menu.colorMapMH, 'Label', '&Hot');
ui.menu.colorMapH(6) = uimenu(ui.menu.colorMapMH, 'Label', '&Cool');
% line plot menu options
ui.menu.lineBoxMH = uimenu(ui.menu.editMH, ...
    'Label', 'Axes &Box', ...
    'separator', 'on');
ui.menu.lineBoxH(1) = uimenu(ui.menu.lineBoxMH, 'Label', 'O&n');
ui.menu.lineBoxH(2) = uimenu(ui.menu.lineBoxMH, 'Label', 'O&ff');
ui.menu.lineGridMH = uimenu(ui.menu.editMH, ...
    'Label', '&Grid Lines');
ui.menu.lineGridH(1) = uimenu(ui.menu.lineGridMH, 'Label', 'O&n');
ui.menu.lineGridH(2) = uimenu(ui.menu.lineGridMH, 'Label', 'O&ff');
ui.menu.legendLocationMH = uimenu(ui.menu.editMH, ...
    'Label', '&Legend Location');
ui.menu.legendLocationH(1) = uimenu(ui.menu.legendLocationMH, ...
    'Label', '&NorthEast');
ui.menu.legendLocationH(2) = uimenu(ui.menu.legendLocationMH, ...
    'Label', 'North&West');
ui.menu.legendLocationH(3) = uimenu(ui.menu.legendLocationMH, ...
    'Label', 'South&East');
ui.menu.legendLocationH(4) = uimenu(ui.menu.legendLocationMH, ...
    'Label', '&SouthWest');
ui.menu.toolsMH = uimenu(ui.main.figH, 'Label', '&Tools',...
    'enable', 'off');
% disabled because after switching to and from surface plot mode, the reset
% view option would cause a 3d rotation in the 2d plot.  The user can just
% reset the view by replotting a variable instead in 2d, if needed.
% ui.menu.ResetViewH=uimenu(ui.menu.toolsMH, 'Label', '&Reset View');
ui.menu.ZoomInH=uimenu(ui.menu.toolsMH, ...
    'Label', '&Zoom In');
ui.menu.PanH=uimenu(ui.menu.toolsMH, ...
    'Label', '&Pan');
ui.menu.windowMH = uimenu(ui.main.figH, ...
    'Label', '&Window',...
    'enable', 'off');
ui.menu.varListH=uimenu(ui.menu.windowMH, ...
    'Label', '&Variable List');
ui.menu.pointerListH=uimenu(ui.menu.windowMH, ...
    'Label', '&Pointer List');
ui.menu.consoleMH = uimenu(ui.menu.windowMH, ...
    'Label', '&Console', ...
    'separator', 'on');
% Set Background Color of relevant uicontrols
SetBackgroundColor(ui, 'gray');
% printing options
set(ui.main.figH, 'InvertHardCopy', 'off');
set(0, 'DefaultFigureInvertHardcopy', 'on')
set(ui.main.figH, 'PaperPositionMode', 'auto');
% greatly speedup slider updates when legends are displayed
setappdata(gca, 'LegendColorbarManualSpace', 1);
setappdata(gca, 'LegendColorbarReclaimSpace', 1);
% modify tooltip properties
tm = javax.swing.ToolTipManager.sharedInstance; %static method to get ToolTipManager object
javaMethodEDT('setInitialDelay', tm, 0); %set tooltips to appear immediately
javaMethodEDT('setDismissDelay', tm, 600000); %tootips disappear after 10min.

end
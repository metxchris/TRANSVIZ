function TRANSVIZ(varargin)
%% About TRANSVIZ
% TRANSVIZ v2.03, by Christopher Wilson (cwils16@u.rochester.edu)
% Compatible with Matlab versions R2014+
% Please email me about any bugs.

%% Additional Potential Updates
% freeze line feature - displays grayscale copy of current plot in the
%   background so that variables from the same cdf can be compared at
%   different slider positions.
% set entryBoxes to read in mathematical operations, or add button for
%   this. (i.e. take a gradient)

%% TRANSVIZ Code
% Set testMode; 1 for testing, 0 for normal operation
if isempty(varargin)
    testMode = 0;
else
    testMode = 1;
end

% Initialization (genpath adds all subfolders as well)
addpath(genpath('TRANSVIZ Files'));
addpath(genpath('TRANSVIZ\TRANSVIZ Files'));
close all %close all windows
clc       %clear command window
pause on  %enable pausing capabilities

testFile = 'C:\Users\MetxChris\Documents\MATLAB\101391T25.CDF';
if testMode && exist(testFile, 'file')
    cdfPath = testFile;
else
    cdfPath = [];
end

[cdf, variable, option] = InitializeStructs(testMode);
ui = BuildUI(option, variable);
SetCallbacks(ui);

% set initial menu options
plotOptionsCB(ui.menu.plotModeH(1)) % Line Plot
plotOptionsCB(ui.menu.rendererH(1)) % OpenGL
% surface plot menu options
plotOptionsCB(ui.menu.surfaceStyleH(1)) % Surface Texture
plotOptionsCB(ui.menu.surfaceBoxH(2)) % Off
plotOptionsCB(ui.menu.surfaceGridH(1)) % On
plotOptionsCB(ui.menu.colorMapH(1)) % Jet
% line plot menu options
plotOptionsCB(ui.menu.lineBoxH(1)) % On
plotOptionsCB(ui.menu.lineGridH(2)) % Off
plotOptionsCB(ui.menu.legendLocationH(1)) % NorthEast
plotOptionsCB(ui.menu.lineTransparencyH(1)) % 1.00
% set additional line plot options
for k =1:numel(variable)
    lineOptionsCB(ui.line(k).colorH(k)) % 1 (Blue) through 6 (Red)
    lineOptionsCB(ui.line(k).styleH(mod(k-1, 3)+1)); % '-', '-.'
    lineOptionsCB(ui.line(k).markerH(13)) % None
    lineOptionsCB(ui.line(k).sizeH(3)) % 6
    lineOptionsCB(ui.line(k).fillH(12)) % None
    if k<4
        lineOptionsCB(ui.line(k).thickH(7)); % 2.50
    else
        lineOptionsCB(ui.line(k).thickH(6)); % 2.00
    end
end

% Set Splash Screen
if ~option.testMode || isempty(cdfPath)
    SplashMsg(ui); %Set splash screen text
else
    [cdf, option] = OpenFile(cdfPath, 1, ui, cdf, option);
end

ResizeFigure(ui, option);
% set '+' button cursor, also removes border
for k = 1:numel(ui.main.entryHelpH)
    HandHoverCursor(ui.main.entryHelpH(k))    
    set(ui.main.entryHelpH(k), 'visible', 'off');
end
debugCB(); %exports data to workspace when testMode enabled

%% Callbacks

    function SetCallbacks(ui)
        % Set main callbacks
        set(ui.main.figH, ...
            'ResizeFcn', {@ResizeCB}, ...
            'CloseRequestFcn', @ShutDown);
        set(ui.main.activeCdfH, 'Callback', @activeCdfCB);
        set(ui.main.entryBoxH(:), 'callback', @entryLoadCB);
        set(ui.main.entryHelpH(:), 'callback', @entryOptionsCB);
        set(ui.main.sliderModeH, 'SelectionChangeFcn', @sliderModeCB);
        set(ui.main.sliderModeB(:), 'callback', @sliderModeCB)
        % Set line callbacks
        for j = 1:numel(variable)
            set(ui.line(j).colorH(:), 'callback', @lineOptionsCB);
            set(ui.line(j).styleH(:), 'callback', @lineOptionsCB);
            set(ui.line(j).thickH(:), 'callback', @lineOptionsCB);
            set(ui.line(j).markerH(:), 'callback', @lineOptionsCB);
            set(ui.line(j).sizeH(:), 'callback', @lineOptionsCB);
            set(ui.line(j).fillH(:), 'callback', @lineOptionsCB);
        end
        % Set menu callbacks
        set(ui.menu.openFMH, 'Callback', @openFileCB);
        set(ui.menu.exportFigureMH, 'Callback', @exportFigureCB);
        set(ui.menu.exportDataMH, 'Callback', @exportDataCB);
        set(ui.menu.plotModeH(:), 'Callback', @plotModeCB);
        set(ui.menu.rendererH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceStyleH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceBoxH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceGridH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.colorMapH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.lineBoxH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.lineGridH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH(:), 'Callback', @plotOptionsCB);
        set(ui.menu.lineTransparencyH(:), 'Callback', @plotOptionsCB);
        set([ui.menu.ZoomInH, ui.menu.PanH], ...
            'Callback', @plotToolsCB);
        set(ui.menu.varListH, 'Callback', @openVarListCB);
        set(ui.menu.pointerListH, 'Callback', @openPointerListCB);
        set(ui.menu.consoleMH, 'Callback', @openConsoleCB);
        % slider listener
        addlistener(ui.main.sliderH, 'ContinuousValueChange', @sliderCB);
    end

    function ResizeCB(varargin)
        ResizeFigure(ui, option);
    end

    function sliderModeCB(varargin)
        % switches slider mode between time and position
        handle = varargin{1}; % Get calling handle
        if isa(handle, 'matlab.ui.container.ButtonGroup')
            % cancel call for the button group.
            % why does R2014b call with the button group and the button as
            % well? R2013a didn't do this.
            return
        end
        option = SliderMode(handle, variable, option, ui);
        [variable, ui] = UpdateDisplay(variable, option, ui);
        debugCB();
    end

    function openFileCB(src, evt)
        % loads cdf into memeory
        [cdf, option] = OpenFile(src, evt, ui, cdf, option);
        if ~isempty(findobj('type', 'figure', 'name', 'Variable List'))
            openVarListCB() % reload var list to reflect new cdf
            openPointerListCB() % reload var list to reflect new cdf
        end
        debugCB();
    end

    function activeCdfCB(varargin)
        [ui, option] = ActiveCDF(ui, cdf, option);
        if ~isempty(findobj('type', 'figure', 'name', 'Variable List'))
            openVarListCB() % reload var list to reflect new cdf
        end
        if ~isempty(findobj('type', 'figure', 'name', 'Pointer List'))
            openVarListCB() % reload var list to reflect new cdf
        end
        debugCB();
    end

    function entryLoadCB(src, evt)
        % loads variable from cdf
        [variable, option] = VarEntry(src, evt, cdf, variable, option, ui);
        [variable, ui] = UpdateDisplay(variable, option, ui);
        debugCB();
    end

    function sliderCB(varargin)
        %option.sliderValue does not get updated until after the function
        %call, this allows us to bipass the function call when the
        %sliderValue does not change during an update.
        sliderValue = varargin{1}.Value;
        option.slider.value = ...
            SliderUpdate(sliderValue, variable, option, ui);
    end

    function exportFigureCB(varargin)
        % exports image of plotted data
        ExportFigure(option, ui);
    end

    function exportDataCB(varargin)
        % exports table of plotted data
        ExportData(variable, option, ui);
    end

    function openVarListCB(varargin)
        % cancel call if no CDF is loaded
        if isempty(option.activeCdfIdx)
            SystemMsg(...
                'Error:  Open a CDF before loading variable list.', ...
                'Warning', ui);
            return
        end
        % build variable list window
        ui = VarListWindow('single', cdf, option, ui);
        % set variable list callbacks
        set(ui.varlist.tableH, 'CellSelectionCallback', @varListCellCB);
        set(ui.varlist.varidBH, 'callback', @varListSorterCB);
        set(ui.varlist.nameBH, 'callback', @varListSorterCB);
        set(ui.varlist.descriptionBH, 'callback', @varListSorterCB);
        set(ui.varlist.sizeBH, 'callback', @varListSorterCB);
        set(ui.varlist.dimensionsBH, 'callback', @varListSorterCB);
        set(ui.varlist.unitsBH, 'callback', @varListSorterCB);
        debugCB();
    end

    function openPointerListCB(varargin)
        % cancel call if no CDF is loaded
        if isempty(option.activeCdfIdx)
            SystemMsg('Error:  Open a CDF before loading pointer list.', ...
                'Warning', ui);
            return
        end
        % build variable list window
        ui = VarListWindow('int8', cdf, option, ui);
        % set variable list callbacks
        set(ui.pointerlist.tableH, ...
            'CellSelectionCallback', @pointerListCellCB);
        set(ui.pointerlist.varidBH, 'callback', @pointerListSorterCB);
        set(ui.pointerlist.nameBH, 'callback', @pointerListSorterCB);
        set(ui.pointerlist.descriptionBH, 'callback', @pointerListSorterCB);
        set(ui.pointerlist.unitsBH, 'callback', @pointerListSorterCB);
        set(ui.pointerlist.fctidsBH, 'callback', @pointerListSorterCB);
        debugCB();
    end

    function varListSorterCB(src, ~)
        % sorts the variable list table
        data   = get(ui.varlist.tableH, 'data');
        tag    = get(ui.varlist.tableH, 'tag');
        button = get(src, 'tag');
        VarListSorter(ui.varlist.tableH, data, tag, button)
    end

    function pointerListSorterCB(src, ~)
        % sorts the pointer list table
        data   = get(ui.pointerlist.tableH, 'data');
        tag    = get(ui.pointerlist.tableH, 'tag');
        button = get(src, 'tag');
        VarListSorter(ui.pointerlist.tableH, data, tag, button)
    end

    function varListCellCB(~, evt)
        % automatically plots selected variables from the varlistwindow.
        % if statement avoids errors when sorting with a cell selected
        if numel(evt.Indices)
            idx      = evt.Indices(1);
            data     = get(ui.varlist.tableH, 'data');
            varName  = data(idx, 2);
            entryBox = 1;
            set(0, 'currentfigure', ui.main.figH);
            set(ui.main.entryBoxH(entryBox), 'string', data(idx, 2));
            [variable, option] = ...
                VarEntry(varName, entryBox, cdf, variable, option, ui);
            [variable, ui] = UpdateDisplay(variable, option, ui);
        end
        debugCB();
    end

    function pointerListCellCB(~, evt)
        % automatically plots selected variables from the varlistwindow.
        % if statement avoids errors when sorting with a cell selected
        if numel(evt.Indices)
            idx      = evt.Indices(1);
            data     = get(ui.pointerlist.tableH, 'data');
            varName  = data(idx, 2);
            entryBox = 1;
            set(0, 'currentfigure', ui.main.figH);
            set(ui.main.entryBoxH(entryBox), 'string', data(idx, 2));
            [variable, option] = ...
                VarEntry(varName, entryBox, cdf, variable, option, ui);
            [variable, ui] = UpdateDisplay(variable, option, ui);
        end
        debugCB();
    end

    function openConsoleCB(varargin)
        % build console gui
        ui = ConsoleWindow(ui);
        % set console callback
        set(ui.console.cmdBoxH, 'callback', @commandBoxCB);
        debugCB();
    end

    function commandBoxCB(src, ~)
        % handles console window command box entries
        commandStr=strrep(get(src, 'string'), '>> ', '');
        ui = CommandBox(commandStr, cdf, variable, option, ui);
        debugCB();
    end

    function plotOptionsCB(varargin)
        [variable, ui, option] = ...
            PlotOptions(varargin{1}, variable, option, ui);
        debugCB();
    end

    function plotModeCB(varargin)
        handle = varargin{1};
        option = PlotMode(handle, variable, option, ui);
        [variable, ui] = UpdateDisplay(variable, option, ui);
    end

    function entryOptionsCB(varargin)
        % opens '+' button context menu when user left-clicks
        % (right-click) opens context menu by default.
        handle = varargin{1};
        hP = get(handle, 'position');
        cm = get(handle, 'uicontextmenu');
        set(cm, 'position', [hP(1), hP(2)], 'visible', 'on' );
        % context menu auto-hides afterwards.
    end

    function plotToolsCB(varargin)
        [ui, option] = PlotTools(varargin{1}, ui, option);
        debugCB();
    end

    function lineOptionsCB(varargin)
        variable =  LineOptions(varargin{1}, variable, ui);
        debugCB(); 
    end

    function debugCB(varargin)
        % exports structs to MATLAB workspace for debugging purposes
        if option.testMode
            putvar(cdf, variable, option, ui);
        end
    end

end

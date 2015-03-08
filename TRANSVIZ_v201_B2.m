function TRANSVIZ_v201_B2(varargin)
%% Required Files

%% Todo
% make variable list window reopen in same spot if already open
% change all handle formats from {} to []

%% TRANSP-MMM Variable List
%  Relationship between transp radial variables
%  For X = "r/a" Zone Center, XB = "r/a" Boundary 
%  a = (max(RMAJM) - min(RMAJM))/2 = max(RMNMP)
%
%  RAXIS = median(RMAJM)
%
%

%% TRANSVIZ Code
% Set testMode; 1 for testing, 0 for normal operation
if isempty(varargin)
    testMode = 0;
else
    testMode = 1;
end

% Initialization (genpath adds all subfolders as well)
addpath(genpath('cdfGui Files'));
close all %close all windows
clc       %clear command window
pause on  %enable pausing capabilities

testFile = 'C:\Users\MetxChris\Documents\MATLAB\101391T25.CDF';
if testMode && exist(testFile, 'file')
    cdfPath = testFile;
else
    cdfPath = [];
end

[cdf,variable,option] = InitializeStructs(testMode);
ui = InitializeUI(option); % InitializeUI is an internal function

% Set Splash Screen
if testMode == 0 || isempty(cdfPath)
    splashStrF(ui); %Set splash screen text
else
    [cdf,option] = OpenFile(cdfPath, 1, ui, cdf, option);
end

if testMode
    % putvar exports variables to the matlab interface for debugging
    putvar(cdf, variable, option, ui);
end

    function ui = InitializeUI(option)
        % Build user interface
        ui = BuildUI(option,variable);
        % Set main callbacks
        set(ui.main.figH, 'ResizeFcn', @resizeCB,...
            'CloseRequestFcn', @cleanupF);
        set(ui.main.activeCdfH, 'Callback', @activeCdfCB);
        set(ui.main.tableH, 'CellSelectionCallback', @CellCallBack);
        set(ui.main.entryBoxH{1}, 'callback', @entryLoadCB);
        set(ui.main.entryBoxH{2}, 'callback', @entryLoadCB);
        set(ui.main.entryBoxH{3}, 'callback', @entryLoadCB);
        set(ui.main.entryBoxH{4}, 'callback', @entryLoadCB);
        set(ui.main.entryBoxH{5}, 'callback', @entryLoadCB);
        set(ui.main.entryBoxH{6}, 'callback', @entryLoadCB);
        set(ui.main.sliderModeH, 'SelectionChangeFcn', @sliderModeCB);
        set(ui.main.sliderModeB(:),{'callback'},{{@sliderModeCB}})
        set(ui.main.displayModeH, 'SelectionChangeFcn', @displayModeCB);
        set(ui.main.displayModeB(:),{'callback'},{{@displayModeCB}});
        set(ui.main.openVarListH , 'callback', @openVarListF);
        % Set menu callbacks
        set(ui.menu.openFMH, 'Callback', @openFileCB);
        set(ui.menu.exportFigureMH, 'Callback', @exportDataF);
        set(ui.menu.exportTableMH, 'Callback', @exportDataF);
        set(ui.menu.plotModeH{1}, 'Callback', @plotModeCB);
        set(ui.menu.plotModeH{2}, 'Callback', @plotModeCB);
% %         set(ui.menu.plotModeH{3}, 'Callback', @plotModeCB);
        set(ui.menu.rendererH{1}, 'Callback', @rendererCB);
        set(ui.menu.rendererH{2}, 'Callback', @rendererCB);
% %         set(ui.menu.editYH, 'Callback', @yaxiscallback);
% %         set(ui.menu.editXH, 'Callback', @xaxiscallback);
% %         set(ui.menu.editXH, 'Callback', @titlecallback);
% %         set(ui.menu.axisModeH{1}, 'Callback', @plotOptionsCB);
% %         set(ui.menu.axisModeH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceGridH{1}, 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceGridH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.surfaceGridH{3}, 'Callback', @plotOptionsCB);
        set(ui.menu.colorMapH{1}, 'Callback', @plotOptionsCB);
        set(ui.menu.colorMapH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.colorMapH{3}, 'Callback', @plotOptionsCB);
        set(ui.menu.axesBoxModeH{1}, 'Callback', @plotOptionsCB);
        set(ui.menu.axesBoxModeH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.gridModeH{1}, 'Callback', @plotOptionsCB);
        set(ui.menu.gridModeH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH{1}, 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH{2}, 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH{3}, 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH{4}, 'Callback', @plotOptionsCB);
        set(ui.menu.legendLocationH{5}, 'Callback', @plotOptionsCB);
        set(ui.menu.varListH, 'Callback', @openVarListCB);
        set(ui.menu.consoleMH, 'Callback', @openConsoleCB);
        % set toolbar callbacks
        set(ui.toolbar.zoomInH, 'ClickedCallback', @zoomCB);
        set(ui.toolbar.zoomOutH, 'ClickedCallback', @zoomCB);
        set(ui.toolbar.panH, 'ClickedCallback', @panCB);
        set(ui.toolbar.pointValueH, 'ClickedCallback', @pointValueCB);
        % allows slider to update plot while actively being dragged,
        % this also serves as the sliderH callback function.
        sliderListener = ...
            handle.listener(ui.main.sliderH, 'ActionEvent', @sliderCB);
        setappdata(ui.main.sliderH, 'listeners', sliderListener);
    end

%% Callbacks
    function sliderModeCB(varargin)
        % switches slider mode between time and position
        % [handle,struct] = varargin{[1,3]};% Get calling handle and structure.
        handle = varargin{1}; % Get calling handle
        option = SliderMode(handle, variable, option, ui);
        [variable, ui] = generalPlottingF(variable, option, ui);
    end

    function resizeCB(varargin)
        % resizes main window
        resizeF(ui,option);
    end

    function openFileCB(src,evt)
        % loads cdf into memeory
        [cdf,option] = OpenFile(src,evt,ui,cdf,option);
        if testMode
            putvar(cdf,variable,option,ui);
        end
    end

    function activeCdfCB(varargin)
        [ui,option] = ActiveCDF(ui,cdf,option);
        if ~isempty(findobj('type', 'figure', 'name', 'Variable List'))
            openVarListCB()
            figure(1);
        end
        if testMode
            putvar(cdf,variable,option,ui);
        end
    end

    function entryLoadCB(src, evt)
        % loads variable from cdf
        [variable, option] = VarEntry(src, evt, cdf, variable, option, ui);
        [variable, ui] = generalPlottingF(variable, option, ui);
        if testMode
            putvar(cdf,variable,option,ui);
        end
    end

    function displayModeCB(varargin)
        %toggles between plot/spreadsheet (table)
        handle = varargin{1}; % Get calling handle
        % for repeat button calls
        if get(handle, 'val')==0
            set(handle, 'val',1) % To keep the Tab-like functioning.
            return
        end
        option.displayMode = get(handle, 'string');
        DisplayMode(variable, option, ui);
        [variable, ui] = generalPlottingF(variable, option, ui);
        if testMode
            putvar(cdf,variable,option,ui);
        end
    end

    function sliderCB(varargin)
        %option.sliderValue does not get updated until after the function
        %call, this allows us to bipass the function call when the
        %sliderValue does not change during an update.
        sliderValue = varargin{1}.Value;
        option.slider.value = SliderUpdate(sliderValue,variable,option,ui);
    end

    function openVarListCB(varargin)
        % build variable list window
        ui = VarListWindow(cdf, variable, option, ui);
        % set variable list callbacks
        set(ui.varlist.tableH, 'CellSelectionCallback', @varListCellCB);
        set(ui.varlist.varidBH, 'callback', @tableSorterCB);
        set(ui.varlist.nameBH, 'callback', @tableSorterCB);
        set(ui.varlist.descriptionBH, 'callback', @tableSorterCB);
        set(ui.varlist.sizeBH, 'callback', @tableSorterCB);
        set(ui.varlist.dimensionsBH, 'callback', @tableSorterCB);
        set(ui.varlist.unitsBH, 'callback', @tableSorterCB);
    end

    function tableSorterCB(src,~)
        % sorts the variable list table
        data   = get(ui.varlist.tableH, 'data');
        tag    = get(ui.varlist.tableH, 'tag');
        button = get(src, 'tag');
        VarListSorter(ui,data,tag,button)
    end

    function varListCellCB(~,evt)
        % automatically plots selected variables from the varlistwindow.
        % if statement avoids errors when sorting with a cell selected
        if numel(evt.Indices)
            idx      = evt.Indices(1);
            data     = get(ui.varlist.tableH, 'data');
            varName  = data(idx,2);
            entryBox = 1;
            set(0, 'currentfigure', ui.main.figH);
            set(ui.main.entryBoxH{1}, 'string',data(idx,2));
            [variable, option] = ...
                VarEntry(varName, entryBox, cdf, variable, option, ui);
            [variable, ui] = generalPlottingF(variable, option, ui);
        end
    end

    function openConsoleCB(varargin)
        % build console gui
        ui = ConsoleWindow(ui);
        % set console callback
        set(ui.console.cmdBoxH, 'callback', @commandBoxCB);
    end

    function commandBoxCB(src,~)
        commandStr=strrep(get(src, 'string'), '>> ', '');
        ui = CommandBox(commandStr,ui);
        if testMode
            putvar(cdf,variable,option,ui);
        end
    end

 function cleanupF(varargin)
     % Close all related windows
     if ~isempty(findobj('type', 'figure', 'name', 'Console'))
         delete(findobj('type', 'figure', 'name', 'Console'));
     end
     if ~isempty(findobj('type', 'figure', 'name', 'Variable List'))
         delete(findobj('type', 'figure', 'name', 'Variable List'));
     end
     if ~isempty(findobj('type', 'figure', 'name', 'TRANSVIZ'))
         delete(findobj('type', 'figure', 'name', 'TRANSVIZ'));
     end
 end


end
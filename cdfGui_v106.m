function cdfGui_v106
%% Required Files
addpath(genpath('cdfGui Files'));
% findjobj.m - enables use of some java commands/functionality 
% uiinspect.m %% Not essential
% putvar.m - for debugging purposes within matlab

%% Todo List

% TE0 as main variable leads to slider bugs, slider displays time vals, not
% position while in slider 'position' mode

% add row/col number info above slider on bottom right

% figure export of line plots looks weird

%% TRANSP-MMM Variable List


%  Relationship between transp radial variables
%  For X = "r/a" Zone Center, XB = "r/a" Boundary 
%  a = (max(RMAJM) - min(RMAJM))/2 = max(RMNMP)
%
%  RAXIS = median(RMAJM)
%
%

%% Variable Initialization

clear all
% close all
clc
pause on

% Set Test Mode = 1 for testing, = 0 for normal operation
% cdfPath only used when testMode is enabled.
testMode = 0;
if testMode>0
    if exist('C:\Users\chris\Documents\MATLAB\103818V27.CDF','file')
        cdfPath='C:\Users\chris\Documents\MATLAB\103818V27.CDF';
    elseif exist('C:\Users\chris\Documents\MATLAB\131711L01.CDF','file')
        cdfPath='C:\Users\chris\Documents\MATLAB\131711L01.CDF';
    elseif exist('C:\Users\chris\Documents\MATLAB\125236L03.CDF','file')
        cdfPath='C:\Users\chris\Documents\MATLAB\125236L03.CDF';
    end
end
global errorLevel plotToggle varListTotal finfo ncid filePath varListTRANSP varid;
global header1Start header2Start header3Start activeCdf;
global legendH tableTitle tableTitleH plotTimeH plotTitleH plotTitle cdfVarCount varListTableH;
global sliderMode sliderValueX sliderValueT exportFigureMH exportTableMH varListSorted surfaceGridHM;
global axisMode linePlot legendLocation gridMode colorMode lineWidth plotMode heatMapH colorBarH figSize tickDirMode colorMap panH;

global varNameY varLabelY varUnitsY varDataY;
global varNameX varLabelX varUnitsX varDataX;
global varNameT varLabelT varUnitsT varDataT;
global cdfNameR cdfLabelR cdfUnitsR cdfDataR;
global varSizeY varCdfName;
global currentCdf;
        global dummy1 dummy2 dummy3 dummy4 dummy5;


[varNameY, varNameX, varNameT, varDataY, varDataX, varDataT, varUnitsY, ...
    varUnitsX, varUnitsT, varLabelY, varLabelX, varLabelT, varCdfName] = deal(cell(6,1)); % 6 variable slots
 [cdfNameR, cdfDataR, cdfLabelR, cdfUnitsR] = deal(cell(6,10));
                
[cdfList, finfo, ncid, varid]   = deal(cell(10,1));% 10 possible CDF entries


linePlot = cell(6,1);
% %
lineColor = {[0.094 0.353 0.663],[0 0.549 0.282],[0.933 0.180 0.184],[0.4 0.173 0.569],[0.957 0.490 0.137],[251/255 184/255 39/255]};


% acti
% Initialize Plot Values

plotToggle = 'Figure';
% ncid{activeCdf} = 1;


% Initialize the slider variables
sliderValue = 1;
sliderValueX = 1;
sliderValueT = 1;
sliderMax = 10;
sliderMode = 'Time';

errorLevel = 0;
axisMode = 'Global';
legendLocation = 'northeast';
gridMode = 'On';
colorMode=1;
lineWidth=1.5*ones(6,1);
lineStyle=cell(6,1);
lineMarker=cell(6,1);
lineMarkerFill=cell(6,1);
lineMarkerSize=6*ones(6,1);
for j=1:6
    lineStyle{j}='-';
    lineMarker{j}='none';
    lineMarkerFill{j}='none';
end
plotMode = 'Line Plot';% or 'Line Plot','Surface Plot','Heat Map'
tickDirMode = 'In';
axesBoxMode = 'On';
colorMap = 'Jet';
surfaceGrid = 'Surface Texture';

% Specifiy the MMM varibles to be listed on the figure First entry = 'none'
% (Format: varName - Description) varListMMM =
% {'none','g_ne','g_ni','g_nh','g_nz','g_te','g_ti','g_q','g_vtor','g_vpol','g_vpar'}


%% Build GUI
figSize = [200,200,800,500];

figH = figure(                ...
    'name','CDF Viewer',...
    'menubar',   'none',...
    'Units'     , 'Pixels'    , ...
    'ResizeFcn' , @resizeF,...
     'CloseRequestFcn',@cleanupF,...
     'toolbar','none',...
    'Position',figSize);
set(gcf, 'InvertHardCopy', 'off');
% movegui(figH,'center');%This breaks the javascript for the splash window
axesH = axes(                 ...
    'Units'     , 'Pixels'     ,...
    'visible','off');
 setappdata(gca,'LegendColorbarManualSpace',1);
 setappdata(gca,'LegendColorbarReclaimSpace',1);
tableH = uitable('Units','Pixels',...
    'visible','off',...
    'CellSelectionCallback',@CellCallBack);
splashH = uicontrol('style','edit', 'max',5);
sliderH = uicontrol(          ...
    'Style'     , 'Slider'    , ...
    'Units'     , 'Pixels'    , ...
    'Min'       , 1           , ...
    'Max'       , 10           , ...
    'Value'     , sliderValue        , ...
    'enable','off',...
    'Callback'  , @sliderF);
hListener = handle.listener(sliderH,'ActionEvent',@sliderF);
%    plotListCDF = uicontrol(        ...
%       'Style'     , 'popup'     , ...
%       'Units'     , 'Pixels'    , ...
%       'String'    , ' elong - Elong Flux Surface| ne - Electron Density| ni - Ion Density| nh - Hydrogenic Density| nd - Dueterium Density| nz - Impurity Ion Density| nf - Fast Ion Density| zeff - Mean Charge| te - Electron Temperature| ti - Ion Temperature| q - Magnetic q value| wexbs - ExB Shear Rate| vtor - Toroidal Velocity| vpol - Poloidal Velocity',...
% %       'Callback'  , @myPlotFcnCDF);
%      plotListMMM = uicontrol(        ...
%        'Style'     , 'popup'     , ...
%        'Units'     , 'Pixels'    , ...
%        'String'    , dropDownListMMM(varListMMM),...
%        'Callback'  , @myPlotFcnMMM);   
% plotListMMM = uicontrol(        ...
%     'Style'     , 'popup'     , ...
%     'Units'     , 'Pixels'    , ...
%     'visible','off',...
%     'String'    , dropDownListMMM(varListMMM),...
%     'Callback'  , @myPlotFcnMMM);
globalValuesH = uicontrol('Style', 'text',...
    'String', 'Global Values:',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'visible','off',...
    'FontWeight','bold');
textHeader0H = uicontrol('Style', 'text',...
    'String', 'Active CDF:',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'FontWeight','bold');
activeCdfH = uicontrol('Style', 'popupmenu',...
    'String', cdfList,...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'Callback', @activeCdfF);

textHeader1H = uicontrol('Style', 'text',...
    'String', 'CDF Attributes:',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'FontWeight','bold');
textHeader2H = uicontrol('Style', 'text',...
    'String', 'Variable Entry:',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'FontWeight','bold');
textHeader3H = uicontrol('Style', 'text',...
    'String', 'Slider Mode:',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'visible','on',...
    'FontWeight','bold');
runidH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
dataH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
dimensionsH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
dimensions2H = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
mmmPlotDataH = uicontrol('Style', 'text',...
    'String', 'MMM Plot Data:',...
    'visible','off',...
    'Units','Pixels',...
    'HorizontalAlignment','left',...
    'FontWeight','bold');
entryLabel1H = uicontrol('Style', 'text',...
    'String', '1)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryLabel2H = uicontrol('Style', 'text',...
    'String', '2)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryLabel3H = uicontrol('Style', 'text',...
    'String', '3)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryLabel4H = uicontrol('Style', 'text',...
    'String', '4)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryLabel5H = uicontrol('Style', 'text',...
    'String', '5)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryLabel6H = uicontrol('Style', 'text',...
    'String', '6)',...
    'Units','Pixels',...
    'HorizontalAlignment','left');
entryBoxH{1} = uicontrol('style', 'edit',...
    'string' , '','tag','1',...
    'enable','off',...
    'callback', {@entryLoadF});
entryBoxH{2} = uicontrol('style', 'edit',...
    'string' , '','tag','2', ...
    'enable','off',...
    'callback', {@entryLoadF});
entryBoxH{3} = uicontrol('style', 'edit',...
    'string' , '','tag','3', ...
    'enable','off',...
    'callback', {@entryLoadF});
entryBoxH{4} = uicontrol('style', 'edit',...
    'string' , '','tag','4', ...
    'enable','off',...
    'callback', {@entryLoadF});
entryBoxH{5} = uicontrol('style', 'edit',...
    'string' , '','tag','5', ...
    'enable','off',...
    'callback', {@entryLoadF});
entryBoxH{6} = uicontrol('style', 'edit',...
    'string' , '','tag','6', ...
    'enable','off',...
    'callback', {@entryLoadF});

% Create the sliderMode button group.
sliderModeH = uibuttongroup('visible','on','units','pixels','bordertype','none',...
    'SelectedObject',[],'SelectionChangeFcn',@sliderModeCB);
% Create the two sliderMode options.
sliderModeB1 = uicontrol('Style','radiobutton','String','Time','units','pixels',...
    'parent',sliderModeH,'visible','on','HandleVisibility','off','enable','off');
sliderModeB2 = uicontrol('Style','radiobutton','String','Position','units','pixels',...
    'parent',sliderModeH,'HandleVisibility','off','enable','off');
plotMinH2 = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'visible','off',...
    'HorizontalAlignment','left');
plotMinH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'visible','on',...
    'HorizontalAlignment','left');
plotMaxH2 = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'visible','off',...
    'HorizontalAlignment','left');
plotMaxH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'visible','on',...
    'HorizontalAlignment','left');
plotColH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'visible','off',...
    'HorizontalAlignment','left');
%     plotTimeH = uicontrol('Style', 'text',...
%        'Units','Pixels',...
%               'visible','off',...
%        'HorizontalAlignment','left');
toggleH = uicontrol('Style', 'pushbutton',...
    'string','Toggle Spreadsheet',...
    'enable','off',...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@plotToggleF});
% exportDataH = uicontrol('Style', 'pushbutton',...
%     'string','Export Figure',...
%     'Units','Pixels',...
%     'enable','off',...
%     'HorizontalAlignment','center',...
%     'callback',{@exportDataF});
openVarListH = uicontrol('Style', 'pushbutton',...
    'string','Open Variable List',...
    'Units','Pixels',...
    'enable','off',...
    'visible','off',...
    'HorizontalAlignment','center',...
    'callback',{@openVarListF});
varTitleH = uicontrol('Style', 'text',...
    'Units','Pixels',...
    'fontsize',11,...
    'fontweight','bold',...
    'visible','off',...
    'HorizontalAlignment','center');
systemMsgH = uicontrol('Style', 'text',...
    'string','',...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'fontsize',9,...
    'fontweight','bold');
%
% handles.radio(1) = uicontrol('Style', 'radiobutton', ...
%                            'Callback', @myRadio, ...
%                            'Units',    'pixels', ...
%                            'Position', [10, 10, 80, 22], ...
%                            'String',   'Time', ...
%                            'Value',    1);
% handles.radio(2) = uicontrol('Style', 'radiobutton', ...
%                            'Callback', @myRadio, ...
%                            'Units',    'pixels', ...
%                            'Position', [10, 40, 80, 22], ...
%                            'String',   'Position', ...
%                            'Value',    0);
% ...
% guidata(handles.FigureH, handles);
% function myRadio(RadioH, EventData)
% handles = guidata(RadioH);
% RadioH
% otherRadio = handles.radio(handles.radio ~= RadioH)
% set(otherRadio, 'Value', 0);
% end
%    labelStr = '<html>&#8704;&#946; <b>bold</b> <i><font color="red">label</html>';
% jLabel = javaObjectEDT('javax.swing.JLabel',labelStr);
% [hcomponent,hcontainer] = javacomponent(jLabel,[100,100,400,200],gcf);


% Set Background Color of relevant uicontrols
backgroundColorF('gray');
set(figH,'renderer','opengl','DefaultTextInterpreter','TeX')
% set(figH,'DefaultFigureInvertHardcopy','on');
set(0, 'DefaultFigureInvertHardcopy', 'on')
% set(0,'defaultFigurePaperUnits','pixels')%

%% Create UI Menu

fileMH = uimenu(figH,'Label','&File');
uimenu(fileMH,'Label','&Open CDF...',...
    'Callback',@openFileF);
%              uimenu(fileMH,'Label','Export Figure',...
%                         'Accelerator','E',...
%                         'Separator','On',...
%                         'Callback',@exportDataF);

exportFigureMH = uimenu(fileMH,'Label','Export &Figure','separator','on',...
    'Callback',@exportDataF);
exportTableMH = uimenu(fileMH,'Label','Export &Table','enable','off',...
    'Callback',@exportDataF);


editMH = uimenu(figH,'Label','&Edit');

plotModeMH = uimenu(editMH,'Label','&Plot Mode');
plotModeH{1} = uimenu(plotModeMH,'Label','&Line Plot','checked','on',...
    'Callback',@plotModeCB);
plotModeH{2} = uimenu(plotModeMH,'Label','&Surface Plot',...
    'Callback',@plotModeCB);
plotModeH{3} = uimenu(plotModeMH,'Label','&Heat Map',...
    'Callback',@plotModeCB);

rendererMH = uimenu(editMH,'Label','&Renderer');
rendererH{1} = uimenu(rendererMH,'Label','&OpenGL','checked','on',...
    'Callback',@rendererCB);
% rendererH{2} = uimenu(rendererMH,'Label','&Zbuffer',...
%     'Callback',@rendererCB);
rendererH{2} = uimenu(rendererMH,'Label','&Painters',...
    'Callback',@rendererCB);

% set(plotTitleH,'Editing','on')
% add label editability !


uimenu(editMH, 'Label', 'Title...','separator','on', 'Callback', @titlecallback);
uimenu(editMH, 'Label', 'X-axis label...', 'Callback', @xaxiscallback);
uimenu(editMH, 'Label', 'Y-axis label...', 'Callback', @yaxiscallback);

axisModeHM = uimenu(editMH,'Label','&Axes Boundary','separator','on');
axisModeH{1} = uimenu(axisModeHM,'Label','&Global','checked','on',...
    'tag','axisModeHM','Callback',@plotOptionsCB);
axisModeH{2} = uimenu(axisModeHM,'Label','&Local',...
    'tag','axisModeHM','Callback',@plotOptionsCB); %#ok<NASGU>

surfaceGridHM = uimenu(editMH,'Label','&Surface Style','visible','off','separator','on');
surfaceGridH{1} = uimenu(surfaceGridHM,'Label','&Surface Texture','checked','on',...
    'tag','surfaceGridHM','Callback',@plotOptionsCB);
surfaceGridH{2} = uimenu(surfaceGridHM,'Label','&Surface Grid',...
    'tag','surfaceGridHM','Callback',@plotOptionsCB);
surfaceGridH{3} = uimenu(surfaceGridHM,'Label','&Mesh Grid',...
    'tag','surfaceGridHM','Callback',@plotOptionsCB); %#ok<NASGU>

% colorModeHM = uimenu(editMH,'Label','&Color Mode');
% colorModeH{1} = uimenu(colorModeHM,'Label','&Default','checked','on',...
%     'tag','colorModeHM','Callback',@plotOptionsCB);
% colorModeH{2} = uimenu(colorModeHM,'Label','&Apple',...
%     'tag','colorModeHM','Callback',@plotOptionsCB); 
% colorModeH{3} = uimenu(colorModeHM,'Label','&Prism',...
%     'tag','colorModeHM','Callback',@plotOptionsCB); 
% colorModeH{4} = uimenu(colorModeHM,'Label','&Grayscale',...
%     'tag','colorModeHM','Callback',@plotOptionsCB); %#ok<NASGU>

colorMapHM = uimenu(editMH,'Label','&Color Map','visible','off');
colorMapH{1} = uimenu(colorMapHM,'Label','&Jet','checked','on',...
    'tag','colorMapHM','Callback',@plotOptionsCB);
colorMapH{2} = uimenu(colorMapHM,'Label','&Hsv',...
    'tag','colorMapHM','Callback',@plotOptionsCB); 
colorMapH{4} = uimenu(colorMapHM,'Label','&Bone',...
    'tag','colorMapHM','Callback',@plotOptionsCB); %#ok<NASGU>


axesBoxModeHM = uimenu(editMH,'Label','Axes &Box');
axesBoxModeH{1} = uimenu(axesBoxModeHM,'Label','O&n','checked','on',...
    'tag','axesBoxModeHM','Callback',@plotOptionsCB);
axesBoxModeH{2} = uimenu(axesBoxModeHM,'Label','O&ff',...
    'tag','axesBoxModeHM','Callback',@plotOptionsCB); %#ok<NASGU>

gridModeHM = uimenu(editMH,'Label','&Grid Lines');
gridModeH{1} = uimenu(gridModeHM,'Label','O&n','checked','on',...
    'tag','gridModeHM','Callback',@plotOptionsCB);
gridModeH{2} = uimenu(gridModeHM,'Label','O&ff',...
    'tag','gridModeHM','Callback',@plotOptionsCB); %#ok<NASGU>

legendLocationHM = uimenu(editMH,'Label','&Legend Position');
legendLocationH{1} = uimenu(legendLocationHM,'Label','&NorthEast','checked','on',...
    'tag','legendLocationHM','Callback',@plotOptionsCB);
legendLocationH{2} = uimenu(legendLocationHM,'Label','North&West',...
    'tag','legendLocationHM','Callback',@plotOptionsCB);
legendLocationH{3} = uimenu(legendLocationHM,'Label','South&East',...
    'tag','legendLocationHM','Callback',@plotOptionsCB);
legendLocationH{4} = uimenu(legendLocationHM,'Label','&SouthWest',...
    'tag','legendLocationHM','Callback',@plotOptionsCB);
legendLocationH{5} = uimenu(legendLocationHM,'Label','&Best',...
    'tag','legendLocationHM','Callback',@plotOptionsCB); %#ok<NASGU>


windowMH = uimenu(figH,'Label','&View');
uimenu(windowMH,'Label','&Variable List',...
    'separator','on','Callback',@openVarListF);
consoleMH = uimenu(windowMH,'Label','&Console',...
    'Callback',@openConsoleCB);

toolbarH = uitoolbar(figH);
% [X map] = imread(fullfile(...
%     matlabroot,'toolbox','matlab','icons','matlabicon.gif'));
% Convert indexed image and colormap to truecolor
% icon = ind2rgb(X,map);

addpath('cdfGui Files');
cData = load('icon_ZoomIn.mat');
zoomInH = uitoggletool(toolbarH,'tag','In','CData',cData.cdata,...
    'TooltipString','Toggle Zoom In',...
    'ClickedCallback',@zoomCB);
cData = load('icon_ZoomOut.mat');
zoomOutH = uitoggletool(toolbarH,'tag','Out','CData',cData.cdata,...
    'TooltipString','Reset Zoom Level',...
    'ClickedCallback',@zoomCB);

    function zoomCB(obj, event)
        zoom off;
        set(panH,'state','off');pan off;
        switch get(gcbo,'state')
            case 'on'
                switch get(gcbo,'tag')
                    case 'In'
                        
                        set(zoomOutH,'state','off');
                        
                        zoom on;
                        
                    case 'Out'
                        
                        set(zoomInH,'state','off');
                        set(zoomOutH,'state','off');
                        zoom out;
                end
                
        end
    end

cData = load('icon_Pan.mat');
  
panH = uitoggletool(toolbarH,'tag','Pan','CData',cData.cdata,...
    'TooltipString','Pan Toggle','separator','off','state','off',...
    'ClickedCallback',@panCB);

function panCB(obj,event)
set(zoomInH,'state','off');zoom off;

        switch get(gcbo,'state')
            case 'on'
                        
                        set(panH,'state','on');
                        pan on;
            case 'off'
             
                set(panH,'state','off');
                pan off;
        end
                        
end

cData = load('icon_PointValue.mat'); 
pointValueH = uipushtool(toolbarH,'tag','Point Value','CData',cData.cdata,...
    'TooltipString','Get Point Value','separator','off',...
    'ClickedCallback',@pointValueCB);
set(panH, 'state', 'off')
             
% plotEditH = uitoggletool(toolbarH,'tag','Plot Edit',...
%     'TooltipString','Toolbar push button','separator','on',...
%     'ClickedCallback',@plotEditCB);





cmenu = uicontextmenu();

% Define the context menu items
% colormapmenu = uimenu(cmenu, 'Label', 'Colormap');
lineColorMenu = uimenu(cmenu, 'Label', 'Line Color');
lineStyleMenu = uimenu(cmenu, 'Label', 'Line Style');
lineWidthMenu = uimenu(cmenu, 'Label', 'Line Thickness');
lineMarkerMenu = uimenu(cmenu, 'Label', 'Marker Style');
lineMarkerSizeMenu = uimenu(cmenu, 'Label', 'Marker Size');
lineMarkerFillMenu = uimenu(cmenu, 'Label', 'Marker Fill Color');

% uimenu(cmenu, 'Label', 'Toggle colorbar', 'Callback', @togglecolorbar);
% if exist('pixval.m')
%     % Only show this to those who have it installed...
%     uimenu(cmenu, 'Label', 'Toggle pixel values', 'Callback', 'pixval');
% end
% uimenu(cmenu, 'Label', 'Colormap length...', 'Callback', @colormaplength);
% uimenu(cmenu, 'Label', '3D plot...', 'Callback', @call3d);
% uimenu(cmenu, 'Label', 'Image limits...', 'Callback', @imagelimits);
% uimenu(cmenu, 'Label', 'Title...', 'Callback', @titlecallback);
% uimenu(cmenu, 'Label', 'X-axis label...', 'Callback', @xaxiscallback);
% uimenu(cmenu, 'Label', 'Y-axis label...', 'Callback', @yaxiscallback);

% Line Color Choices
uimenu(lineColorMenu, 'Label', 'Blue', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Green', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Red', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Purple', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Orange', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Yellow', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Brown', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Light Gray', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Dark Gray', 'Callback', @lineColorCB);
uimenu(lineColorMenu, 'Label', 'Black', 'Callback', @lineColorCB);

% Define line width choices
uimenu(lineWidthMenu, 'Label', '0.25', 'Callback', @lineWidthCB,'tag','0.2');
uimenu(lineWidthMenu, 'Label', '0.5', 'Callback', @lineWidthCB,'tag','0.5');
uimenu(lineWidthMenu, 'Label', '1.0', 'Callback', @lineWidthCB,'tag','1.0');
uimenu(lineWidthMenu, 'Label', '1.5', 'Callback', @lineWidthCB,'tag','1.5');
uimenu(lineWidthMenu, 'Label', '2.0', 'Callback', @lineWidthCB,'tag','2.0');
uimenu(lineWidthMenu, 'Label', '2.5', 'Callback', @lineWidthCB,'tag','3.0');
uimenu(lineWidthMenu, 'Label', '3.0', 'Callback', @lineWidthCB,'tag','5.0');
uimenu(lineWidthMenu, 'Label', '5.0', 'Callback', @lineWidthCB,'tag','5.0');

% Line Style Choices
uimenu(lineStyleMenu, 'Label', '-', 'Callback', @lineStyleCB);
uimenu(lineStyleMenu, 'Label', '--', 'Callback', @lineStyleCB);
uimenu(lineStyleMenu, 'Label', ':', 'Callback', @lineStyleCB);
uimenu(lineStyleMenu, 'Label', '-.', 'Callback', @lineStyleCB);
uimenu(lineStyleMenu, 'Label', 'none', 'Callback', @lineStyleCB);


uimenu(lineMarkerMenu, 'Label', 'none', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '+', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'o', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '*', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '.', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'x', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 's', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'd', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '^', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'v', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '>', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', '<', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'p', 'Callback', @lineMarkerCB);
uimenu(lineMarkerMenu, 'Label', 'h', 'Callback', @lineMarkerCB);


uimenu(lineMarkerSizeMenu, 'Label', '4', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '5', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '6', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '8', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '10', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '12', 'Callback', @lineMarkerSizeCB);
uimenu(lineMarkerSizeMenu, 'Label', '15', 'Callback', @lineMarkerSizeCB);

uimenu(lineMarkerFillMenu, 'Label', 'Blue', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Green', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Red', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Purple', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Orange', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Yellow', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Brown', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Light Gray', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Dark Gray', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'Black', 'Callback', @lineColorCB);
uimenu(lineMarkerFillMenu, 'Label', 'None', 'Callback', @lineColorCB);

% ,,[0.933 0.180 0.184],[0.4 0.173 0.569],[0.957 0.490 0.137],[251/255 184/255 39/255]
function lineColorCB(obj,event)
        plotNumber=get(figH,'userdata');
        switch get(gcbo,'label')
            case 'Blue'
                tempColor = [0.094 0.353 0.663];
            case 'Green'
                tempColor = [0 0.549 0.282];
            case 'Red'
                tempColor = [0.933 0.180 0.184];
            case 'Purple'
                tempColor = [0.4 0.173 0.569];
            case 'Orange'
                tempColor = [0.957 0.490 0.137];
            case 'Yellow'
                tempColor = [251/255 184/255 39/255];
            case 'Brown'
                tempColor = [151/255 84/255 39/255];
            case 'Light Gray'
                tempColor = [0.6 0.6 0.6];
            case 'Dark Gray'
                tempColor = [0.35 0.35 0.35];
            case 'Black'
                tempColor = [0 0 0];
            case 'None'
                tempColor = 'None';
        end
        switch get(get(gcbo,'parent'),'label')
            case 'Line Color'
                lineColor{plotNumber} = tempColor;
                set(linePlot{plotNumber},'Color',lineColor{plotNumber});
            case 'Marker Fill Color'
                lineMarkerFill{plotNumber} = tempColor;
                set(linePlot{plotNumber},'MarkerFaceColor',lineMarkerFill{plotNumber});
                
        end
        
    end
function lineMarkerSizeCB(obj,event)

 plotNumber=get(figH,'userdata');
    lineMarkerSize(plotNumber) = eval(get(gcbo,'label'));

    set(linePlot{plotNumber},'MarkerSize',lineMarkerSize(plotNumber));


end
function lineMarkerCB(obj,event)
plotNumber=get(figH,'userdata');
lineMarker{plotNumber} = get(gcbo,'label');
set(linePlot{plotNumber},'Marker',lineMarker{plotNumber});
end
function lineWidthCB(obj,event)

 plotNumber=get(figH,'userdata');
    lineWidth(plotNumber) = eval(get(gcbo,'label'));

    set(linePlot{plotNumber},'linewidth',lineWidth(plotNumber));


end
function lineStyleCB(obj,event)
    
     plotNumber=get(figH,'userdata');
    lineStyle{plotNumber} = get(gcbo,'label')
    set(linePlot{plotNumber},'lineStyle',lineStyle{plotNumber});
end
function lineCB(obj,event)
      
    set(figH,'userdata',eval(get(gcbo,'tag')));
    end
function plotEditCB(obj,event)
        switch get(gcbo,'state')
            case 'on'
                plotedit(axesH);
            case 'off'
                plotedit off;
        end
    end
function pointValueCB(obj, event)
    set(panH,'state','off');pan off;
    set(zoomInH,'state','off');zoom off;
    if ~isempty(varNameY{1})
    [x,y]=ginput(1);
    posY = ones(1,numel(varNameY))*10^(999);
    posX = ones(1,numel(varNameY))*10^(999);
                  posX = abs(varDataX{1}(:,sliderValue)-x)
            [indexX indexX] = min(posX)
            
    for j=1:numel(varNameY)
        if ~isempty(varNameY{j})
              posY(j) = abs(varDataY{j}(indexX,sliderValue)-y)
          

        end
    end
    [indexY indexY] = min(posY)
          
%             i = find(varDataY{j}(:,sliderValue)==x)
            valueY=varDataY{indexY}(indexX,sliderValue);
            valueX=varDataX{indexY}(indexX,sliderValue);
    systemMsgF(sprintf([varNameY{indexY},' = %g,   ',varNameX{indexY}, ' = %g '],valueY,valueX),'Msg');
    end
end

if testMode >0
movieMH = uimenu(figH,'Label','&Movie','Callback',@getcsv);
% OptionZ.FrameRate=15;OptionZ.Duration=5.5;OptionZ.Periodic=true;
%  CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10],'WellMadeVid2',OptionZ)
end
%              uimenu(fileMH,'Label','Toggle Plot/Spreadsheet', ...
%                           'Accelerator','T',...
%                           'Callback',@openDataFcn);
%     varListMH = uimenu(figH,'Label','Variable List',...
%                         'Callback',@openVarListF);
%
%                 uimenu(frh,'Label','Value...', ...
%                           'Callback','value');

%% Loading Splash Kiil

% --- Executes just before main is made visible.
    function main_OpeningFcn(hObject, eventdata, handles, varargin)
        % This function has no output args, see OutputFcn.
        % hObject    handle to figure
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        % varargin   command line arguments to main (see VARARGIN)
        
        % Choose default command line output for main
        handles.output = hObject;
        
        % If there is a splash screen for deployed version, kill it since this code
        % is now running and is MCR is no longer loading.
        if isdeployed
            if ~isempty(varargin)
                [pathToFile,nameOfFile,fileExt] = fileparts(varargin{1});
                nameOfExe=[nameOfFile,fileExt];
                dosCmd = ['taskkill /f /im "' nameOfExe '"'];
                dos(dosCmd);
            end
            
        end
        
        % Update handles structure
        guidata(hObject, handles);
    end

%% Splash Screen

if testMode == 0
    
    
    htmlStr = ['<html><br><div style="font-family:Arial, Helvetica, sans-serif;"><div style="font-size:24px;font-weight:bold;text-align:center;">CDF Viewer v1.06</div>'...
        '<div style="text-align:justify;margin-top:6px;margin-right:4px;text-align:center;">Created by Christopher Wilson<br>cwils16@u.rochester.edu</div>'...
        '<br><br><div style="text-align:justify;margin-left:8px;margin-right:4px;">Get started by opening a NetCDF file by using the above menu bar.  When entering in variables, the first variable is the ''primary variable'' that controls the plot axes and slider length '...
        'that all subsequent input variables use.  While all entered variables are plotted in ''Line Plot'' mode, only the primary variable is used in the ''Heat Map'' and ''Surface Plot'' plotting modes.</div>'...
        '<div style="text-align:justify;margin-left:8px;margin-right:4px;text-indent:16px">Variables may be removed from the plot by deleting their entries in their corresponding entry boxes.  Deleting the master variable resets the entire plot.'...
        ' A table of all variables within the CDF file may be found under the ''View'' user menu.  Selecting a cell on this table will automatically plot the data corresponding to the variable of the selected cell row.</div>' ...
        ...
        '<br><br><div style="font-size:12px;font-weight:bold;text-align:left;margin-left:5px;margin-bottom:5px;">Update Log:</div>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.06]</div>'...
        '<table style="margin-bottom:8px">'...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Support for multiple CDF plotting added. </td></tr>' ...
        '</table>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.05]</div>'...
        '<table style="margin-bottom:8px">'...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;"> Toolbar added with four plotting tools: Zoom In, Zoom Reset, Panning, Point Value.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Several bug fixes. </td></tr>' ...
        '</table>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.04]</div>'...
        '<table style="margin-bottom:8px"><tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Slider control optimized.  Line plots now update many times faster than before, allowing for a movie-like playback when the slider arrow is held down. </td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Console window now available.  Additional parameters may now be set by advanced MATLAB users via the command line.  Additionally, five global dummy variables created for general use/testing: dummy1,dummy2,...,dummy5. </td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Variable list table optimized and sorting of columns enabled. </td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Additional entry box added to main interface, allowing for a total of six variables to be entered simultaneously.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Color options added to all plot modes; additional surface plotting options added.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Figure export now opens the figure after the export process is complete.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Gradient calculations updated for improved accuracy.  Gradient smoothing options now availble.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Plot titles and axis labels now editable.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Various variable loading and plotting optimizations.  More information is preloaded from each CDF and several redundant processes have been removed.</td></tr>' ...
        '</table>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.03]</div>'...
        '<table style="margin-bottom:8px"><tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Gradient calculations enabled.  When entering a variable in an entry box, place ''*X'' at the end of the name to take a partial derivative with respect to position.  Placing ''*T'' after the variable name takes a partial derivative with respect to time.  A normalized gradient may be taken using the syntax ''*G'' at the end of a variable name.  E.g., entering ''NE*G'' gives the normalized gradient of the electron density.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">New plotting modes added.  Single variables may be plotted as a two-dimensional ''Heat Map'' or a three-dimensional ''Surface Plot''.  In ''Surface Plot'' mode, the mouse cursor changes and can be used to rotate the figure.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Table modes added. Table data now reflects only what is represented by the corresponding figure in plot mode.  For a standard ''Line Plot'', the table now only lists local time/position slices of data for each entered varaible, allowing for easy export of each data vector.  Additionally, the slider and slider mode buttons are now active in the table view, and may be used to adjust the current data position.  For ''Heat Map'' and ''Surface Plot'' modes, the table lists all values of the associated variable. </td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Data export overall.  Tables now export comma separated files (.csv), which are more stable and save faster than the previous excel format.  Figures now export as .eps files, and all user controls are hidden in the export.  Also, exported files will no longer overwrite a saved file name; they instead create a numbered copy of the file. </td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Export stability.  Errors encountered during the export process are caught and noted by the system, curtailing any lockups that may prevously have occured.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Hotkeys updated. CTRL hotkeys removed and replaced with ALT keys for the user menu.  Pressing ALT once will underline the keyboard keys that may be used to open each of the menu items. E.g., the sequential key-combination ''ALT, F, F'' (without the comma''s) provides a quick way to export a figure when in plot mode.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Zbuffer rendering option removed.  It was found to be extremely unstable when viewing a surface plot.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Grid options. The axis grid may now be turned off when in ''Line Plot'' mode.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Various interface tweaks.  Export button moved to user menu under ''File'', and the variable list option was moved to the ''Window'' menu.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Additional core code structure improvements, further reducing memory leakage.</td></tr>' ...
        '</table>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.02]</div>'...
        '<table style="margin-bottom:8px"><tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Line smoothing applied to the graphical output (OpenGL rendering), resulting in a drastically improved plotting appearance.  OpenGL is momentarily disabled when exporting a figure so that the exported image quality is preserved.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">''Slider Mode'' added; two-dimensional variables may now be plotted as functions of time at specific position intervals that are set using the slider.<br> (Try plotting ''TE'' vs ''TE0''.)</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Boundary options for axes limits added to ''Edit'' menu.  Global mode fixes each axis over the entire slider range, and Local mode updates the y-axis for each slider value.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Legend positioning options added to ''Edit'' menu.  ''Best'' mode keeps the legend away from the plot lines.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Graphics rendering options added.  In the rare event that OpenGL fails to render a plot, switching the renderer to a different engine should fix the error.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Fixed several crashing errors when plotting variables that differ in dimension size.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Major code structure overhaul, resulting in some memory and performance enhancements.</td></tr>' ...
        '</table>'...
        '<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[Version 1.01]</div>'...
        '<table><tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">''Load Variable List'' and ''Open CDF'' buttons moved to menu bar.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Increased number of variables available for plotting to five.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Added shortcut keys.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Removal of variables from plot by submitting a blank entry into the corresponding entry box.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Figures now export with a white background and updated filename.</td></tr>' ...
        '<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">•</td><td style="margin:0px;padding:0px;">Various interface tweaks.</td></tr>' ...
        ...
        '<br>&nbsp;'...
        ...
        ];
    
setSplashF(htmlStr,1) % Places htmlStr in the splash text container
    
else % Test mode commands
%     commandBoxH = uicontrol('style', 'edit',...
%         'string' , '','tag','6', ...
%         'enable','on',...
%         'callback', {@commandBoxCB});
     openFileF(cdfPath,1);
 
    
end

    function setSplashF(inputString,counter)
       
        try
            jScrollPane = findjobj(splashH);
            jViewPort = jScrollPane.getViewport;
            jEditbox = jViewPort.getComponent(0);
            % jEditbox.setEditorKit(javax.swing.text.html.HTMLEditorKit);
            jEditbox.setContentType('text/html');
            jEditbox.setText(inputString);
            % jEditbox.setPage('C:\Users\chw813\Documents\MATLAB\splash.txt');
            %  fP = get(figH, 'Position');
            % jLabel = javaObjectEDT('javax.swing.JLabel',htmlStr);
            % [hcomponent,hcontainer] = javacomponent(jLabel,[70      , 84, fP(3)-245, fP(4)-135],gcf);
            % set(updateLogH,'style','text');
        catch
            disp(['failed to find splash table (',counter,')'])
            if counter<=10 % Try up to 10 times to find the splash table
                counter=counter+1;
                setSplashF(inputString,counter)
            end
        end
    end
% % jScrollBar2 = findjobj(sliderH);
% % set(jScrollBar2,'AdjustmentValueChangedCallback',@sliderF)
%% Critical Functions

     function openFileF(hObj,event)
        
        % Select CDF to load
        if event
            tempName = hObj;
            filePath = tempName;
            tempPath='';
        else
            [tempName,tempPath,~] = uigetfile('.CDF','Select CDF to load');
        end
        if isequal(tempName,0)
            return
        else
        systemMsgF('Loading CDF ...','Msg');
            filePath = [tempPath,tempName];
        
            for activeCdf = 1:numel(cdfList)
                if isempty(cdfList{activeCdf})
                    cdfList{activeCdf} = tempName;
                    set(activeCdfH,'string',cdfList);
                    break
                end
            end
            
            % Load CDF related variables
            ncid{activeCdf} = netcdf.open(filePath,'NC_NOWRITE');
            varid{activeCdf} = netcdf.getConstant('NC_GLOBAL');
            finfo{activeCdf} = ncinfo(filePath);
            % finfo{activeCdf} is the biggest bottleneck in the file loading process, is it possible to
            % write this code without having to set this variable?
            
            if ncid{activeCdf}
                
                set(splashH,'visible','off');
                
                set(tableH,'visible','off');
                
                set(exportFigureMH,'enable','on');
                set(openVarListH,'enable','on');
                set(toggleH,'enable','on');
                set(entryBoxH{1},'enable','on');
                set(entryBoxH{2},'enable','on');
                set(entryBoxH{3},'enable','on');
                set(entryBoxH{4},'enable','on');
                set(entryBoxH{5},'enable','on');
                set(entryBoxH{6},'enable','on');
                set(sliderModeB1,'enable','on');
                set(sliderModeB2,'enable','on');
                set(axesH,'visible','on');
                
                

                % Retrieve Full List of TRANSP Variables from CDF File
                varListTRANSP = {finfo{activeCdf}.Variables.Name};
             
                % Initialize Plot Values
%                 [varNameT{1},varDataT{1},~,varUnitsT{1}] = loadVarF('TIME');
                
                plotToggle = 'Figure';
                
                % Initialize the sliderValue
                sliderValue = 1;
%                 [sliderMax,~] = size(varDataT{1});
                
                set(sliderH,'Max', sliderMax         ,...
                    'Value'     , sliderValue,...
                    'sliderStep',[1/sliderMax 10/sliderMax]);
                try
                set(runidH,'String', ['RunID = ',num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))]);
                set(dataH,'String', ['Date = ',netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'CDF_date')]);
                set(dimensionsH,'String', inqDimidF('X'));
                set(dimensions2H,'String', inqDimidF('TIME'));
                set(activeCdfH,'value',activeCdf);
%                 set(varTitleH,'string','');
                %     cla reset;
                % Clear Everything
%                 set(tableH,'data',[]);
%                 set(varTitleH,'string','');
%                 set(sliderH,'enable','off');
                
%                 for j=1:numel(varNameY)
% %                     varNameY{j} ={};
% %                     varLabelY{j} = {};
% %                     varUnitsY{j} = {};
% %                     varDataY{j} =[];
%                     set(entryBoxH{j},'string','');
%                 end
                systemMsgF(['File ',tempName,' successfully loaded'],'Msg');

                
                [cdfNameR{1}, cdfDataR{1}, cdfLabelR{1}, cdfUnitsR{1}] = loadVarF('RAXIS');
                [cdfNameR{2}, cdfDataR{2}, cdfLabelR{2}, cdfUnitsR{2}] = loadVarF('RZON');
                [cdfNameR{3}, cdfDataR{3}, cdfLabelR{3}, cdfUnitsR{3}] = loadVarF('RBOUN');
                [cdfNameR{4}, cdfDataR{4}, cdfLabelR{4}, cdfUnitsR{4}] = loadVarF('X');
                [cdfNameR{5}, cdfDataR{5}, cdfLabelR{5}, cdfUnitsR{5}] = loadVarF('XB');
                
             
                catch  
                    systemMsgF(['Error: Failed to load file',tempName,'. Please check that this is a valid .CDF file.'],'Error');
                end
            end
%             cla reset;
%             set (plotMinH, 'string','');
%             set (plotMaxH, 'string','');
%             if  strcmp(plotToggle,'Table') %avoids bugs due to cla command
%                 set(axesH,'visible','off');
%             end
            if testMode == 2
                entryLoadF('NE',1)
            end
        end % isequal(tempName,0)
     end

    function activeCdfF(hObj, evt) 
        
        tempValue = get(gcbo,'value');
        if ~isempty(ncid{tempValue})
            activeCdf = tempValue;
        set(runidH,'String', ['RunID = ',num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))]);
        set(dataH,'String', ['Date = ',netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'CDF_date')]);
        set(dimensionsH,'String', inqDimidF('X'));
        set(dimensions2H,'String', inqDimidF('TIME'));
        else
           
           if isempty(activeCdf)
               tempValue = 1;
           else 
               tempValue = activeCdf;
           end
            set(activeCdfH, 'value', tempValue);
        end
                for jj=1:numel(linePlot)
                    if ishandle(linePlot{jj})
                        if strcmp(cdfList{activeCdf},varCdfName{jj})
                            currentCdf = jj;
                        end
                    end
                end
                
                                switch sliderMode
                            case 'Time'
                                [sliderMax,~] = size(varDataT{currentCdf});%Slider Depends on first variable only
                            case 'Position'
                                [sliderMax,~] = size(varDataX{currentCdf});%Slider Depends on first variable only
                        end
                        if sliderValue>sliderMax
                            sliderValue=1;
                        end
                        if sliderMax<=1
                            [rowSize,~]=size(cdfDataR{currentCdf});
                            sliderMax=rowSize;
                        end
                    
                   
                    set(sliderH,'max',sliderMax,'sliderStep',[1/sliderMax 10/sliderMax],'value',sliderValue,'enable','on');
    end
    function entryLoadF(hObj, evt)
        %% Load CDF variable dated based on text box entry
        % Data stored in CDF file located at filePath
% % %                 %%%%%%%
% % % %         varDataM = [0,1.71444397200000,1.43648738500000,4.52000000000000e+19,3.77000000000000e+19,6.68000000000000e+17,3.47000000000000e+18,1.44558890300000,4.08755433300000,4.91924790900000,1.27936105200000,1.87945619500000,6.03739107800000,11.9911208500000,1.95176891400000,2.12656725900000,0,0.0100000000000000,-0.0978880480000000,-0.100158663000000,0.0296199810000000,-0.0100000000000000,-0.0100000000000000,0.794816271000000,0.283914117000000,296030.253000000,-100,3831.17156200000,0.281308219000000,296035.946100000;0.0121098980000000,1.71441695100000,1.43397578600000,4.52000000000000e+19,3.77000000000000e+19,6.68000000000000e+17,3.42000000000000e+18,1.44525184800000,4.08736337900000,4.89133383600000,1.27871161800000,1.87948581800000,6.03732296400000,11.9909855700000,1.95150807800000,2.12596759400000,16725.2760200000,0.143051603000000,-0.100523275000000,-0.105752515000000,0.366225600000000,-0.131064454000000,0.0145695680000000,0.813718749000000,0.304152608000000,295962.546200000,66.4967444900000,7409.01166000000,0.301510721000000,295969.377900000;0.0242468660000000,1.71441810400000,1.43070040500000,4.51000000000000e+19,3.78000000000000e+19,6.65000000000000e+17,3.34000000000000e+18,1.44440279300000,4.08651533600000,4.86276267400000,1.27676726600000,1.87948455300000,6.03712224100000,11.9905869000000,1.95095496500000,2.12471013700000,11010.0440100000,0.276529656000000,-0.100898724000000,-0.106617043000000,0.631203650000000,-0.286251413000000,0.0406465910000000,0.838632534000000,0.363508983000000,295748.572100000,100,684.290523800000,0.360787800000000,295759.376800000;0.0364048520000000,1.71437046100000,1.42789853800000,4.50000000000000e+19,3.77000000000000e+19,6.62000000000000e+17,3.31000000000000e+18,1.44337274400000,4.08444722700000,4.83297144500000,1.27298596000000,1.87953678500000,6.03679626500000,11.9899394700000,1.95044854200000,2.12367071500000,9860.06417100000,0.393823673000000,0.459102096000000,0.453424198000000,0.706805792000000,-0.519846396000000,0.0923987370000000,0.886150628000000,0.459586444000000,295342.162400000,5.76371473800000,-1325.80672500000,0.456790952000000,295359.063100000;0.0485847640000000,1.71428721900000,1.42518093600000,4.49000000000000e+19,3.76000000000000e+19,6.59000000000000e+17,3.34000000000000e+18,1.44250094900000,4.08058925500000,4.80139035400000,1.26680066800000,1.87962805100000,6.03635298200000,11.9890590400000,1.95005418400000,2.12309128400000,2534.06928100000,0.498460825000000,0.681458482000000,0.682703524000000,0.710312157000000,-0.806653359000000,0.163889894000000,0.929955343000000,0.589058390000000,294663.840500000,0.371485843000000,-1229.34797900000,0.586243809000000,294688.062100000;0.0607791170000000,1.71418223200000,1.42281517000000,4.47000000000000e+19,3.74000000000000e+19,6.56000000000000e+17,3.37000000000000e+18,1.44213260300000,4.07436671400000,4.76744469400000,1.25762054100000,1.87974317100000,6.03580144600000,11.9879636100000,1.94960794900000,2.12268435500000,2001.01687900000,0.591343900000000,0.671757001000000,0.673516195000000,0.633264769000000,-1.34116730300000,0.255431219000000,1.23956482000000,0.747325024000000,293624.630900000,6.98001650800000,-1229.43558400000,0.744598874000000,293657.029800000;0.0729821590000000,1.71406306600000,1.42081627200000,4.45000000000000e+19,3.72000000000000e+19,6.54000000000000e+17,3.36000000000000e+18,1.44261891900000,4.06520863800000,4.70694839700000,1.24416912600000,1.87987385600000,6.03515285800000,11.9866754300000,1.94907814400000,2.12237222200000,16490.3774800000,0.671956615000000,0.616939613000000,0.631832709000000,0.387130503000000,-1.68744257800000,0.367104810000000,1.93873537100000,0.928726791000000,292143.950800000,10.8153002600000,-1153.94500900000,0.926228789000000,292184.918900000;0.0851943300000000,1.71393833600000,1.41899160800000,4.43000000000000e+19,3.70000000000000e+19,6.53000000000000e+17,3.30000000000000e+18,1.44432051600000,4.05254523700000,4.64110474900000,1.22917578900000,1.88001066100000,6.03442161200000,11.9852230700000,1.94857217900000,2.12240611200000,8662.94498500000,0.739955941000000,0.618118761000000,0.629553019000000,0.0155391240000000,-1.70413110600000,0.499214226000000,2.06993437100000,1.12699407300000,290166.574000000,6.32557980600000,-1055.61269100000,1.12483443800000,290215.602300000;0.0974223600000000,1.71381201100000,1.41707848200000,4.40000000000000e+19,3.69000000000000e+19,6.54000000000000e+17,3.22000000000000e+18,1.44760894400000,4.03580130000000,4.57026288300000,1.21426379200000,1.88014923700000,6.03362550800000,11.9836418900000,1.94808722800000,2.12301231900000,3279.07246300000,0.795060453000000,0.620974502000000,0.640706326000000,-0.477686417000000,-1.70208984600000,0.651976133000000,2.24519738700000,1.33573204000000,287673.800200000,6.39057972400000,-1010.47517300000,1.33394397700000,287729.343600000;0.109671347000000,1.71368199400000,1.41497916600000,4.38000000000000e+19,3.67000000000000e+19,6.58000000000000e+17,3.12000000000000e+18,1.45286554100000,4.01440622600000,4.49460795400000,1.20005382200000,1.88029188400000,6.03278607500000,11.9819746600000,1.94760513400000,2.12439217900000,7502.92261100000,0.837188188000000,0.703533122000000,0.735044692000000,-1.08521494800000,-1.64157376000000,0.826144118000000,2.42725204000000,1.54873939300000,284680.008000000,6.69857495200000,-964.135204100000,1.54729840600000,284740.187000000;0.121939825000000,1.71354204500000,1.41279251600000,4.35000000000000e+19,3.65000000000000e+19,6.65000000000000e+17,3.02000000000000e+18,1.46048296900000,3.98778560800000,4.41402616700000,1.18616399400000,1.88044545100000,6.03192858600000,11.9802715600000,1.94714911400000,2.12675304800000,9557.24156200000,0.866541874000000,0.766786340000000,0.814011337000000,-1.79655618000000,-1.61820516400000,1.02331712100000,2.62575212000000,1.76136022200000,281217.024100000,-3.46225661400000,-928.362278800000,1.76020874700000,281279.217800000;0.134224680000000,1.71339041300000,1.41061113300000,4.32000000000000e+19,3.63000000000000e+19,6.76000000000000e+17,2.90000000000000e+18,1.47086428300000,3.95536449400000,4.32832553800000,1.17346094900000,1.88061186800000,6.03108072000000,11.9785875800000,1.94668490300000,2.13019547500000,12102.8383100000,0.877399275000000,0.785961151000000,0.848879062000000,-2.59575333400000,-1.41668044600000,1.24471011500000,2.84250228400000,1.97010485700000,277332.345600000,-4.38696502800000,-959.002424600000,1.96914977100000,277393.524800000;0.146523141000000,1.71322696500000,1.40852505200000,4.30000000000000e+19,3.61000000000000e+19,6.91000000000000e+17,2.76000000000000e+18,1.48442115100000,3.91657247800000,4.23730243300000,1.16321258500000,1.88079128400000,6.03027102000000,11.9769794000000,1.94614066000000,2.13479966000000,22583.8592900000,0.882859193000000,0.809173078000000,0.890945677000000,-3.46315774700000,-1.06655106300000,1.49227759600000,3.07892314700000,2.17263765400000,273086.313200000,-3.95243357100000,-988.299955400000,2.17172690600000,273143.076400000;0.158829486000000,1.71305148200000,1.40663647900000,4.27000000000000e+19,3.58000000000000e+19,7.11000000000000e+17,2.61000000000000e+18,1.50157158500000,3.87083445400000,4.14080880900000,1.15554982400000,1.88098395000000,6.02952745100000,11.9755025700000,1.94553785600000,2.14083391800000,31966.5313200000,0.876909415000000,0.907133818000000,1.01306248600000,-4.37743323700000,-0.751445967000000,1.76916363500000,3.33496846400000,2.36813223300000,268540.404600000,30.9339946300000,-891.687215300000,2.36702094100000,268589.166700000;0.171134997000000,1.71286385500000,1.40504515200000,4.24000000000000e+19,3.55000000000000e+19,7.37000000000000e+17,2.47000000000000e+18,1.52273754100000,3.81758041800000,4.03879719000000,1.15018393100000,1.88118999300000,6.02887496400000,11.9742066300000,1.94495979600000,2.14866431000000,34701.6474500000,0.853911779000000,1.05702053300000,1.18919967300000,-5.31360326000000,-0.588109783000000,2.07842564200000,3.61209909500000,2.55729375400000,263749.356600000,56.3414660300000,-658.540650400000,2.55568804600000,263789.990300000;0.183432164000000,1.71266589300000,1.40381512500000,4.22000000000000e+19,3.52000000000000e+19,7.68000000000000e+17,2.35000000000000e+18,1.54833822600000,3.75623989900000,3.93124472600000,1.14640651100000,1.88140743500000,6.02833354700000,11.9731313000000,1.94446321900000,2.15856013800000,36683.7487400000,0.816990930000000,1.16316987600000,1.32586078500000,-6.24893371100000,-0.294001779000000,2.42520623200000,3.91111286200000,2.74214552800000,258752.584400000,94.0389329700000,-382.171343300000,2.73992853300000,258792.737200000;0.195709163000000,1.71246345800000,1.40295720700000,4.19000000000000e+19,3.49000000000000e+19,8.06000000000000e+17,2.23000000000000e+18,1.57878784900000,3.68623832900000,3.81830976300000,1.14752098100000,1.88162984100000,6.02791719200000,11.9723043600000,1.94403853200000,2.17068405000000,41058.3911300000,0.765965478000000,1.23934485000000,1.43444489700000,-7.15916086100000,0.398707578000000,2.81432232400000,4.22638625600000,2.92541293700000,253573.993300000,100,-147.035787500000,2.92285315800000,253623.250800000;0.207962475000000,1.71224979600000,1.40244130300000,4.17000000000000e+19,3.45000000000000e+19,8.52000000000000e+17,2.11000000000000e+18,1.61448851800000,3.60700483100000,3.70024601300000,1.15274746100000,1.88186463900000,6.02763315200000,11.9717402200000,1.94362948300000,2.18519255700000,46362.0986900000,0.699792721000000,1.31736764300000,1.54867762600000,-8.01991069400000,0.883387044000000,3.25078975700000,4.55900694000000,3.11010877200000,248221.667300000,-100,34.5063582500000,3.10775058400000,248282.676200000;0.220186533000000,1.71201981900000,1.40230537800000,4.15000000000000e+19,3.41000000000000e+19,9.05000000000000e+17,1.99000000000000e+18,1.65582214700000,3.51796437600000,3.57725274600000,1.16235632000000,1.88211743200000,6.02748176900000,11.9714395500000,1.94319242100000,2.20230794600000,53378.1844900000,0.618509262000000,1.41419947700000,1.68655978400000,-8.81506641700000,1.42269609700000,3.74461910800000,4.91666523300000,3.29896332000000,242699.126500000,-100,224.272204600000,3.29735782500000,242769.398200000;0.232375088000000,1.71176929800000,1.40268704800000,4.14000000000000e+19,3.37000000000000e+19,9.66000000000000e+17,1.88000000000000e+18,1.70314465600000,3.41854283700000,3.44948449700000,1.17659278200000,1.88239288300000,6.02745763500000,11.9713916100000,1.94275702900000,2.22235945100000,58690.4853200000,0.521899528000000,1.53456864000000,1.85323473100000,-9.53910703000000,1.94249021800000,4.31368482400000,5.30723897700000,3.49422654700000,237008.961300000,-76.2845199400000,484.902028800000,3.49381806200000,237086.108300000;0.244515225000000,1.71149687900000,1.40372370900000,4.12000000000000e+19,3.32000000000000e+19,1.04000000000000e+18,1.78000000000000e+18,1.75677385700000,3.30834024900000,3.31710818200000,1.19567691900000,1.88269250300000,6.02755041700000,11.9715758900000,1.94240651300000,2.24574846100000,62498.4713800000,0.409669416000000,1.67119683200000,2.04138892500000,-10.2033518900000,2.63855756000000,4.94625194100000,5.73326510400000,3.69740404400000,231157.095400000,-51.4914452100000,780.209240000000,3.69856585800000,231240.565400000;0.256599357000000,1.71119036700000,1.40544583600000,4.11000000000000e+19,3.27000000000000e+19,1.12000000000000e+18,1.69000000000000e+18,1.81695424700000,3.18798372200000,3.18033056100000,1.22121169500000,1.88302973500000,6.02774175700000,11.9719559200000,1.94215258700000,2.27277633800000,59175.1674400000,0.281361146000000,1.74561611600000,2.20118182500000,-10.7772260200000,3.29161526200000,5.58642023400000,6.20100739500000,3.90935869100000,225148.166000000,100,224.830164300000,3.91246745600000,225238.858500000;0.268613391000000,1.71083965900000,1.40778748200000,4.11000000000000e+19,3.22000000000000e+19,1.20000000000000e+18,1.60000000000000e+18,1.88337520100000,3.05920672400000,3.03930479700000,1.25142301000000,1.88341574100000,6.02795532300000,11.9723800900000,1.94178248800000,2.30323417700000,61648.7242100000,0.135607174000000,1.76595618100000,2.24218557700000,-11.1201151700000,3.71009633200000,6.20725186300000,6.74165548700000,4.13013910900000,218992.258500000,-100,-3208.16997000000,4.13555568900000,219087.696900000;0.280543776000000,1.71043997200000,1.41068871400000,4.10000000000000e+19,3.17000000000000e+19,1.30000000000000e+18,1.51000000000000e+18,1.95477018300000,2.92400830100000,2.89413383300000,1.28595253500000,1.88385584800000,6.02811307200000,11.9726934100000,1.93216143200000,2.32787703200000,71373.4538000000,-0.0230497610000000,1.74513851500000,2.27519774400000,-11.1483651700000,4.09966468100000,6.80835909600000,7.37640173400000,4.35923517400000,212702.698200000,79.1141029100000,-5109.64646300000,4.36702619900000,212788.814800000;0.292378047000000,1.70998428300000,1.41413260300000,4.11000000000000e+19,3.12000000000000e+19,1.40000000000000e+18,1.41000000000000e+18,2.02942982700000,2.78440139700000,2.74613598700000,1.32450990100000,1.88435787200000,6.02821137900000,11.9728886600000,1.92285961900000,2.35528911300000,71885.3662500000,-0.179927403000000,1.67008992600000,2.23954275100000,-10.9300468000000,4.40900940900000,7.38970069300000,7.77882653700000,4.59586038700000,206297.190400000,100,-1848.91749500000,4.60547965600000,206354.829400000;0.304102342000000,1.70947002900000,1.41815804400000,4.11000000000000e+19,3.08000000000000e+19,1.51000000000000e+18,1.31000000000000e+18,2.10567929800000,2.64238890400000,2.59991106600000,1.36687272800000,1.88492473600000,6.02827256000000,11.9730101700000,1.92320583000000,2.39372907100000,62720.8942900000,-0.325736489000000,1.61471397400000,2.21335107800000,-10.5335180600000,4.80482895000000,7.93575771900000,8.18515767700000,4.83913197100000,199800.010100000,-100,1234.77145000000,4.84955788500000,199821.486000000;0.315709484000000,1.70888639400000,1.42280459200000,4.13000000000000e+19,3.03000000000000e+19,1.62000000000000e+18,1.22000000000000e+18,2.18188608000000,2.49997027100000,2.46105662600000,1.41414266000000,1.88556849400000,6.02831381900000,11.9730921200000,1.92341644100000,2.43319102100000,64046.8810200000,-0.460242380000000,1.56957119800000,2.18927215400000,-9.93521312200000,5.15825855000000,8.38501801100000,8.09809692100000,5.08832824400000,193236.393200000,20.7977988000000,1634.39176800000,5.09843105100000,193226.303000000;0.327192765000000,1.70822029900000,1.42806568900000,4.14000000000000e+19,2.99000000000000e+19,1.73000000000000e+18,1.15000000000000e+18,2.25646621500000,2.35914987200000,2.33181899100000,1.46502141000000,1.88630374300000,6.02834786900000,11.9731597500000,1.92349156100000,2.47297691100000,67998.8586400000,-0.584420704000000,1.49641399500000,2.12752175300000,-9.30967540800000,5.37633973100000,8.87715998100000,7.98448887300000,5.34171093100000,186633.630900000,24.7387755200000,1404.96672200000,5.35052035000000,186599.757200000;0.338540271000000,1.70746884500000,1.43391338600000,4.16000000000000e+19,2.95000000000000e+19,1.83000000000000e+18,1.09000000000000e+18,2.32789185300000,2.22193498400000,2.21195857200000,1.51960655500000,1.88713390200000,6.02838578100000,11.9732350500000,1.92343264100000,2.51214311200000,69264.2614300000,-0.697430419000000,1.33475282000000,1.96013575300000,-8.66920830700000,5.61678136700000,9.22614887500000,7.88459389700000,5.59510345700000,180022.611500000,29.4828191700000,1174.05784200000,5.60193333700000,179971.861600000;0.349754608000000,1.70661861600000,1.44030729400000,4.18000000000000e+19,2.91000000000000e+19,1.94000000000000e+18,1.03000000000000e+18,2.39468819200000,2.09032936100000,2.10103427500000,1.57799544800000,1.88807406300000,6.02843581200000,11.9733344100000,1.92324223100000,2.54953131500000,70428.4916800000,-0.799068742000000,1.06606395100000,1.66417081600000,-7.89037560200000,5.81171787900000,9.43719529000000,7.76162586500000,5.84286662300000,173424.712800000,35.8148998200000,948.953284600000,5.84735657300000,173362.560900000;0.360827867000000,1.70566624000000,1.44721768700000,4.20000000000000e+19,2.89000000000000e+19,2.03000000000000e+18,9.58000000000000e+17,2.45544760600000,1.96633245000000,1.99860135200000,1.64028516200000,1.88912828800000,6.02850449000000,11.9734708200000,1.92293132500000,2.58399519600000,73304.5979300000,-0.889571360000000,0.743583036000000,1.29525744200000,-7.05609671100000,6.12334500000000,9.48151666500000,7.62033239100000,6.07799329200000,166864.923400000,42.7888874800000,737.368234100000,6.08005847300000,166796.086600000;0.371754469000000,1.70460831600000,1.45461961400000,4.23000000000000e+19,2.87000000000000e+19,2.12000000000000e+18,8.85000000000000e+17,2.50884284800000,1.85195253800000,1.90418539500000,1.70826919700000,1.89030073000000,6.02859793200000,11.9736564100000,1.92251823300000,2.61452389600000,76194.7914600000,-0.968313209000000,0.403917095000000,0.891519115000000,-6.16220583200000,6.47572201300000,9.30074560400000,7.46200312200000,6.29296623800000,160363.522500000,53.1156252000000,543.953320000000,6.29276415700000,160294.429300000;0.382528164000000,1.70344303900000,1.46250872900000,4.25000000000000e+19,2.85000000000000e+19,2.20000000000000e+18,8.12000000000000e+17,2.55361710800000,1.74919297700000,1.81728002800000,1.78100812900000,1.89159383100000,6.02872246800000,11.9739037500000,1.92202001800000,2.64015992100000,77814.5273700000,-1.03610174300000,0.0393400370000000,0.444627077000000,-5.20519577900000,6.70782296900000,8.83186395900000,7.29253227100000,6.47976817200000,153936.314400000,73.5922004600000,366.826361000000,6.47782354800000,153876.575700000;0.393139590000000,1.70217052300000,1.47090607000000,4.28000000000000e+19,2.85000000000000e+19,2.26000000000000e+18,7.40000000000000e+17,2.58857771500000,1.66006054000000,1.73738808700000,1.85884450800000,1.89300795700000,6.02888510600000,11.9742267800000,1.92144720700000,2.65992519600000,78681.4080100000,-1.09254113800000,-0.368140440000000,-0.0649999770000000,-4.17468982700000,6.98133311600000,7.98253851300000,7.11257157800000,6.62849259500000,147594.803800000,100,202.471403200000,6.62575979900000,147553.654800000;0.403581313000000,1.70079218300000,1.47984460200000,4.31000000000000e+19,2.86000000000000e+19,2.31000000000000e+18,6.70000000000000e+17,2.61259880800000,1.58621562400000,1.66402823200000,1.94223776300000,1.89454207100000,6.02909281100000,11.9746393100000,1.92080539800000,2.67287659300000,79247.0991300000,-1.13665281400000,-0.820751364000000,-0.639596947000000,-3.05152738300000,7.24002262900000,6.79768390900000,6.92057341900000,6.72661128400000,141351.323200000,100,48.7164221900000,6.72428818000000,141332.747400000;0.413848808000000,1.69930843300000,1.48934965000000,4.34000000000000e+19,2.87000000000000e+19,2.34000000000000e+18,6.02000000000000e+17,2.62460509900000,1.52716104800000,1.59669322900000,2.03176426900000,1.89619628800000,6.02935420900000,11.9751584800000,1.92009495600000,2.67816476400000,79441.1468200000,-1.17007201000000,-1.31867227600000,-1.27814912700000,-1.81349855900000,7.66085140800000,5.63949020500000,6.73209601500000,6.75985614600000,135247.500000000,-100,-95.6154829300000,6.75922184500000,135250.157900000;0.423927972000000,1.69772884200000,1.49945971400000,4.37000000000000e+19,2.90000000000000e+19,2.36000000000000e+18,5.35000000000000e+17,2.62356327500000,1.47993556900000,1.53483356300000,2.13018943500000,1.89796053700000,6.02968077800000,11.9758070900000,1.91930985400000,2.67503880500000,78883.8586700000,-1.19122499300000,-1.86813498500000,-1.98556028700000,-0.429382637000000,8.17167032000000,4.75319169200000,6.55316837800000,6.71610468200000,129390.003100000,-96.5532851000000,-230.791164500000,6.71832594000000,129409.225100000;0.433815192000000,1.69605487400000,1.51023289800000,4.40000000000000e+19,2.94000000000000e+19,2.35000000000000e+18,4.67000000000000e+17,2.60848410300000,1.44092108500000,1.47789372600000,2.23670794400000,1.89983378100000,6.03008785400000,11.9766156000000,1.91843924100000,2.66288768700000,78173.1541800000,-1.20238386400000,-2.47194971000000,-2.76255636500000,1.14777657800000,8.54584458300000,4.20164958100000,6.39509068400000,6.58920269600000,123878.470400000,-58.3871155900000,-355.574215100000,6.59511196800000,123906.418000000;0.443489786000000,1.69430557000000,1.52173600700000,4.43000000000000e+19,3.00000000000000e+19,2.32000000000000e+18,3.96000000000000e+17,2.57840550000000,1.40650352400000,1.42534041500000,2.35171900500000,1.90179528500000,6.03059652900000,11.9776259100000,1.91747431500000,2.64134165900000,77536.5132800000,-1.19394090900000,-3.11199632600000,-3.58643482200000,2.97915411700000,8.95715861100000,4.27096397000000,6.25768470000000,6.37931793300000,118771.106300000,-39.6228563900000,-466.637655400000,6.38921813200000,118796.837800000;0.452950217000000,1.69247975800000,1.53405602600000,4.46000000000000e+19,3.07000000000000e+19,2.27000000000000e+18,3.25000000000000e+17,2.53237275300000,1.37307249600000,1.37664678000000,2.47605047300000,1.90384690200000,6.03122703600000,11.9788781800000,1.91641139100000,2.61032281100000,76839.9090200000,-1.18477993400000,-3.77415623200000,-4.43988584300000,5.17124029300000,9.40887873000000,4.36918731100000,6.15723350900000,6.09993264600000,114098.167400000,-27.5874005600000,-560.260899100000,6.11387415700000,114112.910800000;0.462169952000000,1.69060513200000,1.54730688800000,4.49000000000000e+19,3.15000000000000e+19,2.19000000000000e+18,2.59000000000000e+17,2.46949483900000,1.33701047000000,1.33129702800000,2.61060576200000,1.90595798100000,6.03192255900000,11.9802595900000,1.91524941300000,2.57005286300000,76550.8429600000,-1.16170976600000,-4.44484237100000,-5.30439939900000,7.84626015400000,9.89950025400000,5.17669600800000,6.09800005400000,5.77147067200000,109876.760600000,-18.0416059900000,-632.653747400000,5.78940596400000,109875.993700000;0.471146124000000,1.68868700000000,1.56166309900000,4.52000000000000e+19,3.25000000000000e+19,2.08000000000000e+18,2.00000000000000e+17,2.38939287700000,1.29469842900000,1.28879369400000,2.75660253500000,1.90812290500000,6.03253570900000,11.9814774000000,1.91399214300000,2.52123344100000,79850.3285100000,-1.12253909800000,-5.09099396300000,-6.13287029200000,11.0572000100000,10.4715851600000,6.66394409300000,6.10173632700000,5.41354481100000,106086.006000000,-7.71931284700000,-679.314858500000,5.43531827900000,106067.416600000;0.479848297000000,1.68675545300000,1.57732316200000,4.54000000000000e+19,3.36000000000000e+19,1.95000000000000e+18,1.51000000000000e+17,2.29309964900000,1.24252195000000,1.24872501500000,2.91599566900000,1.91030794500000,6.03297844800000,11.9823567400000,1.91265524700000,2.46542152300000,82584.0611200000,-1.07334100800000,-5.66216708400000,-6.85540909100000,14.7738712500000,11.1529102000000,8.98950602300000,6.17565767600000,5.04607940200000,102742.069200000,-4.48637385900000,-699.443065400000,5.07138934700000,102704.624600000;0.488270546000000,1.68481464700000,1.59452826200000,4.57000000000000e+19,3.48000000000000e+19,1.79000000000000e+18,1.10000000000000e+17,2.18268523500000,1.17686798800000,1.21097905400000,3.09101924300000,1.91250850700000,6.03324783300000,11.9828917800000,1.91126186200000,2.40464706100000,87835.0394800000,-1.02275989400000,-6.34748527700000,-7.63883219200000,19.1484718300000,11.9506815500000,12.4096797700000,6.06218923800000,4.68666721100000,99878.7723600000,-2.89429382100000,-710.464029200000,4.71507739200000,99821.9853900000;0.496388225000000,1.68288736000000,1.61356012000000,4.59000000000000e+19,3.61000000000000e+19,1.61000000000000e+18,7.65000000000000e+16,2.06028551800000,1.09408837100000,1.17753990200000,3.28562766100000,1.91469876200000,6.03333843600000,11.9830717300000,1.90983759200000,2.34080140400000,71890.2381300000,-0.933816072000000,-6.22121687300000,-7.55285073600000,24.6240666200000,13.0507086100000,17.4779015800000,5.66509173600000,4.35198671900000,97534.9426800000,10.4268270100000,-692.534137100000,4.38297061300000,97458.6231700000;0.504170606000000,1.68097441600000,1.63478927100000,4.60000000000000e+19,3.74000000000000e+19,1.42000000000000e+18,5.10000000000000e+16,1.92944624900000,0.990199733000000,1.14730883900000,3.50653872800000,1.91687768400000,6.03322491000000,11.9828462500000,1.90789252300000,2.27584156100000,447.045207300000,-0.240488373000000,-6.08422295700000,-7.41726365200000,31.7919243400000,14.5227953400000,25.2580251000000,5.81463949300000,4.05679188000000,95724.5768100000,100,-370.961382300000,4.08977604500000,95628.9152600000;0.511590616000000,1.67910565100000,1.65882445600000,4.51000000000000e+19,3.78000000000000e+19,1.21000000000000e+18,3.31000000000000e+16,1.80529823800000,0.860767839000000,1.11711125600000,3.76285854600000,1.91901107700000,6.03284810700000,11.9820978600000,1.90757010100000,2.21924914200000,213986.078000000,6.90976958300000,1.28258327200000,-0.0191401090000000,41.8838992000000,16.6153314100000,37.9985971700000,6.25022666700000,3.81253732700000,94416.9230500000,-100,399.804016000000,3.84694141600000,94302.8901300000;0.518590761000000,1.67731968500000,1.68662784600000,4.12000000000000e+19,3.53000000000000e+19,9.83000000000000e+17,2.12000000000000e+16,1.71575080900000,0.701655902000000,1.08664664300000,4.07344652400000,1.92105439000000,6.03207957800000,11.9805714500000,1.90988846100000,2.18274156000000,933978.053300000,32.6562784600000,29.2079537500000,28.4226722800000,57.1094578500000,19.8420751700000,60.7720235400000,6.89411139500000,3.62696443700000,93537.8240600000,-100,1426.95285300000,3.66225372000000,93407.6138800000;0.525135629000000,1.67561413600000,1.71990231800000,3.29000000000000e+19,2.83000000000000e+19,7.51000000000000e+17,1.34000000000000e+16,1.68930933700000,0.510106290000000,1.05551132800000,4.47071157500000,1.92300976400000,6.03061558400000,11.9776637500000,1.91377092100000,2.17370195600000,1004701.42100000,100,100,0,83.2200621000000,24.2942438800000,100,7.66101613000000,3.50146323900000,92992.8495800000,-100,3179.31962800000,3.53720732600000,92849.8431100000;0.531127232000000,1.67398740500000,1.76201927300000,2.04000000000000e+19,1.73000000000000e+19,5.13000000000000e+17,8.68000000000000e+15,1.78839007200000,0.289516326000000,1.02270552700000,5.02725772100000,1.92487848800000,6.02757012600000,11.9716150400000,1.91957696400000,2.20847571500000,1005147.14700000,100,100,0,100,39.2426323500000,100,9.95201260000000,3.43318835300000,92711.9426300000,-100,6516.82980600000,3.46909314500000,92560.9296800000]';
% % %         varDataM = [0.0121098980000000,1.71441695100000,1.43397578600000,4.52000000000000e+19,3.77000000000000e+19,6.68000000000000e+17,3.42000000000000e+18,1.44525184800000,4.08736337900000,4.89133383600000,1.27871161800000,1.87948581800000,6.03732296400000,11.9909855700000,1.95150807800000,2.12596759400000,16725.2760200000,0.143051603000000,-0.100523275000000,-0.105752515000000,0.366225600000000,-0.131064454000000,0.0145695680000000,0.813718749000000,0.304152608000000,295962.546200000,66.4967444900000,7409.01166000000,0.301510721000000,295969.377900000;0.0242468660000000,1.71441810400000,1.43070040500000,4.51000000000000e+19,3.78000000000000e+19,6.65000000000000e+17,3.34000000000000e+18,1.44440279300000,4.08651533600000,4.86276267400000,1.27676726600000,1.87948455300000,6.03712224100000,11.9905869000000,1.95095496500000,2.12471013700000,11010.0440100000,0.276529656000000,-0.100898724000000,-0.106617043000000,0.631203650000000,-0.286251413000000,0.0406465910000000,0.838632534000000,0.363508983000000,295748.572100000,100,684.290523800000,0.360787800000000,295759.376800000;0.0364048520000000,1.71437046100000,1.42789853800000,4.50000000000000e+19,3.77000000000000e+19,6.62000000000000e+17,3.31000000000000e+18,1.44337274400000,4.08444722700000,4.83297144500000,1.27298596000000,1.87953678500000,6.03679626500000,11.9899394700000,1.95044854200000,2.12367071500000,9860.06417100000,0.393823673000000,0.459102096000000,0.453424198000000,0.706805792000000,-0.519846396000000,0.0923987370000000,0.886150628000000,0.459586444000000,295342.162400000,5.76371473800000,-1325.80672500000,0.456790952000000,295359.063100000;0.0485847640000000,1.71428721900000,1.42518093600000,4.49000000000000e+19,3.76000000000000e+19,6.59000000000000e+17,3.34000000000000e+18,1.44250094900000,4.08058925500000,4.80139035400000,1.26680066800000,1.87962805100000,6.03635298200000,11.9890590400000,1.95005418400000,2.12309128400000,2534.06928100000,0.498460825000000,0.681458482000000,0.682703524000000,0.710312157000000,-0.806653359000000,0.163889894000000,0.929955343000000,0.589058390000000,294663.840500000,0.371485843000000,-1229.34797900000,0.586243809000000,294688.062100000;0.0607791170000000,1.71418223200000,1.42281517000000,4.47000000000000e+19,3.74000000000000e+19,6.56000000000000e+17,3.37000000000000e+18,1.44213260300000,4.07436671400000,4.76744469400000,1.25762054100000,1.87974317100000,6.03580144600000,11.9879636100000,1.94960794900000,2.12268435500000,2001.01687900000,0.591343900000000,0.671757001000000,0.673516195000000,0.633264769000000,-1.34116730300000,0.255431219000000,1.23956482000000,0.747325024000000,293624.630900000,6.98001650800000,-1229.43558400000,0.744598874000000,293657.029800000;0.0729821590000000,1.71406306600000,1.42081627200000,4.45000000000000e+19,3.72000000000000e+19,6.54000000000000e+17,3.36000000000000e+18,1.44261891900000,4.06520863800000,4.70694839700000,1.24416912600000,1.87987385600000,6.03515285800000,11.9866754300000,1.94907814400000,2.12237222200000,16490.3774800000,0.671956615000000,0.616939613000000,0.631832709000000,0.387130503000000,-1.68744257800000,0.367104810000000,1.93873537100000,0.928726791000000,292143.950800000,10.8153002600000,-1153.94500900000,0.926228789000000,292184.918900000;0.0851943300000000,1.71393833600000,1.41899160800000,4.43000000000000e+19,3.70000000000000e+19,6.53000000000000e+17,3.30000000000000e+18,1.44432051600000,4.05254523700000,4.64110474900000,1.22917578900000,1.88001066100000,6.03442161200000,11.9852230700000,1.94857217900000,2.12240611200000,8662.94498500000,0.739955941000000,0.618118761000000,0.629553019000000,0.0155391240000000,-1.70413110600000,0.499214226000000,2.06993437100000,1.12699407300000,290166.574000000,6.32557980600000,-1055.61269100000,1.12483443800000,290215.602300000;0.0974223600000000,1.71381201100000,1.41707848200000,4.40000000000000e+19,3.69000000000000e+19,6.54000000000000e+17,3.22000000000000e+18,1.44760894400000,4.03580130000000,4.57026288300000,1.21426379200000,1.88014923700000,6.03362550800000,11.9836418900000,1.94808722800000,2.12301231900000,3279.07246300000,0.795060453000000,0.620974502000000,0.640706326000000,-0.477686417000000,-1.70208984600000,0.651976133000000,2.24519738700000,1.33573204000000,287673.800200000,6.39057972400000,-1010.47517300000,1.33394397700000,287729.343600000;0.109671347000000,1.71368199400000,1.41497916600000,4.38000000000000e+19,3.67000000000000e+19,6.58000000000000e+17,3.12000000000000e+18,1.45286554100000,4.01440622600000,4.49460795400000,1.20005382200000,1.88029188400000,6.03278607500000,11.9819746600000,1.94760513400000,2.12439217900000,7502.92261100000,0.837188188000000,0.703533122000000,0.735044692000000,-1.08521494800000,-1.64157376000000,0.826144118000000,2.42725204000000,1.54873939300000,284680.008000000,6.69857495200000,-964.135204100000,1.54729840600000,284740.187000000;0.121939825000000,1.71354204500000,1.41279251600000,4.35000000000000e+19,3.65000000000000e+19,6.65000000000000e+17,3.02000000000000e+18,1.46048296900000,3.98778560800000,4.41402616700000,1.18616399400000,1.88044545100000,6.03192858600000,11.9802715600000,1.94714911400000,2.12675304800000,9557.24156200000,0.866541874000000,0.766786340000000,0.814011337000000,-1.79655618000000,-1.61820516400000,1.02331712100000,2.62575212000000,1.76136022200000,281217.024100000,-3.46225661400000,-928.362278800000,1.76020874700000,281279.217800000;0.134224680000000,1.71339041300000,1.41061113300000,4.32000000000000e+19,3.63000000000000e+19,6.76000000000000e+17,2.90000000000000e+18,1.47086428300000,3.95536449400000,4.32832553800000,1.17346094900000,1.88061186800000,6.03108072000000,11.9785875800000,1.94668490300000,2.13019547500000,12102.8383100000,0.877399275000000,0.785961151000000,0.848879062000000,-2.59575333400000,-1.41668044600000,1.24471011500000,2.84250228400000,1.97010485700000,277332.345600000,-4.38696502800000,-959.002424600000,1.96914977100000,277393.524800000;0.146523141000000,1.71322696500000,1.40852505200000,4.30000000000000e+19,3.61000000000000e+19,6.91000000000000e+17,2.76000000000000e+18,1.48442115100000,3.91657247800000,4.23730243300000,1.16321258500000,1.88079128400000,6.03027102000000,11.9769794000000,1.94614066000000,2.13479966000000,22583.8592900000,0.882859193000000,0.809173078000000,0.890945677000000,-3.46315774700000,-1.06655106300000,1.49227759600000,3.07892314700000,2.17263765400000,273086.313200000,-3.95243357100000,-988.299955400000,2.17172690600000,273143.076400000;0.158829486000000,1.71305148200000,1.40663647900000,4.27000000000000e+19,3.58000000000000e+19,7.11000000000000e+17,2.61000000000000e+18,1.50157158500000,3.87083445400000,4.14080880900000,1.15554982400000,1.88098395000000,6.02952745100000,11.9755025700000,1.94553785600000,2.14083391800000,31966.5313200000,0.876909415000000,0.907133818000000,1.01306248600000,-4.37743323700000,-0.751445967000000,1.76916363500000,3.33496846400000,2.36813223300000,268540.404600000,30.9339946300000,-891.687215300000,2.36702094100000,268589.166700000;0.171134997000000,1.71286385500000,1.40504515200000,4.24000000000000e+19,3.55000000000000e+19,7.37000000000000e+17,2.47000000000000e+18,1.52273754100000,3.81758041800000,4.03879719000000,1.15018393100000,1.88118999300000,6.02887496400000,11.9742066300000,1.94495979600000,2.14866431000000,34701.6474500000,0.853911779000000,1.05702053300000,1.18919967300000,-5.31360326000000,-0.588109783000000,2.07842564200000,3.61209909500000,2.55729375400000,263749.356600000,56.3414660300000,-658.540650400000,2.55568804600000,263789.990300000;0.183432164000000,1.71266589300000,1.40381512500000,4.22000000000000e+19,3.52000000000000e+19,7.68000000000000e+17,2.35000000000000e+18,1.54833822600000,3.75623989900000,3.93124472600000,1.14640651100000,1.88140743500000,6.02833354700000,11.9731313000000,1.94446321900000,2.15856013800000,36683.7487400000,0.816990930000000,1.16316987600000,1.32586078500000,-6.24893371100000,-0.294001779000000,2.42520623200000,3.91111286200000,2.74214552800000,258752.584400000,94.0389329700000,-382.171343300000,2.73992853300000,258792.737200000;0.195709163000000,1.71246345800000,1.40295720700000,4.19000000000000e+19,3.49000000000000e+19,8.06000000000000e+17,2.23000000000000e+18,1.57878784900000,3.68623832900000,3.81830976300000,1.14752098100000,1.88162984100000,6.02791719200000,11.9723043600000,1.94403853200000,2.17068405000000,41058.3911300000,0.765965478000000,1.23934485000000,1.43444489700000,-7.15916086100000,0.398707578000000,2.81432232400000,4.22638625600000,2.92541293700000,253573.993300000,100,-147.035787500000,2.92285315800000,253623.250800000;0.207962475000000,1.71224979600000,1.40244130300000,4.17000000000000e+19,3.45000000000000e+19,8.52000000000000e+17,2.11000000000000e+18,1.61448851800000,3.60700483100000,3.70024601300000,1.15274746100000,1.88186463900000,6.02763315200000,11.9717402200000,1.94362948300000,2.18519255700000,46362.0986900000,0.699792721000000,1.31736764300000,1.54867762600000,-8.01991069400000,0.883387044000000,3.25078975700000,4.55900694000000,3.11010877200000,248221.667300000,-100,34.5063582500000,3.10775058400000,248282.676200000;0.220186533000000,1.71201981900000,1.40230537800000,4.15000000000000e+19,3.41000000000000e+19,9.05000000000000e+17,1.99000000000000e+18,1.65582214700000,3.51796437600000,3.57725274600000,1.16235632000000,1.88211743200000,6.02748176900000,11.9714395500000,1.94319242100000,2.20230794600000,53378.1844900000,0.618509262000000,1.41419947700000,1.68655978400000,-8.81506641700000,1.42269609700000,3.74461910800000,4.91666523300000,3.29896332000000,242699.126500000,-100,224.272204600000,3.29735782500000,242769.398200000;0.232375088000000,1.71176929800000,1.40268704800000,4.14000000000000e+19,3.37000000000000e+19,9.66000000000000e+17,1.88000000000000e+18,1.70314465600000,3.41854283700000,3.44948449700000,1.17659278200000,1.88239288300000,6.02745763500000,11.9713916100000,1.94275702900000,2.22235945100000,58690.4853200000,0.521899528000000,1.53456864000000,1.85323473100000,-9.53910703000000,1.94249021800000,4.31368482400000,5.30723897700000,3.49422654700000,237008.961300000,-76.2845199400000,484.902028800000,3.49381806200000,237086.108300000;0.244515225000000,1.71149687900000,1.40372370900000,4.12000000000000e+19,3.32000000000000e+19,1.04000000000000e+18,1.78000000000000e+18,1.75677385700000,3.30834024900000,3.31710818200000,1.19567691900000,1.88269250300000,6.02755041700000,11.9715758900000,1.94240651300000,2.24574846100000,62498.4713800000,0.409669416000000,1.67119683200000,2.04138892500000,-10.2033518900000,2.63855756000000,4.94625194100000,5.73326510400000,3.69740404400000,231157.095400000,-51.4914452100000,780.209240000000,3.69856585800000,231240.565400000;0.256599357000000,1.71119036700000,1.40544583600000,4.11000000000000e+19,3.27000000000000e+19,1.12000000000000e+18,1.69000000000000e+18,1.81695424700000,3.18798372200000,3.18033056100000,1.22121169500000,1.88302973500000,6.02774175700000,11.9719559200000,1.94215258700000,2.27277633800000,59175.1674400000,0.281361146000000,1.74561611600000,2.20118182500000,-10.7772260200000,3.29161526200000,5.58642023400000,6.20100739500000,3.90935869100000,225148.166000000,100,224.830164300000,3.91246745600000,225238.858500000;0.268613391000000,1.71083965900000,1.40778748200000,4.11000000000000e+19,3.22000000000000e+19,1.20000000000000e+18,1.60000000000000e+18,1.88337520100000,3.05920672400000,3.03930479700000,1.25142301000000,1.88341574100000,6.02795532300000,11.9723800900000,1.94178248800000,2.30323417700000,61648.7242100000,0.135607174000000,1.76595618100000,2.24218557700000,-11.1201151700000,3.71009633200000,6.20725186300000,6.74165548700000,4.13013910900000,218992.258500000,-100,-3208.16997000000,4.13555568900000,219087.696900000;0.280543776000000,1.71043997200000,1.41068871400000,4.10000000000000e+19,3.17000000000000e+19,1.30000000000000e+18,1.51000000000000e+18,1.95477018300000,2.92400830100000,2.89413383300000,1.28595253500000,1.88385584800000,6.02811307200000,11.9726934100000,1.93216143200000,2.32787703200000,71373.4538000000,-0.0230497610000000,1.74513851500000,2.27519774400000,-11.1483651700000,4.09966468100000,6.80835909600000,7.37640173400000,4.35923517400000,212702.698200000,79.1141029100000,-5109.64646300000,4.36702619900000,212788.814800000;0.292378047000000,1.70998428300000,1.41413260300000,4.11000000000000e+19,3.12000000000000e+19,1.40000000000000e+18,1.41000000000000e+18,2.02942982700000,2.78440139700000,2.74613598700000,1.32450990100000,1.88435787200000,6.02821137900000,11.9728886600000,1.92285961900000,2.35528911300000,71885.3662500000,-0.179927403000000,1.67008992600000,2.23954275100000,-10.9300468000000,4.40900940900000,7.38970069300000,7.77882653700000,4.59586038700000,206297.190400000,100,-1848.91749500000,4.60547965600000,206354.829400000;0.304102342000000,1.70947002900000,1.41815804400000,4.11000000000000e+19,3.08000000000000e+19,1.51000000000000e+18,1.31000000000000e+18,2.10567929800000,2.64238890400000,2.59991106600000,1.36687272800000,1.88492473600000,6.02827256000000,11.9730101700000,1.92320583000000,2.39372907100000,62720.8942900000,-0.325736489000000,1.61471397400000,2.21335107800000,-10.5335180600000,4.80482895000000,7.93575771900000,8.18515767700000,4.83913197100000,199800.010100000,-100,1234.77145000000,4.84955788500000,199821.486000000;0.315709484000000,1.70888639400000,1.42280459200000,4.13000000000000e+19,3.03000000000000e+19,1.62000000000000e+18,1.22000000000000e+18,2.18188608000000,2.49997027100000,2.46105662600000,1.41414266000000,1.88556849400000,6.02831381900000,11.9730921200000,1.92341644100000,2.43319102100000,64046.8810200000,-0.460242380000000,1.56957119800000,2.18927215400000,-9.93521312200000,5.15825855000000,8.38501801100000,8.09809692100000,5.08832824400000,193236.393200000,20.7977988000000,1634.39176800000,5.09843105100000,193226.303000000;0.327192765000000,1.70822029900000,1.42806568900000,4.14000000000000e+19,2.99000000000000e+19,1.73000000000000e+18,1.15000000000000e+18,2.25646621500000,2.35914987200000,2.33181899100000,1.46502141000000,1.88630374300000,6.02834786900000,11.9731597500000,1.92349156100000,2.47297691100000,67998.8586400000,-0.584420704000000,1.49641399500000,2.12752175300000,-9.30967540800000,5.37633973100000,8.87715998100000,7.98448887300000,5.34171093100000,186633.630900000,24.7387755200000,1404.96672200000,5.35052035000000,186599.757200000;0.338540271000000,1.70746884500000,1.43391338600000,4.16000000000000e+19,2.95000000000000e+19,1.83000000000000e+18,1.09000000000000e+18,2.32789185300000,2.22193498400000,2.21195857200000,1.51960655500000,1.88713390200000,6.02838578100000,11.9732350500000,1.92343264100000,2.51214311200000,69264.2614300000,-0.697430419000000,1.33475282000000,1.96013575300000,-8.66920830700000,5.61678136700000,9.22614887500000,7.88459389700000,5.59510345700000,180022.611500000,29.4828191700000,1174.05784200000,5.60193333700000,179971.861600000;0.349754608000000,1.70661861600000,1.44030729400000,4.18000000000000e+19,2.91000000000000e+19,1.94000000000000e+18,1.03000000000000e+18,2.39468819200000,2.09032936100000,2.10103427500000,1.57799544800000,1.88807406300000,6.02843581200000,11.9733344100000,1.92324223100000,2.54953131500000,70428.4916800000,-0.799068742000000,1.06606395100000,1.66417081600000,-7.89037560200000,5.81171787900000,9.43719529000000,7.76162586500000,5.84286662300000,173424.712800000,35.8148998200000,948.953284600000,5.84735657300000,173362.560900000;0.360827867000000,1.70566624000000,1.44721768700000,4.20000000000000e+19,2.89000000000000e+19,2.03000000000000e+18,9.58000000000000e+17,2.45544760600000,1.96633245000000,1.99860135200000,1.64028516200000,1.88912828800000,6.02850449000000,11.9734708200000,1.92293132500000,2.58399519600000,73304.5979300000,-0.889571360000000,0.743583036000000,1.29525744200000,-7.05609671100000,6.12334500000000,9.48151666500000,7.62033239100000,6.07799329200000,166864.923400000,42.7888874800000,737.368234100000,6.08005847300000,166796.086600000;0.371754469000000,1.70460831600000,1.45461961400000,4.23000000000000e+19,2.87000000000000e+19,2.12000000000000e+18,8.85000000000000e+17,2.50884284800000,1.85195253800000,1.90418539500000,1.70826919700000,1.89030073000000,6.02859793200000,11.9736564100000,1.92251823300000,2.61452389600000,76194.7914600000,-0.968313209000000,0.403917095000000,0.891519115000000,-6.16220583200000,6.47572201300000,9.30074560400000,7.46200312200000,6.29296623800000,160363.522500000,53.1156252000000,543.953320000000,6.29276415700000,160294.429300000;0.382528164000000,1.70344303900000,1.46250872900000,4.25000000000000e+19,2.85000000000000e+19,2.20000000000000e+18,8.12000000000000e+17,2.55361710800000,1.74919297700000,1.81728002800000,1.78100812900000,1.89159383100000,6.02872246800000,11.9739037500000,1.92202001800000,2.64015992100000,77814.5273700000,-1.03610174300000,0.0393400370000000,0.444627077000000,-5.20519577900000,6.70782296900000,8.83186395900000,7.29253227100000,6.47976817200000,153936.314400000,73.5922004600000,366.826361000000,6.47782354800000,153876.575700000;0.393139590000000,1.70217052300000,1.47090607000000,4.28000000000000e+19,2.85000000000000e+19,2.26000000000000e+18,7.40000000000000e+17,2.58857771500000,1.66006054000000,1.73738808700000,1.85884450800000,1.89300795700000,6.02888510600000,11.9742267800000,1.92144720700000,2.65992519600000,78681.4080100000,-1.09254113800000,-0.368140440000000,-0.0649999770000000,-4.17468982700000,6.98133311600000,7.98253851300000,7.11257157800000,6.62849259500000,147594.803800000,100,202.471403200000,6.62575979900000,147553.654800000;0.403581313000000,1.70079218300000,1.47984460200000,4.31000000000000e+19,2.86000000000000e+19,2.31000000000000e+18,6.70000000000000e+17,2.61259880800000,1.58621562400000,1.66402823200000,1.94223776300000,1.89454207100000,6.02909281100000,11.9746393100000,1.92080539800000,2.67287659300000,79247.0991300000,-1.13665281400000,-0.820751364000000,-0.639596947000000,-3.05152738300000,7.24002262900000,6.79768390900000,6.92057341900000,6.72661128400000,141351.323200000,100,48.7164221900000,6.72428818000000,141332.747400000;0.413848808000000,1.69930843300000,1.48934965000000,4.34000000000000e+19,2.87000000000000e+19,2.34000000000000e+18,6.02000000000000e+17,2.62460509900000,1.52716104800000,1.59669322900000,2.03176426900000,1.89619628800000,6.02935420900000,11.9751584800000,1.92009495600000,2.67816476400000,79441.1468200000,-1.17007201000000,-1.31867227600000,-1.27814912700000,-1.81349855900000,7.66085140800000,5.63949020500000,6.73209601500000,6.75985614600000,135247.500000000,-100,-95.6154829300000,6.75922184500000,135250.157900000;0.423927972000000,1.69772884200000,1.49945971400000,4.37000000000000e+19,2.90000000000000e+19,2.36000000000000e+18,5.35000000000000e+17,2.62356327500000,1.47993556900000,1.53483356300000,2.13018943500000,1.89796053700000,6.02968077800000,11.9758070900000,1.91930985400000,2.67503880500000,78883.8586700000,-1.19122499300000,-1.86813498500000,-1.98556028700000,-0.429382637000000,8.17167032000000,4.75319169200000,6.55316837800000,6.71610468200000,129390.003100000,-96.5532851000000,-230.791164500000,6.71832594000000,129409.225100000;0.433815192000000,1.69605487400000,1.51023289800000,4.40000000000000e+19,2.94000000000000e+19,2.35000000000000e+18,4.67000000000000e+17,2.60848410300000,1.44092108500000,1.47789372600000,2.23670794400000,1.89983378100000,6.03008785400000,11.9766156000000,1.91843924100000,2.66288768700000,78173.1541800000,-1.20238386400000,-2.47194971000000,-2.76255636500000,1.14777657800000,8.54584458300000,4.20164958100000,6.39509068400000,6.58920269600000,123878.470400000,-58.3871155900000,-355.574215100000,6.59511196800000,123906.418000000;0.443489786000000,1.69430557000000,1.52173600700000,4.43000000000000e+19,3.00000000000000e+19,2.32000000000000e+18,3.96000000000000e+17,2.57840550000000,1.40650352400000,1.42534041500000,2.35171900500000,1.90179528500000,6.03059652900000,11.9776259100000,1.91747431500000,2.64134165900000,77536.5132800000,-1.19394090900000,-3.11199632600000,-3.58643482200000,2.97915411700000,8.95715861100000,4.27096397000000,6.25768470000000,6.37931793300000,118771.106300000,-39.6228563900000,-466.637655400000,6.38921813200000,118796.837800000;0.452950217000000,1.69247975800000,1.53405602600000,4.46000000000000e+19,3.07000000000000e+19,2.27000000000000e+18,3.25000000000000e+17,2.53237275300000,1.37307249600000,1.37664678000000,2.47605047300000,1.90384690200000,6.03122703600000,11.9788781800000,1.91641139100000,2.61032281100000,76839.9090200000,-1.18477993400000,-3.77415623200000,-4.43988584300000,5.17124029300000,9.40887873000000,4.36918731100000,6.15723350900000,6.09993264600000,114098.167400000,-27.5874005600000,-560.260899100000,6.11387415700000,114112.910800000;0.462169952000000,1.69060513200000,1.54730688800000,4.49000000000000e+19,3.15000000000000e+19,2.19000000000000e+18,2.59000000000000e+17,2.46949483900000,1.33701047000000,1.33129702800000,2.61060576200000,1.90595798100000,6.03192255900000,11.9802595900000,1.91524941300000,2.57005286300000,76550.8429600000,-1.16170976600000,-4.44484237100000,-5.30439939900000,7.84626015400000,9.89950025400000,5.17669600800000,6.09800005400000,5.77147067200000,109876.760600000,-18.0416059900000,-632.653747400000,5.78940596400000,109875.993700000;0.471146124000000,1.68868700000000,1.56166309900000,4.52000000000000e+19,3.25000000000000e+19,2.08000000000000e+18,2.00000000000000e+17,2.38939287700000,1.29469842900000,1.28879369400000,2.75660253500000,1.90812290500000,6.03253570900000,11.9814774000000,1.91399214300000,2.52123344100000,79850.3285100000,-1.12253909800000,-5.09099396300000,-6.13287029200000,11.0572000100000,10.4715851600000,6.66394409300000,6.10173632700000,5.41354481100000,106086.006000000,-7.71931284700000,-679.314858500000,5.43531827900000,106067.416600000;0.479848297000000,1.68675545300000,1.57732316200000,4.54000000000000e+19,3.36000000000000e+19,1.95000000000000e+18,1.51000000000000e+17,2.29309964900000,1.24252195000000,1.24872501500000,2.91599566900000,1.91030794500000,6.03297844800000,11.9823567400000,1.91265524700000,2.46542152300000,82584.0611200000,-1.07334100800000,-5.66216708400000,-6.85540909100000,14.7738712500000,11.1529102000000,8.98950602300000,6.17565767600000,5.04607940200000,102742.069200000,-4.48637385900000,-699.443065400000,5.07138934700000,102704.624600000;0.488270546000000,1.68481464700000,1.59452826200000,4.57000000000000e+19,3.48000000000000e+19,1.79000000000000e+18,1.10000000000000e+17,2.18268523500000,1.17686798800000,1.21097905400000,3.09101924300000,1.91250850700000,6.03324783300000,11.9828917800000,1.91126186200000,2.40464706100000,87835.0394800000,-1.02275989400000,-6.34748527700000,-7.63883219200000,19.1484718300000,11.9506815500000,12.4096797700000,6.06218923800000,4.68666721100000,99878.7723600000,-2.89429382100000,-710.464029200000,4.71507739200000,99821.9853900000;0.496388225000000,1.68288736000000,1.61356012000000,4.59000000000000e+19,3.61000000000000e+19,1.61000000000000e+18,7.65000000000000e+16,2.06028551800000,1.09408837100000,1.17753990200000,3.28562766100000,1.91469876200000,6.03333843600000,11.9830717300000,1.90983759200000,2.34080140400000,71890.2381300000,-0.933816072000000,-6.22121687300000,-7.55285073600000,24.6240666200000,13.0507086100000,17.4779015800000,5.66509173600000,4.35198671900000,97534.9426800000,10.4268270100000,-692.534137100000,4.38297061300000,97458.6231700000;0.504170606000000,1.68097441600000,1.63478927100000,4.60000000000000e+19,3.74000000000000e+19,1.42000000000000e+18,5.10000000000000e+16,1.92944624900000,0.990199733000000,1.14730883900000,3.50653872800000,1.91687768400000,6.03322491000000,11.9828462500000,1.90789252300000,2.27584156100000,447.045207300000,-0.240488373000000,-6.08422295700000,-7.41726365200000,31.7919243400000,14.5227953400000,25.2580251000000,5.81463949300000,4.05679188000000,95724.5768100000,100,-370.961382300000,4.08977604500000,95628.9152600000;0.511590616000000,1.67910565100000,1.65882445600000,4.51000000000000e+19,3.78000000000000e+19,1.21000000000000e+18,3.31000000000000e+16,1.80529823800000,0.860767839000000,1.11711125600000,3.76285854600000,1.91901107700000,6.03284810700000,11.9820978600000,1.90757010100000,2.21924914200000,213986.078000000,6.90976958300000,1.28258327200000,-0.0191401090000000,41.8838992000000,16.6153314100000,37.9985971700000,6.25022666700000,3.81253732700000,94416.9230500000,-100,399.804016000000,3.84694141600000,94302.8901300000;0.518590761000000,1.67731968500000,1.68662784600000,4.12000000000000e+19,3.53000000000000e+19,9.83000000000000e+17,2.12000000000000e+16,1.71575080900000,0.701655902000000,1.08664664300000,4.07344652400000,1.92105439000000,6.03207957800000,11.9805714500000,1.90988846100000,2.18274156000000,933978.053300000,32.6562784600000,29.2079537500000,28.4226722800000,57.1094578500000,19.8420751700000,60.7720235400000,6.89411139500000,3.62696443700000,93537.8240600000,-100,1426.95285300000,3.66225372000000,93407.6138800000;0.525135629000000,1.67561413600000,1.71990231800000,3.29000000000000e+19,2.83000000000000e+19,7.51000000000000e+17,1.34000000000000e+16,1.68930933700000,0.510106290000000,1.05551132800000,4.47071157500000,1.92300976400000,6.03061558400000,11.9776637500000,1.91377092100000,2.17370195600000,1004701.42100000,100,100,0,83.2200621000000,24.2942438800000,100,7.66101613000000,3.50146323900000,92992.8495800000,-100,3179.31962800000,3.53720732600000,92849.8431100000;0.531127232000000,1.67398740500000,1.76201927300000,2.04000000000000e+19,1.73000000000000e+19,5.13000000000000e+17,8.68000000000000e+15,1.78839007200000,0.289516326000000,1.02270552700000,5.02725772100000,1.92487848800000,6.02757012600000,11.9716150400000,1.91957696400000,2.20847571500000,1005147.14700000,100,100,0,100,39.2426323500000,100,9.95201260000000,3.43318835300000,92711.9426300000,-100,6516.82980600000,3.46909314500000,92560.9296800000;0.536292269000000,1.67245506800000,1.82661833400000,9.68000000000000e+18,7.68000000000000e+18,3.33000000000000e+17,3.53000000000000e+15,2.13603648600000,0.112725358000000,0.974627876000000,6.08151891700000,1.92664210000000,6.02226843800000,11.9610851300000,1.91775366000000,2.33482713200000,1003655.06300000,100,100,0,100,71.4269462100000,100,19.2616543200000,3.41382082600000,92635.2164700000,-21.3465158600000,7819.52371000000,3.44974878400000,92481.8569300000]';
% % %         varNameM = {'rmin','rmaj','elong','ne','nh','nz','nf','zeff','te','ti','q','btor','zimp','aimp','ahyd','aimass','wexbs','gne','gni','gnh','gnz','gte','gti','gq','gvtor','vtor','gvpol','vpol','gvpar','vpar'};
% % %         mmmCounter;
% % %         
% % %         varDataY{2} = single(varDataM(mmmCounter,(1:end)));
% % %         varDataY{2} = varDataY{2}';
% % %         switch mmmCounter
% % %             case{4,5,6,7}
% % %                 varDataY{2} = varDataY{2}/10^(6);
% % %                case{9,10}
% % %                    varDataY{2} = varDataY{2}*10^(3);
% % %             case{26,28,30}
% % %                 varDataY{2} = varDataY{2}*100;
% % %         end
% % %         varNameY{2} = horzcat(varNameM{mmmCounter},' (sample)');
% % %         %%%%%%%
        gradientMode='';
        calculatedVar='';
     
        
        if evt
            entryName = char(strrep(upper(hObj),' ',''));
            entryBoxNumber = 1;
        else
            entryName = char(strrep(upper(get(hObj,'String')),' ',''));
            entryBoxNumber = str2double(get(hObj,'tag'));
        end
        

        
        if numel(strfind(entryName,'*X'))
            gradientMode='Partial Position';
            entryName = strrep(entryName,'*X','');
        elseif numel(strfind(entryName,'*T'))
            gradientMode='Partial Time';
            entryName = strrep(entryName,'*T','');
        elseif numel(strfind(entryName,'*G'))
            gradientMode='Normalized Gradient';
            entryName = strrep(entryName,'*G','');
        end
       
        if numel(strfind(entryName,'**'))
            gradientSpacing = 3;
            entryName=strrep(entryName,'**','');
        elseif numel(strfind(entryName,'*'))
             gradientSpacing = 2;
            entryName=strrep(entryName,'*','');
        else
            gradientSpacing = 1;
        end
        entryName=strrep(entryName,'*','');
        
        if numel(strfind(entryName,'!'))
            entryName = strrep(entryName,'!','');
            calculatedVar = 'yes';
        end       
            
            
        if isempty(entryName)
            %% Empty entryName = Clear out corresponding variable data
            
            systemMsgF('','Clear');
            
            varNameY{entryBoxNumber} ={};
            varLabelY{entryBoxNumber} = {};
            varUnitsY{entryBoxNumber} = {};
            varDataY{entryBoxNumber} =[];
            
            if entryBoxNumber == 1 % Clear Everything
                set(tableH,'data',[]);
                set(varTitleH,'string','');
                set(sliderH,'enable','off');
                
                for j=1:numel(varNameY)
                    varNameY{j} ={};
                    varLabelY{j} = {};
                    varUnitsY{j} = {};
                    varDataY{j} =[];
                    set(entryBoxH{j},'string','');
                end
                
            end
            
        elseif strmatch(entryName,varListTRANSP,'exact') 
            %% Load variable data based on entryName
            %% strcmp not working here at the moment
               
            systemMsgF('','Clear');
            
            tempID = netcdf.inqVarID(ncid{activeCdf},entryName);
            
            if entryName == finfo{activeCdf}.Variables(1,tempID+1).Name
                % Verify Data Match
                % When using inqVar/getvar, the indexing starts at 1, however, when using
                % finfo{activeCdf}.Variables, the indexing starts at 0, so we need to
                % access the column number (tempID+1)
                
                if strcmp(finfo{activeCdf}.Variables(1,tempID+1).Datatype,'single')
                    % Variables of datatype 'single' have matrix values that may be plotted
                    % Variables of datatype 'int8' are just a scalar value
                    
                    %                 set(plotColH,'string','');
                    %                 set(plotTimeH,'string','');
                    
                    [varNameY{entryBoxNumber},varDataY{entryBoxNumber,1},varLabelY{entryBoxNumber},varUnitsY{entryBoxNumber}] = loadVarF(entryName);
            
                                        [varSizeY(entryBoxNumber,1),varSizeY(entryBoxNumber,2)]=size(varDataY{entryBoxNumber,1});
                    [~,dimSize]=size({finfo{activeCdf}.Variables(1,tempID+1).Dimensions.Name});
                    % Check to see how many dimension are associated with
                    % the variable, outputs are either 2 for
                    % (Time,position) or just 1 for (time)
                    
                    
                    if dimSize == 2
                        [tempNameX,tempNameT]=finfo{activeCdf}.Variables(1,tempID+1).Dimensions.Name;
%                        if entryBoxNumber==1
                           [varNameX{entryBoxNumber}, varDataX{entryBoxNumber}, varLabelX{entryBoxNumber}, varUnitsX{entryBoxNumber}] = loadVarF(tempNameX);
%                        else
%                         switch tempNameX
%                             case 'X'
%                                  varNameX{entryBoxNumber}=cdfNameR{1};
%                                  varDataX{entryBoxNumber}=cdfDataR{1}(:,:)/(max(max(cdfDataR{1})));
%                                  varLabelX{entryBoxNumber}=cdfLabelR{1};
%                                  varUnitsX{entryBoxNumber}=cdfUnitsR{1};
%                        
%                             case 'XB'
%                                  varNameX{entryBoxNumber}=cdfNameR{2};
%                                  varDataX{entryBoxNumber}=cdfDataR{2}(:,:)/(max(max(cdfDataR{w})));
%                                  varLabelX{entryBoxNumber}=cdfLabelR{2};
%                                  varUnitsX{entryBoxNumber}=cdfUnitsR{2};
%                             otherwise
%                         end   
%                         end
                        [varNameT{entryBoxNumber},varDataT{entryBoxNumber},varLabelT{entryBoxNumber},varUnitsT{entryBoxNumber}] = loadVarF(tempNameT);
                    elseif dimSize == 1
                        tempNameT = finfo{activeCdf}.Variables(1,tempID+1).Dimensions.Name;
                        [varNameX{entryBoxNumber}, varDataX{entryBoxNumber}, varLabelX{entryBoxNumber}, varUnitsX{entryBoxNumber}] = loadVarF('X');
                        [varNameT{entryBoxNumber},varDataT{entryBoxNumber},varLabelT{entryBoxNumber},varUnitsT{entryBoxNumber}] = loadVarF(tempNameT);
                       
                    end
         
                    switch gradientMode
                        case 'Normalized Gradient'
                            switch tempNameX %Get non-normalized independent variable
                                case 'X' %Take gradient wrt RZON = cdfDataR{2}
                                    [~,tempGradData] = gradient(varDataY{entryBoxNumber}(:,:),cdfDataR{2}(:,:),gradientSpacing);
                                case 'XB' %Take gradient wrt RBOUN = cdfData{3}
                                    [~,tempGradData] = gradient(varDataY{entryBoxNumber}(:,:),cdfDataR{3}(:,:),gradientSpacing);
                                otherwise
                                    [~,tempGradData] = gradient(varDataY{entryBoxNumber}(:,:),varDataX{entryBoxNumber},gradientSpacing);
                            end
                            [gradSize,~]=size(tempGradData);
                            tempDataR = repmat(cdfDataR{1}(:,:),1,gradSize)'; %Creates a matrix whose rows are RAXIS = cdfDataR{1}
                            varDataY{entryBoxNumber} = -(tempDataR.*tempGradData./varDataY{entryBoxNumber}(:,:));
                            varNameY{entryBoxNumber} = ['g_{', varNameY{entryBoxNumber},'}'];
                            varUnitsY{entryBoxNumber} = ' \fontsize{7} (normalized)';
                        case 'Partial Position'     
                            switch tempNameX %Get non-normalized independent variable
                                case 'X' %Take gradient wrt RZON = cdfDataR{2}
                                    [~,varDataY{entryBoxNumber}] = gradient(varDataY{entryBoxNumber}(:,:),cdfDataR{2}(:,:),gradientSpacing);
                                    class(varDataY{entryBoxNumber}(:,:))
                                    class(cdfDataR{2}(:,:))
                                    class(varDataY{entryBoxNumber})
                                case 'XB' %Take gradient wrt RBOUN = cdfData{3}
                                    [~,varDataY{entryBoxNumber}] = gradient(varDataY{entryBoxNumber}(:,:),cdfDataR{3}(:,:),gradientSpacing);
                                otherwise
                                    [~,varDataY{entryBoxNumber}] = gradient(varDataY{entryBoxNumber}(:,:),varDataX{entryBoxNumber},gradientSpacing);
                            end
                            varNameY{entryBoxNumber} = ['dx_', varNameY{entryBoxNumber}];
                            varUnitsY{entryBoxNumber} = [varUnitsY{entryBoxNumber},'/cm'];
                        case 'Partial Time'
                            [varDataY{entryBoxNumber},~] = gradient(varDataY{entryBoxNumber}(:,:),varDataT{entryBoxNumber},gradientSpacing);
                            varNameY{entryBoxNumber} = ['dt_', varNameY{entryBoxNumber}];
                            varUnitsY{entryBoxNumber} = [varUnitsY{entryBoxNumber},'/s'];
                    end
                    
                    if ~isempty(gradientMode)
                        %Determine nGrad sign
                        if mean(varDataY{entryBoxNumber}(end,:))>0
                            %Do nothing
                        else
                            varDataY{entryBoxNumber}=-varDataY{entryBoxNumber};
                        end
                    end
                    
                   if dimSize == 1
                       %1D variables are functions of TIME only, which for
                       %consistency, I always treat as column entries.
                        varDataY{entryBoxNumber}=varDataY{entryBoxNumber}';
                   end
                        
                    % If any one-dimensional variables exist, set the
                    % sliderMode to 'position'.  (all 1D variables in
                    % TRANSP CDF files only have dimensions of TIME)
                    tempMin=ones(1,numel(varNameY))*10^(99);
                    for j = 1:numel(varNameY)
                        if ~isempty(varNameY{j})
                            tempMin(j) = min(size(varDataY{j}));
                        end
                    end
                    if min(tempMin) == 1
                        sliderMode='Position';
                        set(sliderModeB1,'enable','off');
                        set(sliderModeB2,'enable','off');
                        set(sliderModeB1,'value',0);
                        set(sliderModeB2,'value',1);
                    elseif strcmp(plotMode,'Line Plot') % sliderMode buttons disabled in 'Heat Map' and 'Surface Plot'
                        set(sliderModeB1,'enable','on');
                        set(sliderModeB2,'enable','on');
                    end
                    varCdfName{entryBoxNumber} = cdfList{activeCdf};
                    for jj=1:numel(varDataT)
                        if ~isempty(varDataT{jj})
                            if strcmp(cdfList{activeCdf},varCdfName{jj})
                                currentCdf = jj;
                            end
                        end
                    end
                   
                        switch sliderMode
                            case 'Time'
                                [sliderMax,~] = size(varDataT{currentCdf});%Slider Depends on first variable only
                            case 'Position'
                                [sliderMax,~] = size(varDataX{currentCdf});%Slider Depends on first variable only
                        end
                        if sliderValue>sliderMax
                            sliderValue=1;
                        end
                        if sliderMax<=1
                            [rowSize,~]=size(cdfDataR{currentCdf});
                            sliderMax=rowSize;
                        end
                    
                   
                    set(sliderH,'max',sliderMax,'sliderStep',[1/sliderMax 10/sliderMax],'value',sliderValue,'enable','on');
                    %             set(cellSelectColH,'string',['Columns: ',plotTitleT,plotUnitsT]);
                    %             set(cellSelectRowH,'string',['Rows: ',plotTitleX,plotUnitsX]);
%                     eval(varNameY{entryBoxNumber})=varDataY{entryBoxNumber}(:,:);
% eval(varNameY{entryBoxNumber})=0

% putvar(varNameX,varDataX);
% putvar(varNameY,varDataY);
%      



                else 
                    systemMsgF(['Error: Variable ''',entryName,''' is not a valid datatype'],'Error');
                end
            else
                systemMsgF('Error, CDF Data Mismatch','Error');
            end
        else %if isempty(entryName)
            
            systemMsgF(['Error: Variable ''',entryName,''' not found in ',deblank(num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))),'.CDF'],'Error');
        end
plotEquation();
              
    end

    function plotEquation()
        
        if errorLevel == 1
            return;
        end
        systemMsgF('','Check');
        
        if ~isempty(varNameY{1}) % plotting script activated only when lead variable is present
            
           
            
            switch plotToggle
                case 'Table'
                    % Table Mode Commands 

                    resizeAxesF();
                    if ishandle(tableTitleH)
                        delete(tableTitleH)
                    end
                    axesHandlesToChildObjects = findobj(axesH, 'Type', 'text');
                    if ~isempty(axesHandlesToChildObjects)
                        delete(axesHandlesToChildObjects);
                    end
                    set(varTitleH,'visible','off');
                    
                    switch plotMode %display vectors based on slider if in 'Line Plot', or full data tables otherwise
                        case 'Line Plot'
                            
                            tempTitle='';
                            
                            for j = 1:numel(varNameY)
                                if ~isempty(varNameY{j})
                                    tempTitle = horzcat([tempTitle,varNameY{j}],', ');
                                   
                                end
                            end
                            tempTitle(end-1:end)=[];
                                                      
                            if ~strcmp(tempTitle,'_{')
                                tempTitle = strrep(tempTitle,'_','\_');% Avoid interpreter errors
                            end
                            plotTitleH =  title(tempTitle);
                            
                            tableTitle = {'\bf ';tempTitle};
                            aP=get(axesH,'position');
    %%%%%%%%%%%%%%%%%%%%%%% NEed to replace this res stuff asap
                            res = cellfun(@(x) [x ''], tableTitle, 'UniformOutput', false);
                            res = cell2mat(res');
                            
                            tableTitleH = text(aP(3)/2, aP(4)+12,res,'units','pixels',...
                                'horiz','center','vert','baseline','fontsize',11,'fontweight','bold') ;
                            
                            columnNames = {};
                            
                            m=min(sliderValue,varSizeY(:,1));% Row Number
                            n=min(sliderValue,varSizeY(:,2));% Column Number
                           
                            
                            switch sliderMode
                                case 'Time'
                                    plotTimeH = text(aP(3)-5, aP(4)+12,['Time = ',num2str(varDataT{1}(round(sliderValue),1),'%.4Gs')],...
                                        'units','pixels','horiz','right','vert','baseline','fontsize',8) ;
                                    tempData = varDataX{1}(1:end,round(sliderValue));
                                    
                                    for j = 1:numel(varNameY)
                                        if ~isempty(varNameY{j})
                                            tempData = horzcat(tempData,varDataY{j}(1:end,n(j)));
                                            columnNames = horzcat(columnNames,varNameY{j});
                                        end
                                    end
                                    columnNames = horzcat(varNameX{1},columnNames);
                                case 'Position'
                                    plotTimeH = text(aP(3)-5, aP(4)+12,[varNameX{1},' = ',num2str(varDataX{1}(round(sliderValue),1),'%.4G '),varUnitsX{1}],...
                                        'units','pixels','horiz','right','vert','baseline','fontsize',8) ;
                                    tempData = varDataT{1}(1:end,1)';
                                    for j = 1:numel(varNameY)
                                        if ~isempty(varNameY{j})
                                            tempData = vertcat(tempData,varDataY{j}(m(j),1:end));
                                            columnNames = horzcat(columnNames,varNameY{j});
                                        end
                                    end
                                    columnNames = horzcat(varNameT{1},columnNames);
                                    tempData=tempData';
                            end %sliderMode
                            
                            %Note: Table GUI data dynamically updated in @CellCallBackFnc
                            set(tableH,'Data',tempData,'ColumnName',columnNames);
                            

                            
                        case {'Heat Map','Surface Plot'}
                            
                            
                            set(varTitleH,'visible','off');
                            tempTitle = {'\bf ';varNameY{1};' - ';varLabelY{1};varUnitsY{1}};
                            aP=get(axesH,'position');
                            
                            tempTitle = cellfun(@(x) [x ''], tempTitle, 'UniformOutput', false);
                            tempTitle = cell2mat(tempTitle');
                            if ~strcmp(tempTitle,'_{')
                                tempTitle = strrep(tempTitle,'_','\_');% Avoid interpreter errors
                            end
                            tableTitleH = text(aP(3)/2, aP(4)+12,tempTitle,'units','pixels',...
                                'horiz','center','vert','baseline','fontsize',11,'fontweight','bold') ;
                            
                            %Note: Table GUI data dynamically updated in @CellCallBackFnc
                            set(tableH,'Data',varDataY{1});
                            
                            set(tableH,'ColumnName',1:1:varSizeY(1,2));
                    end
                       
                case 'Figure'
                    
                    switch plotMode
                        case 'Line Plot'

                            resizeAxesF();
                            
                            set(tableH,'visible','off');
                            set(sliderH,'visible','on')
                            aP=get(axesH,'position');
                            
                            % Set x-axis Plot Boundaries and variables based on sliderMode
                            % Default mode is 'Time'
                            
                            
                            
                            
                            
                            m=min(sliderValue,varSizeY(:,1));% Row Number
                            n=min(sliderValue,varSizeY(:,2));% Column Number
                            
                            
                            maxX=ones(numel(varNameY),1)*(-10^(99));
                            minX=ones(numel(varNameY),1)*10^(99);
                            maxY=ones(numel(varNameY),1)*(-10^(99));
                            minY=ones(numel(varNameY),1)*10^(99);
                            if strcmp(sliderMode,'Time')
                                minX=min(min(varDataX{1}));
                                maxX=max(max(varDataX{1}));
                                varX = varDataX;
                            elseif strcmp(sliderMode,'Position')
                                minX=min(min(varDataT{1}));
                                maxX=max(max(varDataT{1}));
                                varX = varDataT;
                            end
                            %                                if strcmp(axisMode,'Global')
                            %                                    maxY = max(max(max(varDataY{1:end})));
                            %                                    minY = min(min(min(varDataY{1:end})));
                            %                                elseif strcmp(axisMode,'Local')
                            %                                    if strcmp(sliderMode,'Time')
                            %                                        maxY = max(max(varDataY{:}(1:end,sliderValue)));
                            %                                        minY = min(min(varDataY{:}(1:end,sliderValue)));
                            %                                    elseif strcmp(sliderMode,'Position')
                            %                                        maxY = max(max(varDataY{:}(sliderValue,1:end)));
                            %                                        minY = min(min(varDataY{:}(sliderValue,1:end)));
                            %                                    end
                            %                                end
                            if strcmp(axisMode,'Global')
                                for j = 1:numel(varNameY)
                                    if ~isempty(varNameY{j})
                                        tempMax(j) = max(max(varDataY{j}));
                                        tempMin(j) = min(min(varDataY{j}));
                                    end
                                end
                            elseif strcmp(axisMode,'Local')
                                if strcmp(sliderMode,'Time')
                                    for j = 1:numel(varNameY)
                                        if ~isempty(varNameY{j})
                                            tempMax(j) = max(varDataY{j}(1:end,n(j)));
                                            tempMin(j) = min(varDataY{j}(1:end,n(j)));
                                        end
                                    end
                                elseif strcmp(sliderMode,'Position')
                                    for j = 1:numel(varNameY)
                                        if ~isempty(varNameY{j})
                                            
                                            tempMax(j) = max(varDataY{j}(m(j),1:end));
                                            tempMin(j) = min(varDataY{j}(m(j),1:end));
                                        end
                                    end
                                end
                            end % max(plotVariableY(1:rowSize,nY)
                            
                            
                            
                            
                            
                            
                            maxY = max(tempMax);
                            minY = min(tempMin);
                            range = maxY-minY;
                            maxY = maxY+range/100;%slightly extend boundary
                            minY = minY-range/200;%slightly extend boundary
                            
                            % Fix boundaries if they are equal
                            if minY == maxY
                                minY = minY - minY/200 - 1;
                                maxY = maxY + maxY/200 + 1;
                            end
                            
                            
                            % Plotting Loop
                            for j = 1:numel(varNameY)
                                if ~isempty(varNameY{j})
                        
                                    try
                                        % draw 2D line-plot based sliderMode
                                        if strcmp(sliderMode,'Time')
                                           
                                            linePlot{j} = plot(axesH,varDataX{j}(1:1:end,n(j)),varDataY{j}(1:1:end,n(j)),'DisplayName',[strrep(varNameY{j},'_','\_'),', ',strrep(varCdfName{j},'.CDF',''),' (t = ',num2str(varDataT{1}(sliderValue,1),'%.4Gs)')],'LineWidth',lineWidth(j),'LineStyle',lineStyle{j},'marker',lineMarker{j},'MarkerSize',lineMarkerSize(j),'MarkerFaceColor',lineMarkerFill{j},'LineSmoothing','on','tag',num2str(j),'uicontextmenu', cmenu,'buttonDownFcn',@lineCB);
                                        elseif strcmp(sliderMode,'Position')
                                            linePlot{j} = plot(axesH,varX{j}(1:1:end,1),varDataY{j}(m(j),1:1:end),'DisplayName',[strrep(varNameY{j},'_','\_'),', ',strrep(varCdfName{j},'.CDF',''), '(t = ',num2str(varDataT{1}(sliderValue,1),'%.4Gs)')],'LineWidth',lineWidth(j),'LineStyle',lineStyle{j},'marker',lineMarker{j},'MarkerSize',lineMarkerSize(j),'MarkerFaceColor',lineMarkerFill{j},'LineSmoothing','on','tag',num2str(j),'uicontextmenu', cmenu,'buttonDownFcn',@lineCB);
                                        end
%                                         set(linePlot{j}, 'uicontextmenu', lineCB{j});
                                    catch errorMsg
                                        
                                        getReport(errorMsg, 'extended','hyperlinks', 'on')
                                        errorMsgReport = getReport(errorMsg, 'extended','hyperlinks', 'on');
                                        errorMsgReport=textscan(errorMsgReport, '%s', 'Delimiter','\n');
%                                         additionalMsg = [{'Loop iteration: ',num2str(j)};{'Slider Mode: ',sliderMode};{'size(varX{j}): ',num2str(size(varX{j}))};{'size(varDataY{j}): ',num2str(size(varDataY{j}))};{'size m(j)/n(j): ',num2str(size(m(j))),'/',num2str(size(n(j)))}];
                                        try
%                                             finalReport=[errorMsgReport;additionalMsg];
                                             systemMsgF(errorMsgReport,'Console')
                                        catch errorMsg2
                                             getReport(errorMsg2, 'extended','hyperlinks', 'on')
%                                             size(errorMsgReport)
%                                             size(additionalMsg)
                                        end
                                       
                                    end
                                    if j == 1
                                        hold on;
                                    end
                                    set(linePlot{j},'Color',lineColor{j});
                                    
                                   
                                 
                                    % allows multiple line plots to be drawn on one axis

                                end % exist(plotVariableList{j},'var')
                            end % for j = 1:numel(plotVariableList)
                            hold off;
                       
                                                  plotTimeH = text(aP(3)-5, aP(4)+12,'',...
                                    'units','pixels','horiz','right','vert','baseline','fontsize',8) ;


                                  
                              set(axesH,'xgrid',gridMode,'ygrid',gridMode)
                              set(axesH, 'TickDir',tickDirMode)
                              set(axesH, 'Box',axesBoxMode)
                              set(axesH,'xlim',[minX maxX])
                             
                              set(axesH,'ylim',[minY maxY])

                            %% generate plot title and labels
                            
                            tempTitle=[''];
                            for j = 1:numel(varNameY)
                                if ~isempty(varNameY{j})
                                    tempTitle = horzcat([tempTitle,varNameY{j}],', ');
                                end
                            end
                            tempTitle(end-1:end)=[];
                            
                            if ~strcmp(tempTitle,'_{')
                                tempTitle = strrep(tempTitle,'_','\_');% Avoid interpreter errors
                            end
                            plotTitle = tempTitle;
                            plotTitleH =  title(plotTitle);
                            
                            
                            if strcmp(sliderMode,'Time')
                                plotTimeH = text(aP(3)-5, aP(4)+12,['Time = ',num2str(varDataT{1}(n(1),1),'%.4Gs')],...
                                    'units','pixels','horiz','right','vert','baseline','fontsize',8) ;
%                                 set (plotMaxH, 'string', ['Max = ',num2str(max(varDataY{1}(1:1:end,n(1))),' %.4G')]);
%                                 set (plotMinH, 'string', ['Min  = ',num2str(min(varDataY{1}(1:1:end,n(1))),' %.4G')]);
                                xlabel(axesH,['(',strrep(varNameX{1},'_','\_'),') ',varLabelX{1},varUnitsX{1}],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            elseif strcmp(sliderMode,'Position')
                                plotTimeH = text(aP(3)-5, aP(4)+12,[varNameX{1},' = ',num2str(varDataX{1}(m(1),1),'%.4G '),varUnitsX{1}],...
                                    'units','pixels','horiz','right','vert','baseline','fontsize',8) ;
%                                 set (plotMaxH, 'string', ['Max = ',num2str(max(varDataY{1}(m(1),1:1:end)),' %.4G')]);
%                                 set (plotMinH, 'string', ['Min  = ',num2str(min(varDataY{1}(m(1),1:1:end)),' %.4G')]);
                                xlabel(axesH,['(',strrep(varNameT{1},'_','\_'),') ',varLabelT{1},varUnitsT{1}],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            end

                            
                            ylabel(axesH,[varLabelY{1},varUnitsY{1}],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            set(plotTitleH, 'FontSize',11,'fontweight','bold','buttonDownFcn',@editFigureLabelCB);
                            legendH = legend(axesH,'show');
                            set(legendH, 'FontSize',8,'Box','on','location',legendLocation,'interpreter','tex');
                            
%                             gtext('Note this divergence!') 
%                              %places texton plot using mouse
%                                  
                            % OpenGL fails for data values of absolute
                            % magnitude >= 10^22 
                            if strcmp(get(figH,'renderer'),'OpenGL') && (maxY >= 10^(22) || (minY < -10^(22)))
                                set(figH,'renderer','painters')
                                systemMsgF('Graphics renderer failed, switching to ''Painters''','Msg');
                                for j=1:numel(rendererH)
                                    set(rendererH{j},'checked','off');
                                end
                                set(rendererH{3}, 'Checked', 'on');
                            end
                 
                        case 'Heat Map';
                            resizeAxesF();
                            set(sliderH,'visible','off');
                            [rowSize,colSize]=size(varDataY{1});
                            %         plotEquation();
                            % heatmap(varDataY{1}, '$%0.2g');
                            
                            
                            
                            heatMapH = imagesc((1:1:colSize)/colSize,(1:1:rowSize)/rowSize,varDataY{1},'parent',axesH);
%                              imagemenu(heatMapH)
                            colorBarH = colorbar('units','pixels','location','southoutside');
                            aP=get(axesH,'position');
                            set(colorBarH,'position',[aP(1) 25 aP(3) 12]);
                            
                            ylabel(axesH,[varLabelX{1},' \fontsize{7} (normalized)'],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            xlabel(axesH,[varLabelT{1},' \fontsize{7} (normalized)'],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            
                            tempTitle=[varNameY{1},' - ',varLabelY{1},varUnitsY{1}];
                            if ~strcmp(tempTitle,'_{')
                                tempTitle = strrep(tempTitle,'_','\_');% Avoid interpreter errors
                            end
                            plotTitleH =  title(tempTitle);
                            

                            
                            
                            
                            
                            set(plotTitleH, 'FontSize',11,'fontweight','bold','buttonDownFcn',@editFigureLabelCB);
                            tP=  get(plotTitleH,'position');
                            set(plotTitleH,'position',[tP(1) tP(2)+0.01 tP(3)]);
%                             set (plotMaxH, 'string', ['Max = ',num2str(max(max(varDataY{1})),' %.4G')]);
%                             set (plotMinH, 'string', ['Min  = ',num2str(min(min(varDataY{1})),' %.4G')]);
                            
                        case 'Surface Plot'

                         if min(min(size(varDataY{1})))>1
                             resizeAxesF();
 
                            varY=double(varDataY{1});

                            switch surfaceGrid
                                case 'Surface Grid'
                                    
                                    %                             heatMapH= mesh(axesH,x,y,varY(1:end,1:end));%,'XData',([1:1:c,1:1:r])%,'YData',T2(1:r,1:r))
                                    %                             heatMapH= surf(axesH,x,y,varY(1:end,1:end),'edgecolor','none','edgelighting','phong','AmbientStrength',0.3,'FaceColor','texturemap',...
                                    %                                 'SpecularColorReflectance',.1);%,'XData',([1:1:c,1:1:r])%,'YData',T2(1:r,1:r))
                                    stepy=varSizeY(1,2)/50;
                                    stepx=varSizeY(1,1)/40;
                                    [y,x]=meshgrid((1:stepy:varSizeY(1,2))/varSizeY(1,2),(1:stepx:varSizeY(1,1))/varSizeY(1,1));
                                    heatMapH= surf(axesH,x,y,varY(1:stepx:end,1:stepy:end));
                                    
                                case 'Mesh Grid'
                                    stepy=varSizeY(1,2)/50;
                                    stepx=varSizeY(1,1)/40;
                                    [y,x]=meshgrid((1:stepy:varSizeY(1,2))/varSizeY(1,2),(1:stepx:varSizeY(1,1))/varSizeY(1,1));
                                    heatMapH= mesh(axesH,x,y,varY(1:stepx:end,1:stepy:end),'linewidth',1);
                                case 'Surface Texture'
                                    [y,x]=meshgrid((1:1:varSizeY(1,2))/varSizeY(1,2),(1:1:varSizeY(1,1))/varSizeY(1,1)); % normalized
                                    heatMapH= surf(axesH,x,y,varY(1:end,1:end),'edgecolor','none','edgelighting','phong','faceLighting','phong','AmbientStrength',0.3,'FaceColor','texturemap',...
                                        'SpecularColorReflectance',.1);%,'XData',([1:1:c,1:1:r])%,'YData',T2(1:r,1:r))
                            end
                            % ,'YData',V_time_Value(1:r,1)
                            %                             colormap('Jet');
                            camlight right;
                            ylabel(axesH,[varLabelT{1},char(10),'\fontsize{7} (normalized)'],'FontSize',10,'horiz','center','buttonDownFcn',@editFigureLabelCB);
                            xlabel(axesH,[varLabelX{1},char(10),'\fontsize{7} (normalized)'],'FontSize',10,'horiz','center','buttonDownFcn',@editFigureLabelCB);
                            zlabel(axesH,[varLabelY{1},varUnitsY{1}],'FontSize',10,'buttonDownFcn',@editFigureLabelCB);
                            
                            tempTitle=[varNameY{1},' - ',varLabelY{1}];
                            if ~strcmp(tempTitle,'_{')
                                tempTitle = strrep(tempTitle,'_','\_');% Avoid interpreter errors
                            end
                            plotTitleH =  title(tempTitle);
                            
                            set(plotTitleH, 'FontSize',11,'fontweight','bold','units','pixels','horiz','center','buttonDownFcn',@editFigureLabelCB);
                            tP=get(plotTitleH,'position');
                            set(plotTitleH,'position',[tP(1) tP(2)+10 tP(3)]);
                            rotate3dH = rotate3d(axesH);
rotate3d(axesH);
                            set(rotate3dH,'enable','on','ActionPostCallback',@rotatePostCB);
                           
                            switch get(figH,'renderer')
                                case 'OpenGl'
                                    set(rotate3d,'RotateStyle','orbit');
                                case 'painters' % Painters is much slower at rendering than OpenGL
                                    set(rotate3d,'RotateStyle','box');
                            end
%  surfmenu(axesH)
%   surfmenu(heatMapH)
                         else
                             systemMsgF('Error: Cannot render surface plot for one-dimensional variables','Warning');
                             cla reset;
                         end % if min min size varDataY{1} > 1
                         
                    end % switch plotMode
                    
            end % switch plotToggle
        else % if exist('plotTitleY','var')
            % reset the interface if the first entry box is empty
            
            cla reset;
            set (plotMinH, 'string','');
            set (plotMaxH, 'string','');
            if  strcmp(plotToggle,'Table') %avoids bugs due to cla command
                set(axesH,'visible','off');
            end
        end
    end % plotEquation();

    function resizeF(varargin)
       if testMode==1 disp('resize called');end;
        set(0, 'currentfigure', figH);
        % Figure resize callback
        % Adjust object positions so that they maintain appropriate proportions

        fP = get(figH, 'Position');
        resizeAxesF();
        % fP(1) = figure x-position
        % fP(2) = figure y-position
        % fP(3) = figure width
        % fP(4) = figure height
        
        % Set GUI Positioning Variables
        header0Start = fP(4)-65;
        header1Start = header0Start - 55;
        
        header3Start = header1Start-98;
        header2Start = header3Start-48;
        
        guiSpacing=17;
        
        % Entry Box Positions, Used for loading variables as well
                
        entryBoxPos = {...
            [fP(3)-110, header2Start-20,    95, 18];...
            [fP(3)-110, header2Start-40,    95, 18];...
            [fP(3)-110, header2Start-60,    95, 18];...
            [fP(3)-110, header2Start-80,    95, 18];...
            [fP(3)-110, header2Start-100,	95, 18];...
            [fP(3)-110, header2Start-120,	95, 18];};
        
        for j=1:1:numel(entryBoxH)
            set(entryBoxH{j},'Position',  entryBoxPos{j});
        end
        
        entryBoxPos7 = [fP(3)-110, header2Start-160, 95     , 18       ];
        % set(plotListCDF,'Position',[fP(3)-160, cdfPlotDataStart-25, 150      , 20       ]);

        set(sliderH, 'Position', [70       , 10, fP(3)-210, 22       ]);
        set(tableH  , 'Position', [70      , 84, fP(3)-215, fP(4)-135]);
        set(splashH  , 'Position', [70      , 84, fP(3)-215, fP(4)-135]);
        set(sliderModeH,'Position',[fP(3)-125, header3Start-16, 100      , 16       ]);
        set(sliderModeB1,'Position',[0 0 60 16]);
        set(sliderModeB2,'Position',[50 0 60 16]);
        %     set(globalValuesH,'Position', [fP(3)-160, globalTimeStart, 100, 15]);
        set(textHeader0H,'Position', [fP(3)-130, header0Start, 100, 15]);
        set(textHeader1H,'Position', [fP(3)-130, header1Start, 100, 15]);
        set(textHeader2H,'Position',[fP(3)-130, header2Start, 100, 15]);
        set(textHeader3H,'Position',[fP(3)-130, header3Start, 100, 15]);
        set(entryLabel1H,'Position',  [fP(3)-125, header2Start-20, 20      , 16       ]);
        set(entryLabel2H,'Position',  [fP(3)-125, header2Start-40, 20      , 16       ]);
        set(entryLabel3H,'Position',  [fP(3)-125, header2Start-60, 20      , 16       ]);
        set(entryLabel4H,'Position',  [fP(3)-125, header2Start-80, 20      , 16       ]);
        set(entryLabel5H,'Position',  [fP(3)-125, header2Start-100, 20      , 16       ]);
        set(entryLabel6H,'Position',  [fP(3)-125, header2Start-120, 20      , 16       ]);
%         if testMode==1
%             set(commandBoxH,'Position',  entryBoxPos7);   
%         end
set(activeCdfH,'Position', [fP(3)-125, header0Start-guiSpacing, 105, 16]);
        set(runidH,'Position', [fP(3)-125, header1Start-guiSpacing, 100, 15]);
        set(dataH,'Position', [fP(3)-125, header1Start-2*guiSpacing, 100, 15]);
        set(dimensionsH,'Position', [fP(3)-125, header1Start-3*guiSpacing, 100, 15]);
        set(dimensions2H,'Position', [fP(3)-125, header1Start-4*guiSpacing, 100, 15]);
        %         set(mmmPlotDataH,'Position', [fP(3)-160, header3Start, 100, 15]);
        set(plotMaxH,'Position',  [fP(3)-125, header2Start-12*guiSpacing+11, 160, 15]);
        set(plotMinH,'Position', [fP(3)-125 header2Start-13*guiSpacing+11 160 15]);
        %         set(plotMaxH2,'Position', [fP(3)-160 header3Start-3*guiSpacing+4 160 15]);
        %         set(plotMinH2,'Position', [fP(3)-160 header3Start-4*guiSpacing+4 160 15]);
        %             set(plotColH,'Position', [fP(3)-160, globalTimeStart-guiSpacing, 160, 15]);
        set(toggleH,'Position', [fP(3)-125, 10, 110, 24]);
%         set(exportDataH,'Position', [fP(3)-125, 35, 110, 24]);
        set(varTitleH,'Position', [120, fP(4)-50, fP(3)-345, 20]);
        set(systemMsgH,'Position',[40,fP(4)-20, fP(3)-145, 15]);
        
        aP=get(axesH,'position');
        if ishandle(tableTitleH) set(tableTitleH,'position',[aP(3)/2, aP(4)+12]);end
        if ishandle(plotTimeH) set(plotTimeH,'Position',[aP(3), aP(4)+12]);end
        if ishandle(colorBarH) set(colorBarH,'position',[aP(1) 25 aP(3) 12]);end
        
    end

    function resizeAxesF()
        % Only resizes the axes; called when a full resize is unnecessary.
        
        fP = get(figH, 'Position');
        if strcmp(plotMode,'Surface Plot') && strcmp(plotToggle,'Figure')
            set(axesH  , 'Position', [90      , 84, fP(3)-255, fP(4)-145]);
        else
            set(axesH  , 'Position', [70      , 84, fP(3)-215, fP(4)-135]);
        end
        
    end

    function systemMsgF(inputMessage,inputType)
        % Displays an error message over the axes
        
        if strcmp(inputType,'Error')
            % Sets figure error message
            %     disp('error called')
            errorLevel =1;
            set(systemMsgH,  'string',inputMessage,...
                'foregroundColor','red');
            
         elseif strcmp(inputType,'Warning')
            % Sets figure error message
            %         disp('message called')
            set(systemMsgH,  'string',inputMessage,...
                'foregroundColor','red');
                       
        elseif strcmp(inputType,'Msg')
            % Sets figure error message
            %         disp('message called')
            set(systemMsgH,  'string',inputMessage,...
                'foregroundColor',[0 0.4 0]);
            
        elseif strcmp(inputType,'Clear')
            % Removes the error message
            %     disp('Clear Called')
            errorLevel = 0;
            set(systemMsgH,  'string','');

            
        elseif strcmp(inputType,'Check')
            % Removes system/error message if there's no error
            % Enforces error if errorLevel
            %       disp('Check Called')
            if errorLevel == 0
                set(systemMsgH,'string','');
            end
        elseif strcmp(inputType,'Console')
            if findobj('type','figure','name','Console')
                  consoleFigH=findobj('type','figure','name','Console');
        consoleOutputH=findobj(consoleFigH,'tag','Console Window');
        consoleHistoryH=findobj(consoleFigH,'tag','Console History');
        oldStr=get(consoleOutputH,'string');
        
       
      
            str = inputMessage;

            str
            class(str)
                 str=strcat('       ',str);
                class(str)
     

%        
        
        
        
             
              str = [oldStr;' ';'Console Message: ';str];
                set(consoleOutputH,'string',str);
                index = size(get(consoleOutputH,'string'), 1); %get how many items are in the list box
%                 set(consoleOutputH,'ListboxTop',index); %set the index of last item to be the index of the top-most string displayed in list box.
            %         disp('did nothing')
        end
        
        end
    end

    function plotToggleF(varargin)
%         disp('Plot Toggle Called')
        systemMsgF('','Check');
        
        if strcmp(plotToggle,'Figure')
            % Switch from plot to table mode
            
            plotToggle = 'Table';
            % cla(axesH);
            rotate3d off;
            
            switch plotMode
                case {'Heat Map','Surface Plot'}
                    set(sliderH,'visible','off');
                    set(heatMapH,'visible','off');
                    if ishandle(colorBarH) set(colorBarH,'visible','off');end;
                case 'Line Plot'
                    set(plotColH,'string','');
                    set(sliderH,'visible','on');
                    if ishandle(plotTimeH) set(plotTimeH,'string','');end;
            end
            
            set(axesH,'visible','off');
            waitfor(axesH,'visible','off');
            cla(axesH);

%             set(exportDataH,'string','Export Table');
           
            set(exportFigureMH,'enable','off');
            set(exportTableMH,'enable','on');
            %  Remove any remaining elements on axesH
%             axesHandlesToChildObjects = findobj(axesH, 'Type', 'line');
%             if ~isempty(axesHandlesToChildObjects)
%                 delete(axesHandlesToChildObjects);
%             end
%             axesHandlesToChildObjects = findobj(axesH, 'Type', 'text');
%             if ~isempty(axesHandlesToChildObjects)
%                 set(axesHandlesToChildObjects,'visible','off');
%             end
            if ishandle(legendH)
                delete(legendH);
            end
            
            set(toggleH,'string','Toggle Plot');
            set(varTitleH,'visible','on');
            
            set(tableH,'visible','on');
            
        elseif strcmp(plotToggle,'Table')
            % Switch from table to plot mode
            
            plotToggle = 'Figure';
            rotate3d off;
            set(sliderH,'visible','on');
            %             set(exportDataH,'string','Export Figure');
            switch plotMode
                case 'Line Plot'
                    set(axesH,'visible','on');
                    set(sliderH,'visible','on');
                case 'Heat Map'
                    if ishandle(colorBarH) set(colorBarH,'visible','on');end;
                    set(sliderH,'visible','off');
                case 'Surface Plot'
                    set(sliderH,'visible','off');
                    rotate3d on;
                    
            end
            set(tableH,'visible','off');
            set(varTitleH,'visible','off');
            set(toggleH,'string','Toggle Spreadsheet');
                        set(exportFigureMH,'enable','on');
            set(exportTableMH,'enable','off');
            
        end
        
        
        if ~isempty(varNameY{1})
            plotEquation();
        end
    end

    function plotModeCB(source,eventdata)
        systemMsgF('','Check');
      if testMode>0  disp('Plot Mode Called'); end
        
        plotMode = strrep(strrep(get(source,'Label'),'&',''),' (default)','');
        
        for j=1:numel(plotModeH)
            set(plotModeH{j},'checked','off');
        end
        
        rotate3d off;
        set(gcbo, 'Checked', 'on');
%         switch plotToggle
%             case 'Figure'
                switch plotMode

                    case 'Line Plot'
                        if ishandle(heatMapH)
                            set(heatMapH,'visible','off');
                        end
                        if ishandle(colorBarH)
                            set(colorBarH,'visible','off');
                        end
                        set(surfaceGridHM,'visible','off');
                        set(sliderH,'visible','on');
                        set(gridModeHM,'enable','on');
                        set(axisModeHM,'enable','on');
                        set(legendLocationHM,'enable','on');
                        set(axesBoxModeHM,'enable','on');
%                         set(colorModeHM,'visible','on');
                        set(colorMapHM,'visible','off');
                        set(axisModeHM,'visible','on');
                    tempMin=ones(1,5)*10^(99); % Determine if any 1D variables exist
                    for j = 1:numel(varNameY)
                        if ~isempty(varNameY{j})
                            tempMin(j) = min(size(varDataY{j}));
                        end
                    end
                    
                    if min(tempMin) == 1
                        sliderMode='Position';
                        set(sliderModeB1,'enable','off');
                        set(sliderModeB2,'enable','off');
                        set(sliderModeB1,'value',0);
                        set(sliderModeB2,'value',1);
                    elseif strcmp(plotMode,'Line Plot') % sliderMode buttons disabled in 'Heat Map' and 'Surface Plot'
                        set(sliderModeB1,'enable','on');
                        set(sliderModeB2,'enable','on');
                    end

                    case 'Heat Map'
                        if ishandle(heatMapH)
                            set(heatMapH,'visible','on');
                        end
                        if ishandle(colorBarH)
                            set(colorBarH,'visible','on');
                        end
                        set(sliderH,'visible','off');
                        set(sliderModeB1,'enable','off');
                        set(sliderModeB2,'enable','off');
                        set(surfaceGridHM,'visible','off');                      
                        set(gridModeHM,'enable','off');
                        set(axisModeHM,'enable','off');
                        set(legendLocationHM,'enable','off');
                        set(axesBoxModeHM,'enable','off');
%                         set(colorModeHM,'visible','off');
                        set(colorMapHM,'visible','on');
                        set(axisModeHM,'visible','off');
                    case 'Surface Plot'
                        if ishandle(heatMapH)
                            set(heatMapH,'visible','on');
                        end
                        if ishandle(colorBarH)
                            set(colorBarH,'visible','off');
                        end
                        if strcmp(get(figH,'renderer'),'painters')
                            systemMsgF('Warning: Surface plot rotation using Painters rendering mode is extremely slow','Error') 
                        end
                        if strcmp(plotToggle, 'Figure')
                            rotate3d on;
                        end
                        set(surfaceGridHM,'visible','on');
                        set(sliderH,'visible','off');
                        set(sliderModeB1,'enable','off');
                        set(sliderModeB2,'enable','off');
                        set(gridModeHM,'enable','off');
                        set(axisModeHM,'enable','off');
                        set(legendLocationHM,'enable','off');
                        set(axesBoxModeHM,'enable','off');
%                         set(colorModeHM,'visible','off');
                        set(colorMapHM,'visible','on');
set(axisModeHM,'visible','off');
                end
%             case 'Table'
%                 %Do Nothing For Now
%         end
%         
        if ~isempty(varNameY{1})
            plotEquation();
        end
    end

    function exportDataF(hObj,event) % This is a huge mess :(
        
        systemMsgF('','Clear');
        
        set(figH,'PaperPositionMode','auto');
        %         set(figH,'PaperOrientation','landscape');
        if ~isempty(varNameY{1})
            runid = deblank(num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid')));
            
            if ~exist(deblank(num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))),'file')
                mkdir(deblank(num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))));
            end
            fileName = [deblank(num2str(netcdf.getAtt(ncid{activeCdf},varid{activeCdf},'Runid'))),'\'];
            
            %                 fullPath=cd(cd(fileparts(fileName)))
            
            switch plotToggle
                
                case 'Table'
                    try
                        tempData = get(tableH,'Data');
                        
                        switch plotMode
                            
                            case {'Heat Map','Surface Plot'}
                                fileName = horzcat(fileName,[deblank(strrep(varNameY{1},'\nabla','g')),' - ',runid]);
                            case 'Line Plot'
                                tempTitle='';
                                for jj = 1:numel(varNameY)
                                    if ~isempty(varNameY{jj})
                                        tempTitle = horzcat([tempTitle,deblank(strrep(varNameY{jj},'\nabla','g'))],', ');
                                    end
                                end
                                tempTitle(end-1:end)=[];
                                tempTitle=strrep(tempTitle,' ','');
                                fileName = horzcat(fileName,[tempTitle,' - ',runid,' ',num2str(round(sliderValue))]);
                                switch sliderMode
                                    case 'Time'
                                        fileName = horzcat(fileName,'T');
                                    case 'Position'
                                        fileName = horzcat(fileName,'X');
                                end
                        end
                        fileName = strrep(fileName,'{','');% no braces in output
                        fileName = strrep(fileName,'}','');
                        
                        if exist([fileName,'.csv'],'file')
                            
                            for jj=2:99
                                if ~exist([fileName,' (',num2str(jj),')','.csv'],'file')
                                    fileName = horzcat(fileName,' (',num2str(jj),')','.csv');
                                    break
                                end
                            end
                            
                        else
                            fileName = horzcat(fileName,'.csv');
                        end

                        dlmwrite(fileName,tempData,'delimiter',',');
                        
                        %                     fullPath=cd(cd(fileparts(fileName)));
                        %                     fid = fopen(fileName, 'w');
                        %                     for j=1:rowSize
                        %                         fprintf(fid,'%d ,',tempData(j,:));
                        %                     end
                        %                     fclose(fid);
                        systemMsgF(['Successful Export -- ',fileName],'Msg');
                    catch
                        systemMsgF('Unknown export error, please try again','Error');
                        % The console tells me that it cannot access some
                        % .ps file in the temp directory (occurs
                        % infrequently during .pdf exports).  The error
                        % appears to randomly occur and can be hard to
                        % reproduce.
                         
                    end
                case 'Figure'
                    
                    try
%                         if ishandle(plotTitleH)   set(plotTitleH,'interpreter','latex');    end
%                         if ishandle(plotTimeH)   set(plotTimeH,'interpreter','latex');    end

%                         if strcmp(plotMode,'Line Plot') % use painters for exporting lineplots
%                             tempRenderer  = get(figH,'renderer');
%                             set(figH,'renderer','painters');
%                         end
                        
                        
                        %                 plotTitle = strrep(plotTitle,'\nabla','$\nabla$');
                        %                 set(plotTitleH,'string',plotTitle);
                        
                        backgroundColorF('white');
                        
                        
                        
                        switch plotMode
                            
                            case 'Heat Map'
                                fileName = horzcat(fileName,deblank(strrep(varNameY{1},'\nabla','g')),' - ',runid,' H');
                                
                            case 'Surface Plot'
                                fileName = horzcat(fileName,deblank(strrep(varNameY{1},'\nabla','g')),' - ',runid,' S');
                                
                            case 'Line Plot'
                                tempTitle='';
                                for j = 1:numel(varNameY)
                                    if ~isempty(varNameY{j})
                                        tempTitle = horzcat([tempTitle,varNameY{j}],', ');
                                    end
                                end
                                tempTitle(end-1:end)=[];
                                tempTitle=strrep(tempTitle,' ','');
                                
                                switch sliderMode
                                    case 'Time'
                                        fileName = horzcat(fileName,deblank(strrep(tempTitle,'\nabla','g')),' - ',runid,' ',num2str(round(sliderValue)),'T');
                                    case 'Position'
                                        fileName = horzcat(fileName,deblank(strrep(tempTitle,'\nabla','g')),' - ',runid,' ',num2str(round(sliderValue)),'X');
                                end
                                
                        end
                        
                        fileName = strrep(fileName,'{','');% no braces in output
                        fileName = strrep(fileName,'}','');
                        
                        filetype = '.eps';% Set export filetype here
                        % Naming scheme not working with .eps?
                       
                        if exist([fileName,filetype],'file')
                            for j=2:99
                                if ~exist([fileName,' (',num2str(j),')',filetype],'file')
                                    fileName = horzcat(fileName,' (',num2str(j),')',filetype);
                                    break
                                end
                            end
                            
                        else
                            fileName = horzcat(fileName,filetype);
                        end
                        set(figH,'PaperPositionMode','auto');
%                          set(figH, 'PaperSize', [5 5]); %Keep the same paper size
                        set(figH, 'PaperPosition', [-0.5 -0.25 7.5 5]); %Position the plot further to the left and down. Extend the plot to fill entire paper.
                        %                         laprint( 1, 'Figure6' );
                        %                         laprint(gcf,'peaks-nice','width',9,...
                        % 'asonscreen','off','keepfontprops','on',...
                        % 'factor',1,'scalefonts','off','mathticklabels','on')
                        % set(figH, 'PaperSize', [1 5]); %Keep the same paper size
                        %                         print(figH, '-dpdf','-noui','-r300', fileName);
                        switch plotMode
                            case {'Line Plot','Heat Map'}
                                print(figH,'-depsc','-noui','-painters',fileName);
                            case 'Surface Plot'
                                set(heatMapH,'facecolor','interp');
                                colorModeF(colorMap,512)
                                print(figH,'-depsc','-noui','-opengl',fileName);
                                colorModeF(colorMap,64)
                                set(heatMapH,'facecolor','texturemap');
                        end
%                         export_fig fileName
                        try 
                            winopen(fileName)
                        end
                        backgroundColorF('gray');
                        
%                         if strcmp(plotMode,'Line Plot') 
%                             set(figH,'renderer',tempRenderer);
%                         end
                        systemMsgF(['Successful Export -- ',fileName],'Msg');
                    catch
                        disp('in catch')
%                         if strcmp(plotMode,'Line Plot') 
%                             set(figH,'renderer',tempRenderer);
%                         end
%                         backgroundColorF('gray');
                        systemMsgF('Unknown export error, please try again','Error');
                        % The console tells me that it cannot access some
                        % .ps file in the temp directory (occurs
                        % infrequently during .pdf exports).  The error
                        % appears to randomly occur and can be hard to
                        % reproduce.
%                         if ishandle(plotTitleH)   set(plotTitleH,'interpreter','tex');    end
%                         if ishandle(plotTimeH)   set(plotTimeH,'interpreter','tex');    end
                    end %try
            end
            
        else % if ~isempty(varNameY{1})
            systemMsgF('Error: Primary variable not loaded','Warning');
        end
    end

    function openConsoleCB(val,evt)
        if ~isempty(findobj('type','figure','name','Console'))
            close(findobj('type','figure','name','Console'))
        end
        % % % >>  who -regexp \<dummy.*\>

        consoleFigH = figure(3);
        set(consoleFigH, 'name','Console');
        set(consoleFigH,'Position',[100,100,800,418]);
%         putvar(dummy1, dummy2, dummy3, dummy4)
        consoleOutputH = uicontrol(consoleFigH,'style','listbox','position',[10,27,630,365],'tag','Console Window','horizontalAlignment','left','BackgroundColor','w','max',3);
        consoleHistoryH = uicontrol(consoleFigH,'style','list','position',[640,27,150,365],'tag','Console History','horizontalAlignment','left','BackgroundColor','w');
        uicontrol('Style', 'text',...
            'String', 'Command Window',...
            'Units','Pixels','fontsize',10,...
            'HorizontalAlignment','center','position',[11,392,628,16],...
            'FontWeight','bold');
        uicontrol('Style', 'text',...
            'String', 'Command History','fontsize',10,...
            'Units','Pixels',...
            'HorizontalAlignment','center','position',[640,392,150,16],...
            'FontWeight','bold');
        commandBoxH = uicontrol(consoleFigH,'style', 'edit','position',[10,10,780,18],'BackgroundColor','w',...
            'string' , '','tag','Command Box','horizontalAlignment','left', ...
            'enable','on',...
            'callback', {@commandBoxCB});
        
    end
    function commandBoxCB(source,eventdata)
        
        % % %          try
        % % % mmmCounter = eval(get(source,'string'))
        % % %          catch
        fileName = 'Console Output\Message';
        if ~exist('Console Output','file')
            mkdir('Console Output');
        end
        
        if exist([fileName,'.txt'],'file')
            
            for j=2:99999
                if ~exist([fileName,' (',num2str(j),')','.txt'],'file')
                    fileName = horzcat(fileName,' (',num2str(j),')','.txt');
                    break
                end
            end
            
        else
            fileName = horzcat(fileName,'.txt');
        end
        diary(fileName)
        commandStr=strrep(get(source,'string'),'>> ','');
        set(0, 'currentfigure', figH);
        try
            if ~strcmp(commandStr,'clc')
                set(gcbo,'string','');
                eval(commandStr)
            else
                set(consoleOutputH,'string',' ');
                 set(gcbo,'string','');
                return
            end
            errorMsg='';
        catch errorMsg
            %     errorMsg
            errorMsgReport = getReport(errorMsg, 'extended','hyperlinks', 'on');
            errorMsgReport=textscan(errorMsgReport, '%s', 'Delimiter','\n');
            
            % errorMsgReport{1};
            % errorMsgReport{1}{1}
            % errorMsgReport{1}{4}
            
            %     errorMsg=lasterr
            
        end
        % % %          end
        set(gcbo,'string','');
        diary off
        
        fid = fopen(fileName,'r');  % Open text file
        consoleFigH=findobj('type','figure','name','Console');
        consoleOutputH=findobj(consoleFigH,'tag','Console Window');
        consoleHistoryH=findobj(consoleFigH,'tag','Console History');
        oldStr=get(consoleOutputH,'string');
        oldStrh=get(consoleHistoryH,'string');
        
        if isempty(errorMsg)
            
            str = textscan(fid, '%s', 'Delimiter','\n');
            
            if numel(str)>1
                str(1)=[];
            end
            str=strcat({'       '},str{1});
            
        else
            
            %             str=strsplit(errorMsg,'\n')';
            str=strcat({'<HTML><div style="color:red;link:red;margin-left:16px;">'},errorMsgReport{:,1},{'</div></HTML>'});
        end
        
        
        switch commandStr
            case 'clc'
                %                  set(consoleOutputH,'value',1);
                
                set(consoleOutputH,'string',['']);
                disp(get(consoleOutputH,'string'))
                isempty(get(consoleOutputH,'string'))
                if get(consoleOutputH,'value')<get(consoleOutputH,'ListboxTop')
                    set(consoleOutputH,'ListboxTop',get(consoleOutputH,'value'))
                    disp('clc if called')
                end
            otherwise
                
                
                str = [oldStr;' ';['>> ',commandStr];str];
                    set(consoleHistoryH,'string',[oldStrh;{commandStr}]);
                set(consoleOutputH,'string',str);
                if ~isempty(get(consoleOutputH,'string'))
                index = length(get(consoleOutputH,'string'));
                end

%                 index(2)
                %                 index2 = numel(get(consoleOutputH,'string'), 1)%get how many items are in the list box
%                 set(consoleOutputH,'value',index(1))

                
             
                
               


                %set the index of last item to be the index of the top-most string displayed in list box.
                if get(consoleOutputH,'value')>get(consoleOutputH,'ListboxTop')
%                     disp(get(consoleOutputH,'ListboxTop'))
%                     disp(get(consoleOutputH,'value'))
%                     set(consoleOutputH,'value',1)
                    disp('set to 1 on top')
                elseif isempty(get(consoleOutputH,'value'))
                    set(consoleOutputH,'value',1)
                    disp('reset to 1')
                    disp(get(consoleOutputH,'ListboxTop'))
                end
        end

    
        fclose(fid);
         if ~isempty(get(consoleOutputH,'string'))
        set(findobj(3,'tag','Console Window'),'ListboxTop',index)
                 else 
             set(consoleOutputH,'value',1)

         end
        % Make this optional at some point
        %         delete(fileName);
        
        
        
        
        %         plotEquation();
    end
    function openVarListF(val,evt)
        close(findobj('type','figure','name','Variable List'))
        varListFigH = figure(2);
        set(varListFigH, 'name','Variable List');
        set(varListFigH,'Position',[100,100,730,420])
         
%         
      
% % % %                 sort(varListTRANSP .');
            
             
                
      ncDataType = 'single';
                     j=1:numel(varListTRANSP);
                     tempData = {finfo{activeCdf}.Variables(1,j).Datatype};
                     tempData = tempData(strncmp(tempData,ncDataType,6));
                     cdfVarCount = numel(tempData);
                     varListTotal = cell(cdfVarCount,11);
                     %         tempNames = {finfo{activeCdf}.Variables(1,j).Name};
                     for j =1:cdfVarCount
                         
                         %               varListTotal(j,6)={num2str(j)};
                         %                     case 'Name' % 0.03/1.26s
                         %                         stringID{j} = {strjoin({finfo{activeCdf}.Variables(1,j).Name,num2str(j)},';')};
                         varListTotal(j,1) = {finfo{activeCdf}.Variables(1,j).Name};
                         %                     case 'Description' %0.03s/1.27s
                         %                         stringID(j,1) = {strjoin({deblank(finfo{activeCdf}.Variables(1,j).Attributes(1,2).Value),num2str(j)},';')};
                         varListTotal(j,2) = {deblank(finfo{activeCdf}.Variables(1,j).Attributes(1,2).Value)};
                         %                     case 'Size' % 0.32s/1.64s
                         
                         tempSize = finfo{activeCdf}.Variables(1,j).Size;
                         if numel(tempSize) == 1
                             varListTotal(j,3) = {num2str(tempSize)};
                         elseif  numel(tempSize) == 2
                             varListTotal(j,3) = {[num2str(tempSize(1,1)),' x ',num2str(tempSize(1,2))]};
                         end
                         %                     case 'Dimensions' % 0.06s/1.48s
                         
                         tempSize= numel(finfo{activeCdf}.Variables(1,j).Dimensions);
                         if tempSize == 1
                             varListTotal(j,4) = {finfo{activeCdf}.Variables(1,j).Dimensions(1,1).Name};
                         elseif  tempSize == 2
                             varListTotal(j,4) = {[finfo{activeCdf}.Variables(1,j).Dimensions(1,1).Name,', ',finfo{activeCdf}.Variables(1,j).Dimensions(1,2).Name]};
                         end
                         
                         %                     case 'Units' % 0.03s/1.25s
                         %                         varListTotal(j,5) = stringCleaner({finfo{activeCdf}.Variables(1,j).Attributes(1,1).Value},'TableUnits');
                         varListTotal(j,5) = {deblank(finfo{activeCdf}.Variables(1,j).Attributes(1,1).Value)};
                         %                         stringID(j,1)={strjoin({deblank(finfo{activeCdf}.Variables(1,j).Attributes(1,1).Value),num2str(j)},';')};
                         
                         
                     end
                     
                     
   


         

            j=1:cdfVarCount;
            varListTotal(:,6) = strtrim(cellstr(num2str(j')))';
     
inputData = [varListTotal(:,1)';varListTotal(:,6)';tempData];% concatenate them verally
inputData = inputData(:)';% flatten the result
inputData = strjoin([ncDataType,inputData]);
inputData= strsplit(inputData,ncDataType)';
inputData(1) =[];
inputData(end) = [];
varListTotal(:,7) = sort(inputData);

inputData = [varListTotal(:,2)';varListTotal(:,6)';tempData];   % concatenate them verally
inputData = inputData(:)';% flatten the result
inputData = strjoin([ncDataType,inputData]);
inputData= strsplit(inputData,ncDataType)';
inputData(1) =[];
inputData(end) = [];
varListTotal(:,8) = sort(inputData);

inputData = [varListTotal(:,3)';varListTotal(:,6)';tempData];   % concatenate them verally
inputData = inputData(:)';% flatten the result
inputData = strjoin([ncDataType,inputData]);
inputData = strsplit(inputData,ncDataType)';
inputData(1) =[];
inputData(end) = [];
varListTotal(:,9) = sort(inputData);

inputData = [varListTotal(:,4)';varListTotal(:,6)';tempData];   % concatenate them verally
inputData = inputData(:)';% flatten the result
inputData = strjoin([ncDataType,inputData]);
inputData = strsplit(inputData,ncDataType)';
inputData(1) =[];
inputData(end) = [];
varListTotal(:,10) = sort(inputData);

inputData = [varListTotal(:,5)';varListTotal(:,6)';tempData];   % concatenate them verally
inputData = inputData(:)';% flatten the result
inputData = strjoin([ncDataType,inputData]);
inputData = strsplit(inputData,ncDataType)';
inputData(1) =[];
inputData(end) = [];
varListTotal(:,11) = sort(inputData);

%     varListSorted =[varListTotal(:,1),varListTotal(:,2),varListTotal(:,3),varListTotal(:,4),varListTotal(:,5),varListTotal(:,6)];
    

varListSorted= varListTotal(:,1:6);


[rowSize,colSize]=size(varListSorted);
        buttonColor = [240/255,240/255,240/255];
%         [240/255,240/255,240/255]
        varListTableH = uitable(varListFigH,'Units','Pixels',...
            'Position', [10      , 10, 710,400],...
            'Data', varListSorted,...
            'ColumnWidth',{80 220 70 90 100},'CellSelectionCallback',@CellCallBack2,...
            'ColumnName',{'Name','Description','Size','Dimensions','Units','Variable ID'},...
            'RowName',1:rowSize);
        nameBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Name</div>','Position',[66      , 390, 79,19],...
    'enable','on','tag','varListTotal(:,7)','backgroundColor',buttonColor,...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
        descriptionBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Description</div>','Position',[146      , 390, 219,19],...
    'enable','on','tag','varListTotal(:,8)','backgroundColor',buttonColor,...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
        sizeBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Size</div>','Position',[366      , 390, 69,19],...
    'enable','on','tag','varListTotal(:,9)','backgroundColor',buttonColor,...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
        dimensionsBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Dimensions</div>','Position',[436      , 390, 89,19],...
    'enable','on','tag','varListTotal(:,10)','backgroundColor',buttonColor,...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
        unitsBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Units</div>','Position',[527      , 390, 98,19],...
    'enable','on','tag','varListTotal(:,11)','backgroundColor',buttonColor,...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
        variableBH = uicontrol(varListFigH,'Style', 'pushbutton',...
    'string','<html><div style="color:rgb(24,90,169);font-weight:bold">Variable ID</div>','Position',[627      , 390, 70,19],...
    'enable','on','tag','cdfVarCount',...
    'Units','Pixels',...
    'HorizontalAlignment','center',...
    'callback',{@tableSorterCB});
try
jButton = java(findjobj(nameBH));



jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);

jButton = java(findjobj(descriptionBH));

jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);
jButton = java(findjobj(sizeBH));

jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);
jButton = java(findjobj(dimensionsBH));

jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);
jButton = java(findjobj(unitsBH));

jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);
jButton = java(findjobj(variableBH));

jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
jButton.setFlyOverAppearance(true);
end

    end


    function tableSorterCB(source,event)
        
        sortedTag=get(source,'tag');
        tableTag=get(varListTableH,'tag');
        sortedInput = eval(get(source,'tag'));
     
        if strcmp(sortedTag,tableTag)
            
            varListSorted=flipud(varListSorted);
            
       
        elseif ~iscell(sortedInput)
            varListSorted = varListTotal(:,1:6);
          
        else
            possibleLocations=strfind(deblank(sortedInput),' ')';
            locationID = cell(1,cdfVarCount);
            sortedIndexNum = cell(1,cdfVarCount);
            sortedOutput = cell(1,cdfVarCount);
            for j = 1:cdfVarCount % gives location of index
                locationID{j} = max(possibleLocations{j});
                sortedIndexNum{j}=sortedInput{j}(locationID{j}:end);
                sortedOutput{j} = sortedInput{j}(1:locationID{j});
            end
            sortedIndexNum = sortedIndexNum';
            sortedOutput = sortedOutput';
            
            
            
            
            for j=1:numel(sortedOutput)
                
                tempID = eval(sortedIndexNum{j});
                
                varListSorted(j,1) = varListTotal(tempID,1);
                varListSorted(j,2) = varListTotal(tempID,2);
                varListSorted(j,3) = varListTotal(tempID,3);
                varListSorted(j,4) = varListTotal(tempID,4);
                varListSorted(j,5) = varListTotal(tempID,5);
                varListSorted(j,6) = {num2str(tempID)};
                
            end
            
            
            
           
            
        end
       
         set(varListTableH,'Data', varListSorted);
         set(varListTableH,'tag',sortedTag);
    end
%% Supporting Functions

    function [outputTitle,outputVariable,outputLabel,outputUnits] = loadVarF(inputName)
        % Load CDF Data based on string input
        
        tempID = netcdf.inqVarID(ncid{activeCdf},inputName);
        outputTitle = netcdf.inqVar(ncid{activeCdf},tempID);
        outputVariable = netcdf.getVar(ncid{activeCdf},tempID);
        outputLabel = stringCleanerF(ncreadatt(filePath,inputName,'long_name'),'Label');
        outputUnits = stringCleanerF(ncreadatt(filePath,inputName,'units'),'Units');
        
    end

    function sliderF(varargin)
        % Slider callback, Modifies the sliderValue
        
        systemMsgF('','Check');
%         systemMsgF('Console Test','Console');
        sliderValue = round(get(varargin{1}, 'Value'));
        m=min(sliderValue,varSizeY(:,1));% Row Number
        n=min(sliderValue,varSizeY(:,2));% Column Number
        switch plotToggle
            case 'Table'
                switch sliderMode
                    case 'Time'
                        tempData = varDataX{1}(1:end,round(sliderValue));
                        set(plotTimeH,'string',['Time = ',num2str(varDataT{1}(sliderValue,1),'%.4Gs')]);
                        for j = 1:numel(varNameY)
                            if ~isempty(varNameY{j})
                                tempData = horzcat(tempData,varDataY{j}(1:end,n(j)));
                            end
                        end
                    case 'Position'
                        set(plotTimeH,'string',[varNameX{1},' = ',num2str(varDataX{1}(sliderValue,1),'%.4G '),varUnitsX{1}] ); 
                        tempData = varDataT{1}(1:end,1)';
                        for j = 1:numel(varNameY)
                            if ~isempty(varNameY{j})
                                tempData = vertcat(tempData,varDataY{j}(n(j),1:end)); 
                            end
                        end
                        tempData=tempData';
                end %sliderMode
                set(tableH,'Data',tempData);
            case 'Figure'
        switch sliderMode
            case 'Time'
                for j=1:numel(linePlot)
                    if ishandle(linePlot{j})
                        if strcmp(cdfList{activeCdf},varCdfName{j})
                        set(linePlot{j},'YData',varDataY{j}(1:1:end,n(j)),'DisplayName',[strrep(varNameY{j},'_','\_'),', ',strrep(varCdfName{j},'.CDF',''), ' (t = ',num2str(varDataT{j}(sliderValue,1),'%.4Gs)')]);
                        end
                    end
                end
%                 set(plotTimeH,'string',['Time = ',num2str(varDataT{1}(sliderValue,1),'%.4Gs')]);
            case 'Position'
                for j=1:numel(linePlot)
                    if ishandle(linePlot{j})
                        set(linePlot{j},'YData',varDataY{j}(n(j),1:1:end));
                    end
                end
                set(plotTimeH,'string',[varNameX{1},' = ',num2str(varDataX{1}(sliderValue,1),'%.4G '),varUnitsX{1}] );  
        end
        
        if strcmp(axisMode,'Local')
            switch sliderMode
                case 'Time'
                    for j = 1:numel(varNameY)
                        if ~isempty(varNameY{j})
                            tempMax(j) = max(varDataY{j}(1:end,n(j)));
                            tempMin(j) = min(varDataY{j}(1:end,n(j)));
                        end
                    end
                case 'Position'
                    for j = 1:numel(varNameY)
                        if ~isempty(varNameY{j})
                            
                            tempMax(j) = max(varDataY{j}(m(j),1:end));
                            tempMin(j) = min(varDataY{j}(m(j),1:end));
                        end
                    end
            end
            
            
            maxY = max(tempMax);
            minY = min(tempMin);
            range = maxY-minY;
            maxY = maxY+range/100;%slightly extend boundary
            minY = minY-range/200;%slightly extend boundary
            
            % Fix boundaries if they are equal
            if minY == maxY
                minY = minY - 1;
                maxY = maxY + 1;
            end
            
            maxY = maxY+(maxY-minY)/100;%slightly extend boundary
            minY = minY-(maxY-minY)/200;%slightly extend boundary
            
            % Fix boundaries if they are equal
            if minY == maxY
                minY = minY - 1;
                maxY = maxY + 1;
            end
            set(axesH,'ylim',[minY,maxY]);
        end
        end
        
        set(sliderH,'Value',sliderValue);
        drawnow
    end

    function plotMovieF(varargin)
%         [strVariable,data]=getcsv('normal');
OptionZ.FrameRate=15;OptionZ.Duration=5.5;OptionZ.Periodic=true;
 CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10],'WellMadeVid2',OptionZ)

%         eval(strVariable)=data
%         for k = 1:sliderMax
%             for j = 1:numel(varNameY)
%                 if ishandle(linePlot{j})  set(linePlot{j},'YData',varDataY{j}(:,k)); end
%             end
%             if ishandle(sliderH) set(sliderH,'Value',k); end
%             if ishandle(plotTimeH) set(plotTimeH,'string',['Time = ',num2str(varDataT{1}(k,1),'%.4Gs')]); end
%             drawnow
%         end
      
    end
    function output = inqDimidF(input)
        % Return CDF Dimension Info
        
        tempID = netcdf.inqDimID(ncid{activeCdf},input);
        [outputName,outputValue] = netcdf.inqDim(ncid{activeCdf},tempID);
        if outputName == 'X'
            outputName = '# ZONES';
        elseif outputName == 'TIME'
            outputName = '# TIMES';
        end
        output = [outputName, ' = ', num2str(outputValue)];
    end

    function outputString = stringCleanerF(inputString, inputType)
        % Clean up data taken from CDF file
        
        inputString = deblank(inputString);
        if strcmp(inputType,'Units')
            if size(inputString)
                inputString = strrep(inputString, '**', '^');
                inputString = strrep(inputString, 'RADIANS', 'rad') ;
                inputString = strrep(inputString, 'RAD', 'rad') ;
                inputString = strrep(inputString, 'CM3', 'cm^3') ;
                inputString = strrep(inputString, 'CM2', 'cm^2') ;
                inputString = strrep(inputString, 'CM', 'cm') ;
                inputString = strrep(inputString, 'cm^3/cm', 'cm^4') ;
                inputString = strrep(inputString, 'cm^2/cm', 'cm^3') ;
                inputString = strrep(inputString, 'cm/cm', 'cm^2') ;
                inputString = strrep(inputString, 'Tesla', 'T') ; 
                inputString = strrep(inputString, 'TESLA', 'T') ; 
                inputString = strrep(inputString, 'SECONDS', 's') ;
                inputString = strrep(inputString, 'VOLTS', 'V') ;
                inputString = strrep(inputString, 'VOLT', 'V') ;
                inputString = strrep(inputString, 'SEC', 's') ;
                inputString = strrep(inputString, 'GRAMS', 'g') ;
                inputString = strrep(inputString, 'Nt-M', 'N*m') ;
                inputString = strrep(inputString, 'NtM', 'N*m') ;
                inputString = strrep(inputString, 'S2', 's^2') ;
                inputString = strrep(inputString, 'S3', 's^2') ;
                inputString = strrep(inputString, 's^3/s', 's^4') ;
                inputString = strrep(inputString, 's^2/s', 's^3') ;
                inputString = strrep(inputString, 's/s', 's^2') ;

                inputString = strrep(inputString, 'WATTS', 'W');
                inputString = strrep(inputString, 'JLES', 'J') ;
                inputString = strrep(inputString, 'AMPS', 'A') ;
                inputString = strrep(inputString, 'WEBERS', 'Wb') ;
                inputString = strrep(inputString, 'AMP', 'A') ;
                inputString = strrep(inputString, 'EV', 'eV') ;
                inputString = strrep(inputString, 'OHMS', '\Omega ') ;
                inputString = strrep(inputString, 'OHM', '\Omega ') ;
                inputString = strrep(inputString, 'Pascals', 'Pa') ;
                inputString = strrep(inputString, 'ARBITRARY UNITS', 'Arb. Units') ;
                inputString = strrep(inputString, 'N/', '#/') ;
                outputString = [' [',inputString,']'];
%                 inputString = strrep(inputString, '#', '\#') ; % Latex 
%         
%                 outputString = ['$\bigl[\mathrm{',inputString,'}\bigr]$'];

                
            else outputString = ''; % needed to avoid errors
            end
        elseif strcmp(inputType,'TableUnits')
            inputString = strrep(inputString, 'RAD', 'rad') ;
            inputString = strrep(inputString, 'CM', 'cm') ;
            inputString = strrep(inputString, 'SECONDS', 's') ;
            inputString = strrep(inputString, 'SEC', 's') ;
            inputString = strrep(inputString, '#', 'N') ;
            outputString = strrep(inputString, '**', '^');
        elseif strcmp(inputType,'Label')
            outputString = regexprep(lower(inputString),'(\<[a-z])','${upper($1)}');
            outputString = strrep(outputString, '**', '^');
            outputString = strrep(outputString, 'Exb', 'ExB');
            outputString = strrep(outputString, 'Nc', 'NC');
            outputString = strrep(outputString, 'X"R/A"', 'R/A');
        end
    end

    function CellCallBack(hObj,event)
        
        systemMsgF('','Check');
        
        if numel(event.Indices)
            [rowSize,colSize]=size(varDataY{1});
            
            %             set (plotColH, 'string', ['Row ',num2str(event.Indices(1)),': ',plotTitleX,' = ',num2str(plotVariableX(event.Indices(1),event.Indices(2)),'%.4G'),plotUnitsX]);
            %             set (plotTimeH, 'string', ['Col ',num2str(event.Indices(2)),': ',plotTitleT,' = ',num2str(plotVariableT(event.Indices(2),1),'%.4G'),plotUnitsT]);
%             set (plotMaxH, 'string', ['Max = ',num2str(max(varDataY{1}(1:rowSize,event.Indices(2))),' %.4G')]);
%             set (plotMinH, 'string', ['Min  = ',num2str(min(varDataY{1}(1:rowSize,event.Indices(2))),' %.4G')]);
            if isempty(varNameT{1})
                set (plotTimeH, 'string', ['Col ',num2str(event.Indices(2))]);
            end
        end
    end

    function CellCallBack2(hObj,event)
        
        systemMsgF('','Check');
        set(0, 'currentfigure', figH);
        if numel(event.Indices)
            m = event.Indices(1);
            set(entryBoxH{1},'string',varListSorted(m,1));
            entryLoadF(varListSorted(m,1),1);
            
        end
        figure(2);
        
        
    end

    function backgroundColorF(inputString)
        
        if strcmp(inputString,'white')
            backgroundColor = [1 1 1];
        elseif strcmp(inputString,'gray')
            backgroundColor = [0.9 0.9 0.9];
        end
        
        set(gcf, 'color', backgroundColor);
        set(globalValuesH,'BackgroundColor', backgroundColor);
        
        uicontrolList = [runidH,dataH,dimensionsH,dimensions2H,mmmPlotDataH,plotMinH2,systemMsgH,textHeader1H,textHeader2H,textHeader3H,plotMinH,textHeader0H,entryLabel1H,entryLabel2H,entryLabel3H,entryLabel4H,entryLabel5H,entryLabel6H,plotMaxH,plotMinH2,plotMaxH2,plotColH,plotTimeH,varTitleH,sliderModeB1,sliderModeB2,sliderModeH];
        
        for j=1:numel(uicontrolList)
            if ishandle(uicontrolList(j))
            set(uicontrolList(j),'BackgroundColor', backgroundColor);
            end
        end
        
    end

    function sliderModeCB(source,eventdata)
        % disp(source);
        % disp([eventdata.EventName,'  ',...
        %      get(eventdata.OldValue,'String'),'  ', ...
        %      get(eventdata.NewValue,'String')]);
        %         disp(get(get(source,'SelectedObject'),'String'));
        sliderMode = get(get(source,'SelectedObject'),'String');
        if strcmp(sliderMode,'Time')
            sliderValueX = get(sliderH,'value');
            sliderValue=sliderValueT;
        elseif strcmp(sliderMode,'Position')
            sliderValueT = get(sliderH,'value');
            sliderValue=sliderValueX;
        end

    for jj=1:numel(linePlot)
                    if ishandle(linePlot{jj})
                        if strcmp(cdfList{activeCdf},varCdfName{jj})
                            currentCdf = jj;
                        end
                    end
                end
        if ~isempty(varNameY{activeCdf})
            if strcmp(sliderMode,'Time')
                [sliderMax,~] = size(varDataT{currentCdf});%Slider Depends on first variable only
            elseif strcmp(sliderMode,'Position')
                [sliderMax,~] = size(varDataX{currentCdf});%Slider Depends on first variable only
            end
            if sliderValue>sliderMax
                sliderValue=1;
            end
            set(sliderH,'max',sliderMax,'sliderStep',[1/sliderMax 10/sliderMax],'value',sliderValue,'enable','on');
            

            plotEquation();
        end
      
    end

    function rendererCB(source,eventdata)
        rendererMode = strrep(strrep(get(source,'Label'),'&',''),' (default)','');
        set(figH,'renderer',rendererMode);
        for j=1:numel(rendererH)
            set(rendererH{j},'checked','off');
        end
        set(gcbo, 'Checked', 'on');
        if strcmp(plotMode,'Surface Plot')
            systemMsgF('Warning: Surface plot rotation using Painters rendering mode is extremely slow','Error') 
        end
        if ~isempty(varNameY{1})
            plotEquation();
        end
    end

    function plotOptionsCB(source,eventdata)
        % This function might be slightly hard to follow due to the use of
        % multiple eval() commands, but it was designed to be a low to no
        % maintenance function that need not be updated when new menu
        % options are added to the gui, provided that the correct naming
        % and labeling format is followed. The naming scheme is:
        %
        %                Menu Sections   = 'sectionNameHM'
        %                Section Handles = 'sectionNameH'
        %                Variable Name   = 'sectionName'
        
        menuHandle = get(gcbo,'tag');
        optionHandle = menuHandle(1:end-1);
        variableName = optionHandle(1:end-1);
        optionValue = strrep(get(source,'Label'),'&',''); 
        % For example, consider the 'tickDirModeMH' menu section; the
        % following variables would be:
        %
        %               menuHandle   = tickDirModeHM
        %               optionHandle = tickDirModeM
        %               variableName = tickDirMode
        %               optionValue  = 'on' | 'off'

        eval([variableName '= optionValue;']);
        % For the 'tickDirModeMH' example, this will set global variable
        % 'tickDirMode' equal to either 'on' or 'off'.
        
        for j=1:numel(eval(optionHandle))
            set(eval([optionHandle,'{', int2str(j),'}']),'checked','off');
        end
        % In the same example, loop through all members of 'tickDirModeH'
        % and uncheck each of their respective checkbox values.
        
        set(gcbo, 'Checked', 'on');
        % Turn on the calling optionHandle 'checked' value
        
        switch menuHandle
            case 'axesBoxModeHM'
                tickDirMode = strrep(optionValue,'On','In');
                tickDirMode = strrep(tickDirMode,'Off','Out');
            case {'colorModeHM','colorMapHM'}
              
                colorModeF(optionValue,64)
                return % don't redraw plot for colormap
        end
        % Optional additional arguments 
      
        
        if ~isempty(varNameY{1})
            plotEquation();
        end
        % Update the plot if the primary variable is loaded
        
    end %plotOptionsCB
    function colorModeF(source,event)
        
        switch plotMode
%             case 'Line Plot'
%                 
%                 switch source
%                     case 'Default'
%                         colorMode = 1;
%                     case 'Apple'
%                         colorMode = 2;
%                     case 'Prism'
%                         colorMode = 3;
%                     case 'Grayscale'
%                         colorMode = 4;
%                 end
%                 if ~isempty(varNameY{1})
%                     plotEquation();
%                 end
                
            case {'Heat Map','Surface Plot'}
                
                switch source
                    case 'Jet'
                        colormap(jet(event))
                    case 'Hsv'
                        colormap(hsv(event))
                    case 'Bone'
                        colormap(bone(event))
                end
        end
    end
        
  
    

    function editFigureLabelCB(source,eventdata)
                
% % %          try
% % % mmmCounter = eval(get(source,'string'))
% % %          catch
             set(gcbo,'editing','on');
            
% % %          end
       


        
    end

    function rotatePostCB(source,eventdata)
                           systemMsgF('','Clear');
    end
function titlecallback(obj, eventdata)
old = get(gca, 'title');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new title:', 'New image title', 1, oldstring);
if ~isempty(new)
set(old, 'string', new);
end
end
% Menu callback
function xaxiscallback(obj, eventdata)
old = get(gca, 'xlabel');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new X-axis label:', 'New image X-axis label', 1, oldstring);
if ~isempty(new)
set(old, 'string', new);
end
end
% Menu callback
function yaxiscallback(obj, eventdata)
old = get(gca, 'ylabel');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new Y-axis label:', 'New image Y-axis label', 1, oldstring);
if ~isempty(new)
set(old, 'string', new);
end
end
%% Junkyard

% h = findobj('Parent', axesH);
% fig2H = figure(3);			% Create a new figure
% hNewAxes = axes; 			% Create an axes object in the figure
% copyobj(h, hNewAxes);
%          title(plotTitleY,'FontSize',11, 'FontWeight','bold');
%
%             xlabel(['(',strrep(plotTitleX,'_','\_'),') ',plotLabelX,plotUnitsX],'FontSize',10);
%             ylabel([plotLabelY,plotUnitsY],'FontSize',10);
%             legendH = legend([strrep(plotTitleY,'_','\_'),' (CDF)']);


%             [rowSize2,~] =size(plotVariableY2);
%
%
%             if max(m)>rowSize2 || max(m)>rowSize3 || max(m)>rowSize4
%                 disp(max(m))
%                 disp(rowSize2)
%                 systemMsgF('Error: Dimension mismatch between variables','Error');
%                 return
%             else



% %         % Dynamically update Gui Data:
% %         set (plotColH, 'string', ['Var Size = [',num2str(rowSize),'x',num2str(colSize),']']);
% %         set (plotTimeH, 'string', ['Col ',num2str(n),': ',plotTitleT,' = ',num2str(plotVariableT(n,1),'%.4G'),plotUnitsT]);
% %         if strcmp(plotTitleT,'none')
% %              set (plotTimeH, 'string', '');
% %         end

%     function myPlotFcnMMM(hObj,event)
%         % Load MMM variable data based off of drop down menu selection
%         % Data is prestored in the variable format: M_name
% 
%         systemMsgF('','Check');
% 
%         val = get(hObj,'Value');
%         if strcmp('none',varListMMM{val})
%             plotTitleY2 = '';
%         else
%             varNameY{6} = strrep(varListMMM{val},' ','');
%             varDataY{6} = eval(['M_',varNameY{6}])';
%             varDataX{6} = varDataX{1};
%             varDataT{6} = varDataT{1};
% %             plotLabelY2 = tempVar{2};
% %             plotVariableY2 = eval(['M_',plotTitleY2]);
% %         end
% 
%         plotEquation();
%     end %Not Needed
%     end
%     function output = dropDownListMMM(input)
%         % Generate string for GUI drop down menu from an input variable list
%         
%         [~,colSize]=size(input);
%         for j=1:colSize
%             if j == 1
%                 output = [' ',input{1}];
%             else
%                 output = [output,'| ',input{j}];
%             end
%         end
%     end %Not Needed

    function cleanupF(varargin)
%       try
%         try 
% %             netcdf.close(ncid{activeCdf})
% %         catch
% %             
% %         end
%         if ~isempty(findobj('type','figure','name','Console'))
try
            delete(3);
end
%         end
%         if ~isempty(findobj('type','figure','name','Variable List'))
try
            delete(2);
end
%         end
%         
        delete(findobj('type','figure','name','CDF Viewer'));%Suicide
%         catch errorMsg
%             getReport(errorMsg, 'extended','hyperlinks', 'on');
%           
%       end
    end






function [strVariable,thisdata] = getcsv(varargin)


style='normal';


    hExcel      = NaN;          % handle to Excel server
    hBook       = NaN;          % handle to Excel workbook
    hSheet      = NaN;          % handle to Excel worksheet
    strFilename = '';           % name of Excel file
    strVariable = '';           % variable name, to be pushed to the
                                % base workspace
    xlsRaw      = [];           % raw data from Excel file
    xlsNum      = [];           % numerical data from Excel file
    xlsDates    = [];           % numerical dates from Excel file
    xlsTxt      = [];           % string data from Excel file
    rng         = zeros(1,4);   % selected range
    tblFontSize = 8;            % size of font in uitable

    vsizeGUI = 420; hsizeGUI = 670;     % size of GUI
    vspace = 18;    hspace = 24;        % vert and horiz spacing
    hpb = 105;      vpb = 30;           % size of pushbuttons
    smallspace = 5;                     % small space
    vpu = 24;                           % vert size of popup menu

% *** create but hide the GUI as it is being constructed *****************
 hGUI = figure(4);
    set(hGUI,...
        'Visible'        ,'off',...
        'Units'          ,'pixel',...
        'WindowStyle'    ,'normal',...
        'Position'       ,[0,0,hsizeGUI,vsizeGUI],...
        'MenuBar'        ,'none',...
        'NumberTitle'    ,'off',...
        'Resize'         ,'on',...
        'ResizeFcn'      ,{@resizeGUI});
    
    if nargin > 0
        try
            set(hGUI,'WindowStyle',style);
        catch e
            id = e.identifier;
            msg = ['getxls: argument must be one of the following: ',...
                '''normal'', ''modal'', or ''docked''.\n',e.message];
            error(id,msg);
        end
    end
    
% *** populate the GUI with objects **************************************
% Note that at this point the positions and sizes of the objects are not
% specified. They will be set later in 'resizeGUI'.

    htblData = uitable(...
        'RowName'        ,'numbered',...
        'ColumnName'     ,'numbered',...
        'FontSize'       ,tblFontSize,...
        'CellSelectionCallback', {@tblData_CellSelectionCallback});
    hpbLoadXLS = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'Load CSV File',...
        'TooltipString'  ,'Select Excel workbook to load',...
        'Callback'       ,{@pbLoadXLS_Callback});
    hpbWriteVariable = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'Write to Variable',...
        'Enable'         ,'off',...
        'TooltipString'  ,'Store selected data in variable',...
        'Callback'       ,{@pbWriteVariable_Callback});
%     hpbWriteMcode = uicontrol(...
%         'Style'          ,'pushbutton',...
%         'String'         ,'Generate M-File',...
%         'Enable'         ,'off',...
%         'TooltipString'  ,'Generate script to import automatically',...
%         'Callback'       ,{@pbWriteMcode_Callback});
%     hpuSheets = uicontrol(...
%         'Style'          ,'popupmenu',...
%         'String'         ,{''},...
%         'Enable'         ,'off',...
%         'TooltipString'  ,'Select the sheet to use in the Excel workbook',...
%         'BackgroundColor',[1 1 1],...
%         'Callback'       ,{@puSheets_Callback});
%     hpuType = uicontrol(...
%         'Style'          ,'popupmenu',...
%         'String'         ,{'Raw Data','Numerical','Dates','Text'},...
%         'Enable'         ,'off',...
%         'TooltipString'  ,'Choose what kind of data to import',...
%         'BackgroundColor',[1 1 1],...
%         'Callback'       ,{@puType_Callback});
    hedVariable = uicontrol(...
        'Style'          ,'edit',...
        'String'         ,'',...
        'Enable'         ,'off',...
        'TooltipString'  ,['Specify the name of the variable that will ',...
                           'contain the data'],...
        'BackgroundColor',[1 1 1],...
        'KeyPressFcn'    ,{@edVariable_KeyPressFcn});
%     htbRowCol = uicontrol(...
%         'Style'          ,'togglebutton',...
%         'String'         ,'No Headings',...
%         'Value'          ,false,...
%         'TooltipString'  ,'Hide or show row/column headings',...
%         'Callback'       ,{@tbRowCol_Callback});
%     hpbSmaller = uicontrol(...
%         'Style'          ,'pushbutton',...
%         'String'         ,'-',...
%         'TooltipString'  ,'Make font smaller',...
%         'Callback'       ,{@pbSmaller_Callback});
%     hpbLarger = uicontrol(...
%         'Style'          ,'pushbutton',...
%         'String'         ,'+',...
%         'TooltipString'  ,'Make font larger',...
%         'Callback'       ,{@pbLarger_Callback});
    
    % *** prepare output arg (if requested) **********************************

    if nargout > 0
        % collect all handles
        handles = struct('GUI',hGUI, 'tblData',htblData, ...
            'pbLoadXLS',hpbLoadXLS, 'pbWriteVariable',hpbWriteVariable, ...
            'pbWriteMcode',hpbWriteMcode, ...
            'puSheets',hpuSheets, 'puType',hpuType, ...
            'edVariable',hedVariable, 'tbRowCol',htbRowCol, ...
            'pbSmaller',hpbSmaller, 'pbLarger',hpbLarger);
    end

% *** finalize appearance of GUI *****************************************

    % no element is adjusted automatically on resize ('units' are
    % not 'normalized')
    set([hGUI,htblData,hpbLoadXLS,hpbWriteVariable,...
        hedVariable],'Units','pixel');
    resizeGUI();                % size and position all elements
    if ~strcmp(get(hGUI,'WindowStyle'),'docked')
        movegui(hGUI,'center')  % move it to the center of the screen
    end
    settitle('(no file)');      % set title of GUI
    % the GUI should never become the 'current figure'
    set(hGUI,'HandleVisibility','off');
    set(hGUI,'Visible','on');   % now show it

% *** functions for adjusting the GUI ************************************

    % position all the objects of the GUI
    % all objects remain fixed; only the table object adjusts size
    function resizeGUI(varargin)
        % get current position of GUI
        p = get(hGUI,'Position'); hsizeGUI = p(3); vsizeGUI = p(4);
        % tblData
        hsize = hsizeGUI-hpb-3*hspace; vsize = vsizeGUI-2*vspace;
        hpos = hspace; vpos = vspace;   
        % avoid negative sizes
        hsize = max(hsize,1); vsize = max(vsize,1);
        set(htblData, 'Position', [hpos,vpos,hsize,vsize]);
        % pbLoadXLS
        hpos = hsizeGUI-hpb-hspace; hsize = hpb;
        vpos = vsizeGUI-vspace-vpb;
        set(hpbLoadXLS, 'Position', [hpos,vpos,hsize,vpb]);
        % puSheets
%         vpos = vpos-vpu-smallspace;
%         set(hpuSheets, 'Position', [hpos,vpos,hsize,vpu]);
%         % puType
%         vpos = vpos-vpu-smallspace;
%         set(hpuType, 'Position', [hpos,vpos,hsize,vpu]);
        % pbWriteVariable
        vpos = vpos-vpb-3*smallspace;
        set(hpbWriteVariable, 'Position', [hpos,vpos,hsize,vpb]);
        % edVariable
        vpos = vpos-vpu-smallspace;
        set(hedVariable, 'Position', [hpos,vpos,hsize,vpu]);
        % pbWriteMcode
%         vpos = vpos-vpb-4*smallspace;
%         set(hpbWriteMcode, 'Position', [hpos,vpos,hsize,vpb]);
        %
        % tbRowCol and pbSmaller and pbLarger are placed in the lower right
        % corner of the GUI. However, they are hidden if they get in the
        % way of pbWriteMcode.
%         p = get(hpbWriteMcode,'Position');
        if vspace+2*vpb + smallspace > p(2);
%             set([hpbSmaller,hpbLarger,htbRowCol],'Visible','off');
        else
%             % pbSmaller/pbLarger
%             set([hpbSmaller,hpbLarger,htbRowCol],'Visible','on');
%             vpos = vspace;
%             set(hpbSmaller, 'Position', [hpos,vpos,hsize/2,vpb]);
%             set(hpbLarger, 'Position', [hpos+hsize/2,vpos,hsize/2,vpb]);
%             % tbRowCol
%             vpos = vpos+vpb;
%             set(htbRowCol, 'Position', [hpos,vpos,hsize,vpb]);
        end
    end
    
    % set the title of the GUI
    function settitle(str)
        set(hGUI,'Name',[' GET XLS : ',str]);
    end
    
    % close open files and COM server when quitting
  function cleanup(varargin)

  
    end

function pbLoadXLS_Callback(varargin)
        % ask user which file to import
        FilterSet = {'*.csv;*.txt','CSV/TXT Files (*.csv, *.txt)'};
        [FileName,PathName] = ...
            uigetfile(FilterSet,'Select Excel file to import');
        if ~isequal(FileName,0)         % not cancelled
            strFilename = fullfile(PathName,FileName);
%             success = ConnectWithExcel();
%             if success
                settitle(strFilename);  % set title of GUI
%                 UpdateSheetlist();      % update list of available sheets
                readCSVfile();          % read data from XLS file
%                 UpdateTable();          % show in GUIs table
                rng = zeros(1,4);       % selected range
                % enable a few objects on the GUI that start to make sense
                % if a file has been loaded
                set(hpbWriteVariable,'Enable','on');
                set(hedVariable,'Enable','on');
%                 set(hpbWriteMcode,'Enable','on');
%                 set(hpuSheets,'Enable','on');
%                 set(hpuType,'Enable','on');
%             else
                % restore previous strFilename
                strFilename = get(hGUI,'Name');
                strFilename = strFilename(12:end);
%             end
        end
    end
    function UpdateSheetlist()
        nbSheets = hBook.Sheets.Count;
        coll = cell(1,nbSheets);
        for s = 1:nbSheets
            coll{s} = hBook.Sheets.Item(s).Name;
        end
        set(hpuSheets,'String',coll);
        set(hpuSheets,'Value',1);
        hSheet = get(hBook.Sheets,'item',1);
    end
function readCSVfile()
       data = csvread(strFilename);
       set(htblData,'Data',data);
    end

%     function UpdateTable()
%         data = GetChosenData();
%         set(htblData,'Data',data);
%     end
function data = GetChosenData()
        data = get(htblData,'Data');
        
    end

 function PushVariable()
        strVariable = get(hedVariable,'String');
        if isempty(strVariable)
            warndlg('Please select a variable name first.',...
                'Missing Variable Name');
        else
            data = GetChosenData(); % read in the data
            if numel(rng) < 4 || any(rng == 0)  % no range selected ...
                thisdata = data;                % ... so import everything
            else
                % restrict to selected range
                thisdata = data(rng(1):rng(3),rng(2):rng(4));
            end
            try
                % push data into variable in base workspace
%                 size(thisdata)
%                 assignin('caller',strVariable,thisdata);
varDataY{4}=single(thisdata);
varNameY{4}=strVariable;
varDataX{4}=varDataX{1};
varDataT{4}=varDataT{1};
[varSizeY(4,1),varSizeY(4,2)]=size(varDataY{4});

%                 fprintf('(variable ''%s'' has been assigned)\n', strVariable);
%                 putvar(eval(strVariable));
        catch errorMsg
            %     errorMsg
            errorMsgReport = getReport(errorMsg, 'extended','hyperlinks', 'on');
            errorMsgReport=textscan(errorMsgReport, '%s', 'Delimiter','\n')
                newVariable = genvarname(strVariable);
%                 errordlg(sprintf(['Cannot assign to variable ''%s''.\n',...
%                     'Maybe try ''%s'' instead?\n%s'],...
%                     strVariable,newVariable,exception.message),...
%                     'Assign has failed');
                set(hedVariable,'String',newVariable);  % update edit field
            end
        end
 end
function edVariable_KeyPressFcn(~, eventdata)
        if strcmp(eventdata.Key,'return')
            drawnow();   % required to make get(hedVariable,'String') work
            PushVariable();
        end
end
function pbWriteVariable_Callback(varargin)
        PushVariable();
end
    function tblData_CellSelectionCallback(~, eventdata)
        rng = eventdata.Indices;    % list of selected coordinates
        if numel(rng) < 4               % only one cell selected
            rng = [rng,rng];
        else
            rng = [min(rng),max(rng)];  % fill to one rectangular area
        end
    end
end

















end




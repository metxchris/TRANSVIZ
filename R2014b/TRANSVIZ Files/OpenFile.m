function [cdf, option] = OpenFile(src, evt, ui, cdf, option)
if option.testMode>0
    disp('OpenFile.m called');
end;
% Select CDF to load
if isnumeric(evt)
    filePath = src;
    splitPath = strsplit(filePath, '\');
    tempName = splitPath{end};
else
    [tempName, tempPath, ~] = uigetfile('.CDF', 'Select CDF to load');
    if ~tempName
        return
    end
    filePath = [tempPath, tempName]; 
end

if ~tempName
    SystemMsg('Error Reading CDF. No file name detected.', 'Error', ui);
    return
end

SystemMsg('Loading CDF ...', 'Msg', ui);
runID = strrep(tempName, '.CDF', '');


% check for duplicate cdfs
if max(strcmp(runID, option.cdfList))
    SystemMsg('Stopping File Load... CDF Already Loaded!', 'Msg', ui);
    return
end

% add cdf to end of list
for idx = 1:numel(option.cdfList)
    if isempty(option.cdfList{idx})
        option.cdfList{idx} = runID;
        set(ui.main.activeCdfH, 'string', option.cdfList);
        option.activeCdfIdx = idx;
        break
    end
end


% Load CDF related variables
cdf(idx).name = tempName;
cdf(idx).ncid = netcdf.open(filePath, 'NC_NOWRITE');
cdf(idx).varid = netcdf.getConstant('NC_GLOBAL');
cdf(idx).finfo = ncinfo(filePath);
dimid = netcdf.inqDimID(cdf(idx).ncid, 'TIME');
[~, cdf(idx).times] = netcdf.inqDim(cdf(idx).ncid, dimid);
dimid = netcdf.inqDimID(cdf(idx).ncid, 'X');
[~, cdf(idx).zones] = netcdf.inqDim(cdf(idx).ncid, dimid);

if ~cdf(idx).ncid
    SystemMsg('Read Error: Cannot read CDF ncid', 'Msg', ui);
    return
end

if strcmp(get(ui.main.splashH, 'visible'), 'on')
    % enable main functionalities after loading first CDF.
    set(ui.main.splashH, 'visible', 'off');
    set(ui.main.entryBoxH(:), 'enable', 'on');
    set(ui.main.axesH, 'visible', 'on');
    set(ui.menu.exportFigureMH, 'enable', 'on');
    set(ui.main.activeCdfH, 'enable', 'on');
    set(ui.main.sliderModeB(:), 'enable', 'on'); 
    set(ui.main.sliderModeB(1), 'BackgroundColor', [0.95 0.95 0.95]);
    set(ui.menu.windowMH, 'enable', 'on'); 
    set(ui.menu.toolsMH, 'enable', 'on'); 
    set(ui.menu.editMH, 'enable', 'on'); 
    set(ui.menu.exportDataMH, 'enable', 'on'); 
    set(ui.menu.exportFigureMH, 'enable', 'on'); 
    set(ui.main.entryLabelH(:), 'enable', 'on'); 
    set(ui.main.textHeaderH(:), 'enable', 'on'); 
end

% % Not working yet R2014b
% jMenu = findjobj(ui.main.activeCdfH)
% jMenu.maximumSize
% for k = 1:numel(jMenu)
%     jMenu(k)
%     try
%         jMenu(k).setMaximumRowCount(5);
%         break
%     end
% end
SystemMsg(['File ', tempName, ' successfully loaded'], 'Msg', ui);
% try
%     date = strsplit( ...
%         netcdf.getAtt(cdf(idx).ncid, cdf(idx).varid, 'CDF_date'), ' ');
%     cdf(idx).date =date{1};
%     set(ui.main.activeCdfH, 'value', idx);
%     SystemMsg(['File ', tempName, ' successfully loaded'], 'Msg', ui);
% catch err
%     % This error will likely occur if the cdf data structure is
%     % different from that used for DIII-D or NSTX files.
%     errMsg = ['Error: Failed to load file', tempName, ...
%         '. Please check that this is a valid .CDF file.'];
%     SystemMsg(errMsg, 'Error', ui);
%     getReport(err, 'extended')
% end

end

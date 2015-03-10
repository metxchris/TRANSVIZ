function VarListExport(option, ui, tableData, ColumnNames)
SystemMsg('', '', ui, option); % clear systemMsg

% user sets fileName, pathName
[fileName, pathName, ~] = uiputfile( ...
    {'*.tsv', 'Tab Separated Values (*.tsv)';...
    '*.txt','Text File (*.txt)'},...
    'Save as');
if ~fileName
    return
end

fileID = fopen([pathName, fileName],'w');
% file writing errors
if fileID < 0
    SystemMsg(['Export Failed:  Unable to open ', ...
        pathName, fileName, ...
        ' for writing.  Make sure this file is not open.'], ...
        'Warning', ui, option);
    return
end

% write to file
formatspec = '%4s\t%12s\t%50s\t%10s\t%16s\t%12s\n';
fprintf(fileID,formatspec,ColumnNames{:});
for j = 1:numel(tableData(:,1))
    fprintf(fileID,formatspec,tableData{j,:});
end
fclose(fileID);

% check if file has been created and report status
if exist([pathName,fileName],'file')
    SystemMsg(['Export Successful:  Data saved to ', ...
        pathName,fileName],'Msg', ui, option);
else
    SystemMsg(['Export Failed:  File ', pathName, fileName, ...
        ' has not been saved.'],'Warning', ui, option);
end

end
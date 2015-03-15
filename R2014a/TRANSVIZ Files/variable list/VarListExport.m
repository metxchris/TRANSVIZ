function VarListExport(tableType, tableData, columnNames, ui)
SystemMsg('', '', ui); % clear systemMsg

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
        'Warning', ui);
    return
end

% write to file
switch tableType
    case 'Variable List'
        formatspec = '%4s\t%12s\t%60s\t%16s\t%16s\t%12s\n';
    case 'Pointer List'
        formatspec = '%4s\t%12s\t%60s\t%16s\t%59s\n';
end
fprintf(fileID, formatspec, columnNames{:});
for j = 1:numel(tableData(:,1))
    fprintf(fileID,formatspec,tableData{j,:});
end
fclose(fileID);

% check if file has been created and report status
if exist([pathName,fileName],'file')
    SystemMsg(['Export Successful:  Data saved to ', ...
        pathName,fileName],'Msg', ui);
else
    SystemMsg(['Export Failed:  File ', pathName, fileName, ...
        ' has not been saved.'],'Warning', ui);
end

end
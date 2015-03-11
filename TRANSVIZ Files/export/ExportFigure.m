function ExportFigure(option, ui)
SystemMsg('', '', ui, option); % clear systemMsg

% user sets fileName, pathName
[fileName, pathName, ~] = uiputfile( ...
    {'*.eps', 'Encapsulated PostScript (*.eps)'},...
    'Save as');
if ~fileName
    return
end

try
    SetBackgroundColor(ui, 'white');
    switch option.plotMode
        case 'Line Plot'
            print(ui.main.figH, '-depsc', '-noui', '-painters', ...
                [pathName, fileName]);
        case 'Surface Plot'
            option.plotMode
            print(ui.main.figH, '-depsc', '-noui', '-opengl', ...
                [pathName, fileName]);
    end
catch
    SystemMsg('Export Error: Unknown error occured when exporting figure.', ...
        'Warning', ui, option);
end
SetBackgroundColor(ui, 'gray');

% check if file has been created and report status
if exist([pathName,fileName],'file')
    SystemMsg(['Export Successful:  Figure saved to ', ...
        pathName,fileName],'Msg', ui, option);
else
    SystemMsg(['Export Failed:  File ', pathName, fileName, ...
        ' has not been saved.'],'Warning', ui, option);
end



end

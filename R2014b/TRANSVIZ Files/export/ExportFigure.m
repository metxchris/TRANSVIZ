function ExportFigure(option, ui)
SystemMsg('', '', ui); % clear systemMsg

% user sets fileName, pathName
[fileName, pathName, ~] = uiputfile( ...
    {'*.eps', 'Encapsulated PostScript (*.eps)'},...
    'Save as');
if ~fileName
    % user canceled saving file
    return
end
printError = 0;
SetBackgroundColor(ui, 'white');
try
    switch option.plotMode
        case 'Line Plot'
            % painters rendering prints vectorized image.
            print(ui.main.figH, '-depsc', '-noui', '-painters', ...
                [pathName, fileName]);
        case 'Surface Plot'
            % using open gl for surface plots. painters very slow on
            % surface plots, and vectorized image not needed here.
            print(ui.main.figH, '-depsc', '-noui', '-opengl', ...
                [pathName, fileName]);
    end
catch err
    SystemMsg(...
        'Export Error: Unknown error occured when exporting figure.', ...
        'Warning', ui);
    fprintf(['\t', err.message, '\n']);
    printError = 1;
end
SetBackgroundColor(ui, 'gray');

if ~printError
    % check if file has been created and report status
    if exist([pathName,fileName],'file')
        SystemMsg(['Export Successful:  Figure saved to ', ...
            pathName,fileName],'Msg', ui);
    else
        SystemMsg(['Export Failed:  File ', pathName, fileName, ...
            ' has not been saved.'],'Warning', ui);
    end
end


end

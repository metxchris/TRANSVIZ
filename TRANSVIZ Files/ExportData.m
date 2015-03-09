function ExportData(variable, option, ui)
SystemMsg('', '', ui, option); % clear systemMsg

% user sets fileName, pathName
[fileName, pathName, ~] = uiputfile( ...
    {'*.csv', 'Comma Separated Values (*.csv)';...
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

switch option.plotMode
    case 'Line Plot'
        lineData = findobj(ui.main.axesH, 'Type', 'line');
        if isempty(lineData)
            SystemMsg('Error:  No data plotted. Export canceled.',...
                'Warning', ui, option);
            return
        end
        xData = get(lineData,'Xdata');
        yData = get(lineData,'Ydata');
        lineName = get(lineData,'displayname');
        
        if ~iscell(xData)
            % Convert double to cells for consistency.
            % (xData is a double when only one line is plotted, and a cell
            % when 2+ lines are plotted.)
            xData={xData};
            yData={yData};
            lineName={lineName};
        end
        
        % set headerLine
        Ylabel = [variable(option.leadVar).Y.label];
        Yunits = [variable(option.leadVar).Y.units,' '];
        switch option.slider.mode
            case 'Time'
                Xlabel = [variable(option.leadVar).X.label];
                Xunits = [variable(option.leadVar).X.units,' '];
            case 'Position'
                Xlabel = [variable(option.leadVar).T.label];
                Xunits = [variable(option.leadVar).T.units,' '];
        end
        sliderString = SetSliderString(variable, option);
        headerLine = [Ylabel, Yunits, 'vs. ', Xlabel, Xunits, ...
            'at ', sliderString];
        
        % write to file
        fprintf(fileID,'%s',headerLine);
        for j = numel(xData):-1:1
            % data is collected backwards from the plot, so we save it in
            % backwards order to here.
            lineName{j} = strrep(lineName{j}, ...
                '\color[rgb]{0.4 0.4 0.4}', '');
            dispName = strsplit(lineName{j},'  ');
            fprintf(fileID,'\n%20s,%3s,',dispName{2},'x');
            fprintf(fileID,'%12.3f,',xData{j}(2:end-1));
            fprintf(fileID,'\n%20s,%3s,',' ','y');
            fprintf(fileID,'%12.3e,',yData{j}(2:end-1));
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
    case 'Surface Plot'
        
end

end
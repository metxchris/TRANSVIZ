function ExportData(variable, option, ui)
SystemMsg('', '', ui); % clear systemMsg

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
        'Warning', ui);
    return
end

switch option.plotMode
    case 'Line Plot'
        lineData = findobj(ui.main.axesH, 'Type', 'line');
        if isempty(lineData)
            SystemMsg('Error:  No data plotted. Export canceled.',...
                'Warning', ui);
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
        yLabel = [variable(option.leadVar).Y.label];
        yUnits = [variable(option.leadVar).Y.units,' '];
        switch option.slider.mode
            case 'Time'
                xLabel = [variable(option.leadVar).X.label];
                xUnits = [variable(option.leadVar).X.units,' '];
            case 'Position'
                xLabel = [variable(option.leadVar).T.label];
                xUnits = [variable(option.leadVar).T.units,' '];
        end
        sliderString = SetSliderString(variable, option);
        headerLine = [yLabel, yUnits, 'vs. ', xLabel, xUnits, ...
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
    case 'Surface Plot'
        surfaceH=findobj(ui.main.axesH, 'type', 'surface');
        if isempty(surfaceH)
            SystemMsg('Error:  No data plotted. Export canceled.',...
                'Warning', ui);
            return
        end
        xData = num2cell(get(surfaceH, 'xd'));
        tData = num2cell(get(surfaceH, 'yd'));
        yData = num2cell(get(surfaceH, 'zd'));
        xName = variable(1).X.name; xUnits = variable(1).X.units;
        tName = variable(1).T.name; tUnits = variable(1).T.units;
        yName = variable(1).Y.name; yUnits = variable(1).Y.units;
        
        fprintf(fileID,'%6s, %6s, %8s','x-axis:', xName, xUnits);
        for j=1:numel(xData(:,1))
            fprintf(fileID,'\n%s','');
            fprintf(fileID,'%12.3f,',xData{j, :});
        end
        fprintf(fileID,'\n%6s, %6s, %8s','t-axis:', tName, tUnits);
        for j=1:numel(tData(:,1))
            fprintf(fileID,'\n%s','');
            fprintf(fileID,'%12.3f,',tData{j, :});
        end
        fprintf(fileID,'\n%6s, %6s, %8s','y-axis:', yName, yUnits);
        for j=1:numel(yData(:,1))
            fprintf(fileID,'\n%s','');
            fprintf(fileID,'%12.3e,',yData{j, :});
        end
        
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

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
        headerLine = ['# ', yLabel, yUnits, 'vs. ', xLabel, xUnits, ...
            'at ', sliderString];
        
        % write to file
        fprintf(fileID,'%s',headerLine);
        fprintf(fileID,'\n');

        xDataSizes = zeros(size(xData));
        % Plot returns the first plot last, so we loop backwards here
        for j = numel(xData):-1:1
            xDataSizes(j) = max(size(xData{j}));
            varNameX = strrep(lineName{j}, '\color[rgb]{0.5 0.5 0.5}', '.x');
            varNameY = strrep(lineName{j}, '\color[rgb]{0.5 0.5 0.5}', '.y');
            fprintf(fileID,'%23s,', varNameX);
            fprintf(fileID,'%23s,', varNameY);
        end

        fprintf(fileID,'\n');
        maxNumValues = max(xDataSizes);

        for k = 1:maxNumValues
            for j = numel(xData):-1:1
                 if k <= xDataSizes(j)
                    fprintf(fileID,'%23.3f,', xData{j}(k));
                    fprintf(fileID,'%23.3e,', yData{j}(k));
                 else
                    fprintf(fileID,'%23s,', ' ');
                    fprintf(fileID,'%23s,', '');
                 end
            end
            fprintf(fileID,'\n');
        end
    case 'Surface Plot'
        surfaceH=findobj(ui.main.axesH, 'type', 'surface');
        if isempty(surfaceH)
            SystemMsg('Error:  No data plotted. Export canceled.',...
                'Warning', ui);
            return
        end
        get(surfaceH)
        % the mixing of y, t, z below may look confusing.
        xData = num2cell(get(surfaceH, 'XData'));
        tData = num2cell(get(surfaceH, 'YData'));
        yData = num2cell(get(surfaceH, 'ZData'));
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

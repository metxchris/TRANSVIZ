function ui = VarListWindow(dataType, cdf, option, ui)
% Close old varlist window
switch dataType
    case 'single'
        if ~isempty(findobj('type','figure','name','Variable List'))
            fP = get(findobj('type','figure','name','Variable List'), 'position');
            position = [fP(1) fP(2) 669 420];
            close(findobj('type','figure','name','Variable List'));
        else
            position = [100,100,669,420]; %default window position
        end
    case 'int8'
        if ~isempty(findobj('type','figure','name','Pointer List'))
            fP = get(findobj('type','figure','name','Pointer List'), 'position');
            position = [fP(1) fP(2) 669 420];
            close(findobj('type','figure','name','Pointer List'));
        else
            position = [200,100,669,420]; %default window position
        end
end

% all data stored in CDF (other than variable values)
finfo = cdf(option.activeCdfIdx).finfo;

% build table entries for id, name, desc, and units
varTable = buildTableEntries(finfo, dataType);

switch dataType
    case 'single'
        buttonColor = [240 240 240]./255; %gray
        ColumnNames = {'VarID','Name','Description','Units','Dimensions','Size'};
        htmlString = '<html><div style="color:rgb(24,90,169);font-weight:bold">';
        
        % create varlist figure
        ui.varlist.figH = figure(2);
        set(ui.varlist.figH,...
            'name','Variable List',...
            'Position',position, ...
            'MenuBar','None');
        % create varlist menu
        ui.varlist.fileMH = uimenu(ui.varlist.figH,...
            'Label','&File');
        ui.varlist.openFMH = uimenu(ui.varlist.fileMH,...
            'Label','&Export Table...', ...
            'callback',@VarListExportCB);
        % create varlist table
        ui.varlist.tableH = uitable(ui.varlist.figH,...
            'Units','Pixels',...
            'Position', [10,10,649,400],...
            'ColumnWidth', {70 80 220 70 90 100},...
            'ColumnName', ColumnNames,...
            'RowName', [],...
            'tag','1',...
            'data',varTable);
        ui.varlist.varidBH = uicontrol(ui.varlist.figH,...
            'Style','pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'VarID</div>'],...
            'Position',[11,390,69,19],...
            'enable','on',...
            'tag','VarId',...
            'HorizontalAlignment','center');
        ui.varlist.nameBH = uicontrol(ui.varlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Name</div>'],...
            'Position',[80,390,79,19],...
            'enable','on',...
            'tag','Name',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.varlist.descriptionBH = uicontrol(ui.varlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Description</div>'],...
            'Position',[160,390,219,19],...
            'enable','on',...
            'tag','Description',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.varlist.unitsBH = uicontrol(ui.varlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Units</div>'],...
            'Position',[380,390,69,19],...
            'enable','on',...
            'tag','Units',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.varlist.dimensionsBH = uicontrol(ui.varlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Dimensions</div>'],...
            'Position',[450,390,89,19],...
            'enable','on',...
            'tag','Dimensions',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.varlist.sizeBH = uicontrol(ui.varlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Size</div>'],...
            'Position',[540,390,100,19],...
            'enable','on',...
            'tag','Size',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        
        try
            % apply java techniques to edit button properties
            buttonEdit(ui.varlist.varidBH);
            buttonEdit(ui.varlist.nameBH);
            buttonEdit(ui.varlist.descriptionBH);
            buttonEdit(ui.varlist.sizeBH);
            buttonEdit(ui.varlist.dimensionsBH);
            buttonEdit(ui.varlist.unitsBH);
        catch err %#ok<NASGU>
            %do nothing
        end
        
    case 'int8'
        buttonColor = [240 240 240]./255; %gray
        ColumnNames = {'VarID','Name','Description','Units','Fct IDs'};
        htmlString = '<html><div style="color:rgb(24,90,169);font-weight:bold">';
        
        % create varlist figure
        ui.pointerlist.figH = figure(3);
        set(ui.pointerlist.figH,...
            'name','Pointer List',...
            'Position',position, ...
            'MenuBar','None');
        % create varlist menu
        ui.pointerlist.fileMH = uimenu(ui.pointerlist.figH,...
            'Label','&File');
        ui.pointerlist.openFMH = uimenu(ui.pointerlist.fileMH,...
            'Label','&Export Table...', ...
            'callback',@PointerListExportCB);
        % create varlist table
        ui.pointerlist.tableH = uitable(ui.pointerlist.figH,...
            'Units','Pixels',...
            'Position', [10,10,649,400],...
            'ColumnWidth', {70 80 220 70 190},...
            'ColumnName', ColumnNames,...
            'RowName', [],...
            'tag','1',...
            'data',varTable);
        ui.pointerlist.varidBH = uicontrol(ui.pointerlist.figH,...
            'Style','pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'VarID</div>'],...
            'Position',[11,390,69,19],...
            'enable','on',...
            'tag','VarId',...
            'HorizontalAlignment','center');
        ui.pointerlist.nameBH = uicontrol(ui.pointerlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Name</div>'],...
            'Position',[80,390,79,19],...
            'enable','on',...
            'tag','Name',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.pointerlist.descriptionBH = uicontrol(ui.pointerlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Description</div>'],...
            'Position',[160,390,219,19],...
            'enable','on',...
            'tag','Description',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.pointerlist.unitsBH = uicontrol(ui.pointerlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Units</div>'],...
            'Position',[380,390,69,19],...
            'enable','on',...
            'tag','Units',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        ui.pointerlist.fctidsBH = uicontrol(ui.pointerlist.figH,...
            'Style', 'pushbutton',...
            'Units','Pixels',...
            'string',[htmlString,'Fct IDs</div>'],...
            'Position',[450,390,190,19],...
            'enable','on',...
            'tag','Fct IDs',...
            'backgroundColor',buttonColor,...
            'HorizontalAlignment','center');
        
        try
            % apply java techniques to edit button properties
            buttonEdit(ui.pointerlist.varidBH);
            buttonEdit(ui.pointerlist.nameBH);
            buttonEdit(ui.pointerlist.descriptionBH);
            buttonEdit(ui.pointerlist.fctidsBH);
            buttonEdit(ui.pointerlist.unitsBH);
        catch err %#ok<NASGU>
            %do nothing
        end
end



    function buttonEdit(handle)
        jButton = java(findjobj(handle));
        jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jButton.setFlyOverAppearance(true);
    end

    function varTable = buildTableEntries(finfo, dataType)
        % This function represents a partially vectorized alternative to
        % reading off table values using a loop. The vectorized approach is
        % many times faster than the loop approach.
        
        % extract data type of each variable in CDF (either single or int8).
        % single variables have data that can be plotted.
        % int8 are pointer variables and do not contain data.
        varDataTypes = {finfo.Variables(:).Datatype};
        
        % logical array of all variables of type specified by dataType
        typeArray = strncmp(varDataTypes, dataType, 6);
        
        % initial and final idx of matched variable type
        minIdx = find(typeArray,1);
        maxIdx = find(typeArray,1, 'last');
        
        % create idx ranges for reading CDF data
        idxRange = minIdx:maxIdx;
        
        % preallocate cell for storing table data of single variables
        % set index scaling
        switch dataType
            case 'single'
                varTable = cell(numel(idxRange), 6);
                idxScale = idxRange*2;
            case 'int8'
                varTable = cell(numel(idxRange), 5);
                idxScale = idxRange*3;
        end
        idxShift = idxScale - idxScale(1) + 1;
        
        % store variable IDs for table presentation
        varTable(:,1) = strtrim(cellstr(num2str(idxRange')));
        
        % store variable names for table presentation
        varTable(:,2) = {finfo.Variables(idxRange).Name}';
        
        % store variable descriptions and units for table presentation
        fAttributes = [finfo.Variables(idxRange).Attributes];
        varTable(:,3) = deblank({fAttributes(idxShift+1).Value}');
        varTable(:,4) = deblank({fAttributes(idxShift).Value}');
        
        % % % % Ideas to finish vectorizing:
        % % % fSize={finfo.Variables(1,1:cdfVarCount).Size}';
        % % % varSize= cell(cdfVarCount,1);
        % % % zones = fSize{1};
        % % %     if numel(fSize{j})==1
        % % %         varSize{j}=1;
        % % %     else
        % % %         varSize{j}=fSize{j}(1);
        % % %     end
        
        % Loops to read off variable size and dimension values.
        % Haven't been able to vectorize these loops yet.
        switch dataType
            case 'single'
                for j = idxRange
                    tableIdx = j - idxRange(1) + 1;
                    % store variable dimensions information
                    jDim = numel(finfo.Variables(1,j).Dimensions);
                    if jDim == 1
                        varTable(tableIdx, 5) = {finfo.Variables(1,j).Dimensions(1,1).Name};
                    elseif  jDim == 2
                        varTable(tableIdx, 5) = {[finfo.Variables(1,j).Dimensions(1,1).Name, ...
                            ', ',finfo.Variables(1,j).Dimensions(1,2).Name]};
                    end
                    % Store variable size information
                    jSize = finfo.Variables(1,j).Size;
                    if numel(jSize) == 1
                        varTable(tableIdx, 6) = {num2str(jSize)};
                    elseif  numel(jSize) == 2
                        varTable(tableIdx, 6) = {[num2str(jSize(1,1)),' x ',num2str(jSize(1,2))]};
                    end
                end
            case 'int8'
                fctIDs = {fAttributes(idxShift+2).Value}';
                for j = 1:numel(fctIDs)
                    % add 2 to each set of fctIDs to match the indexing
                    % configuration used by TRANSVIZ
                    varTable(j, 5) = cellstr(num2str(fctIDs{j}+2));
                end
        end
        
    end

    function VarListExportCB(varargin)
        tableData = get(ui.varlist.tableH, 'data');
        VarListExport('varList', option, ui, tableData, ColumnNames);
    end

    function PointerListExportCB(varargin)
        tableData = get(ui.pointerlist.tableH, 'data');
        VarListExport('pointerList', option, ui, tableData, ColumnNames);
    end

end

function [variable, option] = VarEntry(handle, cdf, variable, option, ui)
%% Internal Functions:
% variable = ResetVarFields(idx, variable, ui)
% option = SetSliderValues(option, variable, ui)

%% Load CDF variable dated based on text box entry
% Note: The depreciated function 'loadVarF(entryName)' uses generic
% netcdf methods, which may be a useful alternative for data extraction.
% NetCDF matrix data displays dimensionally as POS x TIME

% get entered variable name and entryBox number.
entryName = char(strrep(upper(get(handle, 'String')), ' ', ''));
idx = str2double(get(handle, 'tag'));

% clear systemMsg
SystemMsg('', '', ui);

% resets the corresponding variable data for blank entries
if isempty(entryName)
    [variable, option] = ClearVariable('all', idx, variable, option, ui);
    return
end

variable(idx).cdfName = option.cdfList{option.activeCdfIdx};
finfo = cdf(option.activeCdfIdx).finfo;

if all(ismember(entryName, '0123456789'))
    % check if entry is a variable ID
    varID = str2double(entryName)-1;
    try
        entryName = netcdf.inqVar(cdf(option.activeCdfIdx).ncid, varID);
    catch
        % variable not found
        errMsg = ['Error: Variable corresponding to ID number ', ...
            num2str(varID+1), ' not found in ', ...
            option.cdfList{option.activeCdfIdx}, '.CDF'];
        SystemMsg(errMsg, 'Warning', ui);
        return
    end
end

% Creates a column cell array of the uppercase cdf variable names
% varMatch = 1 if variable found, 0 if not.
varList = {finfo.Variables.Name}';
varStrcmp = strcmp(entryName, varList);
varMatch = sum(varStrcmp);
if ~varMatch
    errMsg = ['Error: Variable ''', entryName, ''' not found in ', ...
        cdf(option.activeCdfIdx).name];
    SystemMsg(errMsg, 'Error', ui);
    return
end

% set entryBox string to uppercase
set(ui.main.entryBoxH(idx), 'string', entryName);

%% Load variable data
% Note: variable plotting data is not stored in varStruct.
varStruct = finfo.Variables(varStrcmp);

switch varStruct.Datatype
    % Variables of datatype 'single' have matrix values that may be plotted
    % Variables of datatype 'int8' are scalar pointers
    % finfo  indexing starts at 1
    % netcdf indexing starts at 0.
    case 'single'
        % load variable data
        varID = find(varStrcmp)-1;
        variable(idx).Y.name = varStruct.Name;
        variable(idx).Y.units = ...
            StringCleaner(varStruct.Attributes(1).Value, 'Units');
        variable(idx).Y.label = ...
            StringCleaner(varStruct.Attributes(2).Value, 'Label');
        variable(idx).Y.data = ...
            netcdf.getVar(cdf(option.activeCdfIdx).ncid, varID);
        variable(idx).Y.size = size(variable(idx).Y.data);
        variable(idx).Y.max = max(max(variable(idx).Y.data));
        variable(idx).Y.min = min(min(variable(idx).Y.data));
        
        % Check to see how many dimensions variable has
        % 2 ~ Time, Position
        % 1 ~ Time
        numDimensions = numel(varStruct.Size);
        switch numDimensions
            case 1
                % 1D variables are treated as row arrays for consistency.
                variable(idx).Y.data = variable(idx).Y.data';
                variable(idx).Y.size = size(variable(idx).Y.data);
                dimNameT = varStruct.Dimensions.Name; 
                dimNameX = 'TIME';
            case 2
                [dimNameX, dimNameT] = varStruct.Dimensions.Name;
        end
        
        InterpolatedDimList = keys(option.slider.map);
        % skip first entry because it's blank
        if ~strcmp({InterpolatedDimList{2:end}}, dimNameX) %#ok<CCAT1>
            if isempty(dimNameX)
                dimNameX = '(none)';
            end
            errMsg = ['Error: Variable ', variable(idx).Y.name, ...
                ' with x-axis dimension ', dimNameX, ...
                ' does not have a defined interpolation grid.'];
            SystemMsg(errMsg, 'Error', ui);
            [variable, option] = ...
                ClearVariable('', idx, variable, option, ui);
            % recalc slider values
            option = SetSliderValues(option, variable, ui);
            varY=[variable.Y];
            option.leadVar = find(~cellfun('isempty', {varY.name}), 1);
            if isempty(option.leadVar)
                set(ui.main.sliderH, 'enable', 'off');
            end
            return
        end
        
        % load time dimension
        dimID = netcdf.inqVarID(cdf(option.activeCdfIdx).ncid, dimNameT);
        dimStruct = finfo.Variables(dimID+1);
        variable(idx).T.name = dimStruct.Name;
        variable(idx).T.size = dimStruct.Size;
        variable(idx).T.units = ...
            StringCleaner(dimStruct.Attributes(1).Value, 'Units');
        variable(idx).T.label = ...
            StringCleaner(dimStruct.Attributes(2).Value, 'Label');
        variable(idx).T.data = ...
            netcdf.getVar(cdf(option.activeCdfIdx).ncid, dimID)';
        variable(idx).T.max = max(max(variable(idx).T.data));
        variable(idx).T.min = min(min(variable(idx).T.data));
        
        % load position dimension
        if numDimensions == 2
            dimID = netcdf.inqVarID(cdf(option.activeCdfIdx).ncid, dimNameX);
            dimStruct = finfo.Variables(dimID+1);
            variable(idx).X.name  = dimStruct.Name;
            variable(idx).X.size  = dimStruct.Size;
            variable(idx).X.units = ...
                StringCleaner(dimStruct.Attributes(1).Value, 'Units');
            variable(idx).X.label = ...
                StringCleaner(dimStruct.Attributes(2).Value, 'Label');
            variable(idx).X.data = ...
                netcdf.getVar(cdf(option.activeCdfIdx).ncid, dimID);
        elseif numDimensions == 1
            variable(idx).X.name = '';
        end
        
        % Interpolation Step
        variable(idx) = interpolateData(dimNameX, variable(idx), option);
        
        if numDimensions == 2
            variable(idx).numZones = numel(variable(idx).Y.data(:, 1));
        elseif numDimensions == 1
            variable(idx).numZones = 1;
        end
        
        variable(idx).numTimes = numel(variable(idx).Y.data(1, :));
        
        % stores the top-most active entry box, for purposes of
        % determining plotted and exported labels
        varY=[variable.Y];
        option.leadVar = find(~cellfun(@isempty, {varY.name}), 1);
        
        % set slider properties
        option = SetSliderValues(option, variable, ui);
        set(ui.main.sliderH, 'enable', 'on');
        
        switch option.plotMode
            case 'Line Plot'
                % enable '+' button
                set(ui.main.entryHelpH(idx), 'visible', 'on');
        end
        
        % set tooltip properties
        tooltipstring = [ ...
            '<html>', ...
            '<table cellpadding="1">', ...
            '<tr><td>CDF:&nbsp;</td><td> ', ...
            variable(idx).cdfName, '</td></tr>', ...
            '</table>', ...
            '<table cellpadding="1">', ...
            '<tr><td colspan="2"><hr></td></tr>', ...
            '<tr><td>Variable:&nbsp;</td><td> ', ...
            entryName, '<br>', ...
            '<tr><td>Name:&nbsp;</td><td> ', ...
            variable(idx).Y.label, '</td></tr>', ...
            '<tr><td>Units:&nbsp;</td><td> ', ...
            variable(idx).Y.units, '</td></tr>', ...
            '<tr><td colspan="2"><hr></td></tr>', ...
            '<tr><td>Times:&nbsp;</td><td>', ...
            num2str(variable(idx).numTimes), '</td></tr>', ...
            '<tr><td>Positions:&nbsp;</td><td>', ...
            num2str(variable(idx).numZones), '</td></tr>', ...
            '</table></html>'];
        set(ui.main.entryBoxH(idx), 'visible', 'on', ...
            'tooltipstring', tooltipstring);
        
    case 'int8'
        % int8 are pointer variables.  Pointed to varID's are stored in
        % the attributes of int8 variables.
        varid = netcdf.inqVarID(cdf(option.activeCdfIdx).ncid, entryName);
        % shift fctID up by 2 to match our indexing scheme, which is
        % that the first variable, TIME, has index of 1.
        fctID = finfo.Variables(varid+1).Attributes(3).Value+2;
        msg = [finfo.Variables(varid+1).Name, ' Fct_Ids:  ', ...
            num2str(fctID), '.'];
        SystemMsg(msg, 'Msg', ui);
        [variable, option] = ClearVariable('', idx, variable, option, ui);
        
        
    otherwise
        errMsg = ['Error: Variable ''', entryName, ...
            ''' is not a valid datatype (single or int8)'];
        SystemMsg(errMsg, 'Error', ui);
        return
end %switch varDatatype

%% Internal Functions

    function [variable, option] = ClearVariable(clearType, idx, variable, option, ui)
        variable(idx) = ResetVarFields(idx, variable(idx), ui);
        varY0 = [variable.Y];
        option.leadVar = find(~cellfun(@isempty, {varY0.name}), 1);
        if isempty(option.leadVar)
            set(ui.main.sliderH, 'enable', 'off');
        else
            option = SetSliderValues(option, variable, ui);% recalc slider values
        end
        switch clearType
            case 'all'
                set(ui.main.entryBoxH(idx), 'string', '');
        end
        set(ui.main.entryBoxH(idx), 'tooltipstring', '');
    end

    function variable = ResetVarFields(idx, variable, ui)
        varFields = struct ( ...
            'name', {''}, ...
            'data', {[]}, ...
            'units', {''}, ...
            'label', {''}, ...
            'size', {[NaN, NaN]}, ...
            'max', [], ...
            'min', [] ...
            );
        variable.Y = varFields;
        variable.X = varFields;
        variable.T = varFields;
        variable.cdfName   = {''};
        variable.linePlotH = [];
        variable.numTimes = [];
        variable.numZones = [];
        set(ui.main.entryHelpH(idx), 'visible', 'off');
    end % ResetVarFields

    function option = SetSliderValues(option, variable, ui)
        % Calculate 'Time' slider values
        varT=[variable.T];
        numericStep = option.slider.map(variable(option.leadVar).T.name);
        if ~isempty(find([varT.name], 1))
            option.slider.T.max = max([varT.max]-numericStep);
            option.slider.T.min = min([varT.min]+numericStep);
            stepSize = ...
                numericStep/(option.slider.T.max-option.slider.T.min);
        else
            option.slider.T.max = 1;
            option.slider.T.min = 0;
            stepSize = 1/100;
        end
        option.slider.T.step = [stepSize 10*stepSize];% ratio from 0 to 1
        
        numericStep = option.slider.map(variable(option.leadVar).X.name);

        varX = variable.X;
        if ~isempty(find([varX.name], 1))
            option.slider.X.max = max([varX.max]-numericStep);
            option.slider.X.min = min([varX.min]+numericStep);
            stepSize = ...
                numericStep/(option.slider.X.max - option.slider.X.min);
            if stepSize <= 0
                % this happens when arrays have two elements
                option.slider.X.max = max([varX.max]);
                option.slider.X.min = min([varX.min]);
                stepSize = ...
                    numericStep/(option.slider.X.max-option.slider.X.min);
            end
        else
            option.slider.X.max = 1;
            option.slider.X.min = 0;
            stepSize = 1/100;
        end
        option.slider.X.step = [stepSize 10*stepSize];% ratio from 0 to 1
        
        switch option.slider.mode
            case 'Time'
                newSlider = option.slider.T;
            case 'Position'
                newSlider = option.slider.X;
        end
        
        option.slider.max   = double(newSlider.max);
        option.slider.min   = double(newSlider.min);
        option.slider.step  = double(newSlider.step);
        % adjust slider value if out of bounds
        option.slider.value = BoundSliderValue(option);
        % save slider properties
        set(ui.main.sliderH                  , ...
            'Max', option.slider.max         , ...
            'Min', option.slider.min         , ...
            'SliderStep', option.slider.step  , ...
            'value', option.slider.value);
    end % SetSliderValues

    function variable = interpolateData(dimNameX, variable, option)
        % I'm leaving this as an inefficient way of doing things so that it
        % can easily be turned on/off if needed, and because this step
        % takes a negligable about of time to execute.
        % (chop off end points in Tmin and Tmax)
        Tmin  = round(min(min(variable.T.data))*100+1)/100;
        Tmax  = round(max(max(variable.T.data))*100-1)/100;
        Tgrid = double(Tmin:0.01:Tmax);
        
        T = variable.T.data;
        X = variable.X.data;
        Y = variable.Y.data;
        
        step = option.slider.map(dimNameX);
        switch dimNameX
            case {'X', 'XB'}
                interpMode = 'single';
                Xgrid = 0.01:step:1;
            case 'MCINDX'
                interpMode = 'single';
                Xgrid = 0.01:step:1;
            case {'THETA'}
                interpMode = 'single';
                Xgrid = -3.14:step:3.14;
            case {'RMAJM', 'RMJSYM'}
                interpMode = 'double';
                Xmin  = round(min(min(variable.X.data))*10000)/10000;
                Xmax  = round(max(max(variable.X.data))*10000)/10000;
                Xgrid = Xmin:step:Xmax;
            case {'TIME', 'TIME3'}
                interpMode = 'time';
                Xgrid = 0.01:step:1;
            case {'ILDEN', 'ILIM', 'INTNC', 'IVISB'}
                interpMode = 'single';
                Xmin  = round(min(min(variable.X.data)));
                Xmax  = round(max(max(variable.X.data)));
                Xgrid = double(Xmin:step:Xmax);
        end
        
        switch interpMode
            case 'time'
                % one-dimensional variables
                Yq = interp1(T, Y', Tgrid);
                Yq = repmat(Yq, numel(Xgrid), 1);
                Xq = repmat(Xgrid', 1, numel(Tgrid));
            case 'single'
                % Easy interpolation - When Position Vectors are Const.
                sizeX = numel(X(:, 1));
                Xq = repmat(Xgrid', 1, numel(Tgrid));
                sizeXq = numel(Xq(:, 1));
                Tq = repmat(Tgrid, sizeXq, 1);
                Tq0 = repmat(T, sizeX, 1);
                Yq = interp2(X', Tq0', Y', Xq', Tq', 'linear', NaN)';
            case 'double'
                % double interpolation - when position vector vary
                sizeX = numel(X(:, 1));
                Tq0 = repmat(T(1, :), sizeX, 1);
                Xq0 = single(repmat(Xgrid', 1, numel(Tq0(1, :))));
                for j=1:numel(T(1, :))
                    Yq0(:, j) = interp1( ...
                        X(:, j), Y(:, j)', Xq0(:, j)); %#ok<AGROW>
                end
                Xq = interp1(Tq0(1, :), Xq0', Tgrid, 'linear', 'extrap')';
                T1 = single(repmat(T, numel(Xq0(:, 1)), 1));
                Tq = single(repmat(Tgrid, numel(Xq(:, 1)), 1));
                Yq = interp2(Xq0', T1', Yq0', Xq', Tq', 'linear', NaN)';
        end
        
        variable.T.data = Tgrid;
        variable.T.size = numel(Tgrid);
        variable.T.max  = Tmax;
        variable.T.min  = Tmin;
        variable.X.data = Xq;
        variable.X.size = size(Xq);
        variable.X.max  = max(max(variable.X.data));
        variable.X.min  = min(min(variable.X.data));
        variable.Y.size = size(Yq);
        variable.Y.data = ...
            [nan(numel(Yq(:, 1)), 1), Yq(:, 2:end-1), ...
            nan(numel(Yq(:, 1)), 1)];
    end

end
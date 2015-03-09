function sIdx = MapSlider(option,variable)
varY=[variable.Y];
nonEmptyIdx = ~cellfun(@isempty,{varY.name});
% need to round sIdx to make it an integer.
switch option.slider.mode
    case 'Time'
        numericStep = 0.01; % seconds
        convFactor = 1/numericStep;
        varT=[variable.T];
        varIdx = max(option.slider.value, [varT.min]);
        varIdx = min(varIdx, [varT.max]);
        varIdx = round((varIdx - [varT.min])*convFactor + 1);
        sIdx =(NaN(1,numel(variable)));
        sIdx(nonEmptyIdx) = varIdx;
    case 'Position'
        % these numericSteps must match those given in the
        % interpolateData() function within VarEntry.m
        switch variable(option.leadVar).X.name
            case {'X','XB'}
                numericStep = 0.01; % dimensionless
            case 'MCINDX'
                numericStep = 1/220; % dimensionless
            case {'RMAJM','RMJSYM'}
                numericStep = 1; % meters
            case 'THETA'
                numericStep = 0.0628; % rads
            case {'ILDEN', 'ILIM', 'INTNC', 'IVISB'}
                numericStep = 1;
            case ''
                % one-dimensional variables
                numericStep = 0.01; % dimensionless
        end
        convFactor = 1/numericStep;
        varX=[variable.X];
        option.slider.value;
        varIdx = max(option.slider.value, [varX.min]);
        varIdx = min(varIdx, [varX.max]);
        varIdx = round((varIdx - [varX.min])*convFactor+1);
        sIdx =(NaN(1,numel(variable)));
        sIdx(nonEmptyIdx) = varIdx;
end

end


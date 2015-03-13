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
        numericStep = NumericStepDictionary( ...
            variable(option.leadVar).X.name);
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


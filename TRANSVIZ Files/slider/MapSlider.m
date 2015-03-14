function sIdx = MapSlider(option, variable)

% store variable.Y to perform vectorized operations
variableY=[variable.Y];
% note: using 'isempty' is twice as fast as @isempty
nonEmptyIdx = ~cellfun('isempty', {variableY.name});
% get conversion factor to map from slider value to array idx value
switch option.slider.mode
    case 'Time'
        conversion = 1/option.slider.map(variable(option.leadVar).T.name);
    
        variableR = [variable.T];
    case 'Position'
        conversion = 1/option.slider.map(variable(option.leadVar).X.name);
        variableR = [variable.X];
end
% Bound idx value for each variable, then convert to integer
varIdx = max(option.slider.value, [variableR.min]);
varIdx = min(varIdx, [variableR.max]);
varIdx = round((varIdx - [variableR.min])*conversion + 1);
% preallocate sIdx array, then save varIdx data
sIdx =(NaN(1, numel(variable)));
sIdx(nonEmptyIdx) = varIdx;

end % MapSlider

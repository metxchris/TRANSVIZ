function sIdx = MapSlider(option, variable)

% store variable.Y to perform vectorized operations
variableY=[variable.Y];
% note: using 'isempty' is twice as fast as @isempty
nonEmptyIdx = ~cellfun('isempty', {variableY.name});
% get conversion factor to map from slider value to array idx value
switch option.slider.mode
    case 'Time'
        step = option.slider.map(variable(option.leadVar).T.name);
        variableR = [variable.T];
        idxMax = [variable.numTimes];
    case 'Position'
        step = option.slider.map(variable(option.leadVar).X.name);
        variableR = [variable.X];
        idxMax = [variable.numZones];
end
% Bound idx value for each variable (idxVal is an array)
idxVal = max(round((option.slider.value-[variableR.min])/step + 1), 1);
idxVal = min(idxVal, idxMax);
% preallocate sIdx array, then save varIdx data
sIdx =(NaN(1, numel(variable)));
sIdx(nonEmptyIdx) = idxVal;

end % MapSlider

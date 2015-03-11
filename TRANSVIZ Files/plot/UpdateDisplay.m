function [variable, ui] = UpdateDisplay(variable, option, ui)
% Note: This middleman function made more sense when TRANSVIZ had 
% a table mode available.
if option.testMode
    disp('UpdateDisplay.m called');
end

% no data updating if errors exist
if option.errorLevel == 1
    return;
end

if isempty(option.leadVar)
    % clear the interface if no variables loaded.
    cla reset;
    return
end

switch option.plotMode
    case 'Line Plot'
        [variable, ui] = LinePlot(variable, option, ui);
    case 'Surface Plot'
        [variable, ui] = SurfacePlot(variable, option, ui);
end

end %UpdateDisplay
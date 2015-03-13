function [variable, ui] = UpdateDisplay(variable, option, ui)
% Note: This middleman function made more sense when TRANSVIZ had 
% a table mode available.
if option.testMode
    disp('UpdateDisplay.m called');
end

if isempty(option.leadVar)
    % clear the interface if no variables loaded and skip plotting.
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
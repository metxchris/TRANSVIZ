function [ui,option] = ActiveCDF(ui, cdf, option)
if option.testMode>0
    disp('ActiveCDF.m called');
end;
idx = get(gcbo,'value');
if ~isempty(cdf(idx).ncid)
    % switch active cdf
    option.activeCdfIdx = idx;
elseif isempty(option.activeCdfIdx)
    % no cdf loaded: set idx to 1
    idx = 1;
else
    % no new selection: revert to previous active cdf
    idx =  option.activeCdfIdx;
end
set(ui.main.activeCdfH, 'value', idx);

end
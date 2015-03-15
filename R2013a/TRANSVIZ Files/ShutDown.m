function ShutDown(varargin)

% Close all related windows
figureList = {'Console', 'Variable List', ...
    'Pointer List', 'TRANSVIZ'};
for j = 1:numel(figureList)
    if ~isempty(findobj('type', 'figure', 'name', figureList{j}))
        delete(findobj('type', 'figure', 'name', figureList{j}));
    end
end

end

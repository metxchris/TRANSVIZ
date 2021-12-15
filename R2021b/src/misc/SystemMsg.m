function SystemMsg(inputMsg, inputType, ui)
% Displays a message on the main gui above the axes
if isempty(inputMsg)
    set(ui.main.systemMsgH, 'visible', 'off');
    return
end

backgroundColor = [255, 255, 224]./255; %light yellow

switch inputType
    case 'Error'
        foregroundColor = ColorDictionary('Red');
        
    case 'Warning'
        foregroundColor = ColorDictionary('Red');
        
    case 'Msg'
        foregroundColor = ColorDictionary('Dark Green');  
end

set(ui.main.systemMsgH, ...
    'string', inputMsg,...
    'foregroundColor', foregroundColor, ...
    'backgroundColor', backgroundColor, ...
    'visible', 'on' ...
    );

end %systemMsgF
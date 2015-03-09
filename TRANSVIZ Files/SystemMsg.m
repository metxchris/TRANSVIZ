function errorLevel = SystemMsg(inputMsg, inputType, ui, option)
% Displays a message on the main gui above the axes
if isempty(inputMsg) && ~option.errorLevel
    set(ui.main.systemMsgH, 'visible', 'off');
    return
end

% I might not be using errorLevel anymore - (chris 03/08/15)
errorLevel      = option.errorLevel;
backgroundColor = [255, 255, 224]./255; %light yellow

switch inputType
    case 'Error'
        errorLevel = 1;
        foregroundColor = [0.933 0.180 0.184]; %red
        
    case 'Warning'
        foregroundColor = [0.933 0.180 0.184]; %red
        
    case 'Msg'
        foregroundColor = [0 0.4 0]; %dark green   
end

set(ui.main.systemMsgH, ...
    'string', inputMsg,...
    'foregroundColor', foregroundColor, ...
    'backgroundColor', backgroundColor, ...
    'visible', 'on' ...
    );

% Add border (non-standard MATLAB technique using findjobj)
jEdit = findjobj(ui.main.systemMsgH);
lineColor = java.awt.Color(255/255,215/255,0/255);
thickness = 1;
jEdit.Border = javax.swing.border.LineBorder(lineColor,thickness);
jEdit.repaint;

end %systemMsgF
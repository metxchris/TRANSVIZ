function HandHoverCursor(handle)
% sets cursor to hand graphic when hoving over button specified by handle.

try
    jButton = java(findjobj(handle));
    jButton.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
    jButton.setFlyOverAppearance(true);
catch err
    source = get(handle);
    try
    disp(['HandHoverCursor.m: Error for ', source.Type, ...
        ' with String ''', source.String, ''':']);
    fprintf(['\t',err.message,'\n']);
    catch
        fprintf(['\t',err.message,'\n']);
    end
end

end

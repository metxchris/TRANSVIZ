function SetCheckMark(handle)

% uncheck all related menu items
source = get(handle);
parentHandle = get(source.Parent);
set(parentHandle(:).Children, 'checked', 'off')
% check called menu item
set(handle, 'Checked', 'on');

end
function SetBackgroundColor(ui,color)

if strcmp(color,'white')
    backgroundColor = [1 1 1];
elseif strcmp(color,'gray')
    backgroundColor = [0.9 0.9 0.9];
end

set(gcf, 'color', backgroundColor);

uicontrolList = {   ...   
    ui.main.globalValuesH, ...
    ui.main.textHeaderH(:), ...
    ui.main.entryLabelH(:), ...
    ui.main.entryHelpH(:), ...
    ui.main.plotTimeH, ...
    ui.main.sliderModeB(:), ...
    ui.main.sliderModeH ...
    };

for j=1:numel(uicontrolList)
    if ishandle(uicontrolList{j})
        set([uicontrolList{j}], 'BackgroundColor',  backgroundColor);
    end
end

end
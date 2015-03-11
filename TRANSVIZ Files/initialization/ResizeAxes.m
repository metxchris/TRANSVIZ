    function ResizeAxes(ui,option)
        % Only resizes the axes;
        
        fP = get(ui.main.figH, 'Position');
        if strcmp(option.plotMode,'Surface Plot')
            set(ui.main.axesH  , 'Position', [90, 84, fP(3)-255, fP(4)-145]);
        else
            set(ui.main.axesH  , 'Position', [70, 84, fP(3)-215, fP(4)-125]);
        end
        
    end
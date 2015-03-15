function dataString = SetSliderString(variable, option)
    % update displayed time or position value.
    switch option.slider.mode
        case 'Time'
            dataString = ['Time = ', ...
                num2str(option.slider.value,'%.3G '),' s'];
        case 'Position'
            units = strrep(strrep(...
                variable(option.leadVar).X.units,']',''),'[','');
            dataString = ['Position = ', ...
                num2str(option.slider.value,'%.3G '),units];
    end
end
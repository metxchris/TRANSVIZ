function color = ColorDictionary(key)
% commented out = alternate color scheme
switch key
    case 'Blue'
        color = [3 112 184]./255; %[0.094 0.353 0.663];
    case 'Green'
        color = [117 173 53]./255; %[0 0.549 0.282];
    case 'Dark Green'
        color = [0 0.4 0];
    case 'Red'
        color = [163 18 42]./255; %[0.933 0.180 0.184];
    case 'Purple'
        color = [121 45 141]./255; %[0.4 0.173 0.569];
    case 'Orange'
        color = [216 84 27]./255; %[0.957 0.490 0.137];
    case 'Yellow'
        color = [238 181 36]./255; %[251/255 184/255 39/255];
    case 'Cyan'
        color = [74 189 238]./255; %1-[0.933 0.180 0.184];
    case 'Brown'
        color = [151 84 39]./255;
    case 'Light Gray'
        color = [0.6 0.6 0.6];
    case 'Dark Gray'
        color = [0.35 0.35 0.35];
    case 'Black'
        color = [0 0 0];
    case 'None'
        color = 'None';
end

end
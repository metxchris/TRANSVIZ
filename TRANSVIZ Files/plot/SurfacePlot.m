function [variable, ui] = SurfacePlot(variable, option, ui)
if option.testMode
    disp('SurfacePlot.m called');
end;

varY = double(variable(1).Y.data);
sizeY1=variable(1).Y.size(1);
sizeY2=variable(1).Y.size(2);

switch option.surfaceStyle
    case 'Surface Grid'
        stepy = round(variable(1).Y.size(2)/50);
        stepx = round(variable(1).Y.size(1)/40);
        [y, x] = meshgrid((1:stepy:sizeY2)/sizeY2, (1:stepx:sizeY1)/sizeY1);
        variable(1).surfPlotH = surf(ui.main.axesH, ...
            x, y, varY(1:stepx:end, 1:stepy:end));
    case 'Mesh Grid'
        stepy = round(variable(1).Y.size(2)/50);
        stepx = round(variable(1).Y.size(1)/40);
        [y, x] = meshgrid((1:stepy:sizeY2)/sizeY2, (1:stepx:sizeY1)/sizeY1);
        variable(1).surfPlotH = mesh(ui.main.axesH, ...
            x, y,varY(1:stepx:end, 1:stepy:end), ...
            'linewidth',1);
    case 'Surface Texture'
        [y, x] = meshgrid((1:sizeY2)/sizeY2, (1:sizeY1)/sizeY1);
        variable(1).surfPlotH = surf(ui.main.axesH, ...
            x, y, varY(:, :), ...
            'edgecolor', 'none', ...
            'edgelighting', 'phong', ...
            'faceLighting', 'phong', ...
            'AmbientStrength', 0.3, ...
            'FaceColor', 'interp',...
            'SpecularColorReflectance', 0.1);
        %,'XData',([1:1:c,1:1:r])%,'YData',T2(1:r,1:r))
end
set(ui.main.axesH, ...
    'xgrid', option.surfaceGrid, ...
    'ygrid', option.surfaceGrid, ...
    'zgrid', option.surfaceGrid);
set(ui.main.axesH, 'Box', option.surfaceBox);
colormap(option.colorMap);
camlight right;
% plot labels (char(10) = newline)
ylabel(ui.main.axesH, [variable(1).T.label , char(10), ...
    '\fontsize{7} (normalized)'], ...
    'FontSize', 12, 'horiz', 'center');
xlabel(ui.main.axesH, [variable(1).X.label , char(10), ...
    '\fontsize{7} (normalized)'], ...
    'FontSize', 12, 'horiz', 'center');
zlabel(ui.main.axesH,[variable(1).Y.label ,variable(1).Y.units], ...
    'FontSize', 12);

% enable plot rotation
ui.main.rotate3dH = rotate3d(ui.main.axesH);
rotate3d(ui.main.axesH);
set(ui.main.rotate3dH, 'enable', 'on');

switch get(ui.main.figH, 'renderer')
    case 'OpenGl'
        set(ui.main.rotate3dH, 'RotateStyle', 'orbit');
    case 'Painters' % Painters is much slower at rendering than OpenGL
        set(ui.main.rotate3dH, 'RotateStyle', 'box');
end

end


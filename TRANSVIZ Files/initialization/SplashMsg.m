function htmlStr = SplashMsg(ui)
trStart='<tr><td style="margin-left:25px;margin-right:5px;padding:0px;" valign="top">�</td><td style="margin:0px;padding:0px;">';
trEnd='</td></tr>';
verStart='<div style="text-align:left;margin-left:15px;margin-bottom:2px;">[';
verEnd=']</div>';
tableStart = '<table style="margin-bottom:8px">';
tableEnd= '</table>';
title = '<html><br><div style="font-family:Arial, Helvetica, sans-serif;"><div style="font-size:24px;font-weight:bold;text-align:center;">';
author = '</div><div style="text-align:justify;margin-top:6px;margin-right:4px;text-align:center;">';
email = '<br>';
newPar = '</div><div style="text-align:justify;margin-left:8px;margin-right:4px;text-indent:16px;">';
sectionStart = '<br><br><div style="font-size:12px;font-weight:bold;text-align:left;margin-left:5px;margin-bottom:5px;">';
sectionEnd = ':</div>';


%     newPar,...
%     'Get started by opening a NetCDF file by using the above menu bar.  When entering in variables, the first variable is the ''primary variable'' that controls the plot axes and slider length '...
%     'that all subsequent input variables use.  While all entered variables are plotted in ''Line Plot'' mode, only the primary variable is used in the ''Heat Map'' and ''Surface Plot'' plotting modes.'...
%     newPar,...
%     'Variables may be removed from the plot by deleting their entries in their corresponding entry boxes.  Deleting the master variable resets the entire plot. '...
%     'A table of all variables within the CDF file may be found under the ''View'' user menu.  Selecting a cell on this table will automatically plot the data corresponding to the variable of the selected cell row.' ...
htmlStr = [ ...
    title,'TRANSVIZ v2.04'...
    author,'Created by Christopher Wilson' ...
    email,'cwils16@u.rochester.edu'...
    '<br><br><br>',...
    newPar,...
    'Source code now available on github -- https://github.com/metxchris/TRANSVIZ' ...
    '<br><br>' ...
    'The source code of this version of TRANSVIZ was written using Matlab version R2014b, and is not compatible with Matlab versions R2013 and earlier.'...
    '</div>' ...
    sectionStart,'Update Log',sectionEnd ...
    verStart,'Version 2.04',verEnd...
    tableStart...
    trStart,'Updated code to be compatibile with Matlab versions R2014+.',trEnd...
    trStart,'Many graphical improvements and fixes due to the new capabilities of the Matlab R2014b graphics system.',trEnd...
    trStart,'Line transparency options added; legend background is now semi-transparent.',trEnd...
    trStart,'Known Export Figure bug - there will be extra whitespace when exporting an .eps file.  This is an issue with Matlab version R2014b; a known fix has not been found yet.',trEnd...
    tableEnd ...
    verStart,'Version 2.03',verEnd...
    tableStart...
    trStart,'Final TRANSVIZ version compatibile with Matlab versions R2013 and older.',trEnd...
    trStart,'Various bug fixes and code cleanup.',trEnd...
    tableEnd ...
    verStart,'Version 2.02',verEnd...
    tableStart...
    trStart,'Surface plotting re-enabled; find the option under the edit > plot mode menu.',trEnd...
    trStart,'Variable tooltips moved to entry boxes.  ''+'' symbols now produce a context menu to edit line properties when clicked.',trEnd...
    trStart,'Pointer list window added.  Pointers cannot be plotted, but their Fct IDs are displayed when they are entered into an entry box.',trEnd...
    trStart,'Variables can now be plotted by varID number.  Numbers are listed on the variable and pointer list windows.  Plotting by varID makes it easy to plot Fct IDs given by pointers.  For example, entering in ''1'' will plot the TIME variable.',trEnd...
    trStart,'Default color schemes changed.  Minor all-around asthetic improvements.',trEnd...
    tableEnd ...
    verStart,'Version 2.01 - Major Update',verEnd...
    tableStart...
    trStart,'Complete code reorganization and rewrite using a structured format (pseudo object-oriented).  Many features have been simplified and optimized for speed and stability; several less-used features have been removed.  Several minor improvements have not been listed below.',trEnd...
    trStart,'Multiple CDF Plotting: Slider now updates time/position values of variables from multiple CDFs simultaneously. Input CDF data has been interpolated onto common grids to achieve this functionality. Variable plots will now disappear when slider value goes outside of defined variable range.',trEnd...
    trStart,'Active CDF drop-down menu only determines what CDF is being used to load variables from, and no longer determines the range of slider values.',trEnd...
    trStart,'Slider Optimization: Slider functionality now updates more than twice as smoothly as before with much improved stability.',trEnd...
    trStart,'Variable Entry: The top-most utilized entry-box is used to determine x- and y- plot labels;  Otherwise, variables now plot independently of one another; the first entry-box variable is no longer the primary variable. Gradient calculations have been removed.',trEnd...
    trStart,'One-dimensional variables such as TE0 are now displayed as constant lines over all position values, even though they are technically only defined for a single point.  There is no general formula that can be followed to display each of these variables properly.',trEnd...
    trStart,'''+'' symbols now appear next to active entry boxes; these symbols reflect the color of the associated plotted variable, and also provide CDF information in the form of a tool-tip.',trEnd...
    trStart,'Variable List Optimization: Load and sort times are now more than ten times as fast as before.  Overall presentation polished as well.',trEnd...
    trStart,'Feature Simplifications: Plot tools moved from toolbar to overhead menu; Data cursor (point value) tool removed. Spreadsheet/table mode removed due to compatibility issues with multiple CDF plotting. On the other hand, data can now be directly exported from the plot itself.',trEnd...
    trStart,'Plotting Simplifications: Heatmap mode removed; surface plot mode disabled until future update.  Local plotting mode removed; use the zoom tool instead.',trEnd...
    trStart,'Export Organization: Data and Figure export now require the user to select the name and path of the file being created. Format of exported .csv/.txt data now displays differently than before -- scripts written to read this data will need to be updated.',trEnd...
    trStart,'Console window has not been updated, but remains in place for debugging purposes.  Dummy variables have been removed.',trEnd...
    trStart,'This gui has been renamed to TRANSVIZ from CDF Viewer, as per the suggestion of Prof. Kritz of Lehigh University.',trEnd...
    tableEnd ...
    verStart,'Version 1.06',verEnd...
    tableStart...
    trStart,'Support for multiple CDF plotting added.',trEnd...
    tableEnd ...
    verStart,'Version 1.05',verEnd...
    tableStart...
    trStart,'Toolbar added with four plotting tools: Zoom In, Zoom Reset, Panning, Point Value.',trEnd...
    trStart,'Several bug fixes.',trEnd...
    tableEnd ...
    verStart,'Version 1.04',verEnd...
    tableStart...
    trStart,'Slider control optimized.  Line plots now update many times faster than before, allowing for a movie-like playback when the slider arrow is held down.',trEnd...
    trStart,'Console window now available.  Additional parameters may now be set by advanced MATLAB users via the command line.  Additionally, five global dummy variables created for general use/testing: dummy1,dummy2,...,dummy5.',trEnd...
    trStart,'Variable list table optimized and sorting of columns enabled.',trEnd.....
    trStart,'Additional entry box added to main interface, allowing for a total of six variables to be entered simultaneously.',trEnd...
    trStart,'Color options added to all plot modes; additional surface plotting options added.',trEnd...
    trStart,'Figure export now opens the figure after the export process is complete.',trEnd...
    trStart,'Gradient calculations updated for improved accuracy.  Gradient smoothing options now availble.',trEnd...
    trStart,'Plot titles and axis labels now editable.',trEnd...
    trStart,'Various variable loading and plotting optimizations.  More information is preloaded from each CDF and several redundant processes have been removed.',trEnd...
    tableEnd ...
    verStart,'Version 1.03',verEnd...
    tableStart...
    trStart,'Gradient calculations enabled.  When entering a variable in an entry box, place ''*X'' at the end of the name to take a partial derivative with respect to position.  Placing ''*T'' after the variable name takes a partial derivative with respect to time.  A normalized gradient may be taken using the syntax ''*G'' at the end of a variable name.  E.g., entering ''NE*G'' gives the normalized gradient of the electron density.',trEnd...
    trStart,'New plotting modes added.  Single variables may be plotted as a two-dimensional ''Heat Map'' or a three-dimensional ''Surface Plot''.  In ''Surface Plot'' mode, the mouse cursor changes and can be used to rotate the figure.',trEnd...
    trStart,'Table modes added. Table data now reflects only what is represented by the corresponding figure in plot mode.  For a standard ''Line Plot'', the table now only lists local time/position slices of data for each entered varaible, allowing for easy export of each data vector.  Additionally, the slider and slider mode buttons are now active in the table view, and may be used to adjust the current data position.  For ''Heat Map'' and ''Surface Plot'' modes, the table lists all values of the associated variable.',trEnd...
    trStart,'Data export overall.  Tables now export comma separated files (.csv), which are more stable and save faster than the previous excel format.  Figures now export as .eps files, and all user controls are hidden in the export.  Also, exported files will no longer overwrite a saved file name; they instead create a numbered copy of the file.',trEnd...
    trStart,'Export stability.  Errors encountered during the export process are caught and noted by the system, curtailing any lockups that may prevously have occured.',trEnd...
    trStart,'Hotkeys updated. CTRL hotkeys removed and replaced with ALT keys for the user menu.  Pressing ALT once will underline the keyboard keys that may be used to open each of the menu items. E.g., the sequential key-combination ''ALT, F, F'' (without the comma''s) provides a quick way to export a figure when in plot mode.',trEnd...
    trStart,'Zbuffer rendering option removed.  It was found to be extremely unstable when viewing a surface plot.',trEnd...
    trStart,'Grid options. The axis grid may now be turned off when in ''Line Plot'' mode.',trEnd...
    trStart,'Various interface tweaks.  Export button moved to user menu under ''File'', and the variable list option was moved to the ''Window'' menu.',trEnd...
    trStart,'Additional core code structure improvements, further reducing memory leakage.',trEnd...
    tableEnd ...
    verStart,'Version 1.02',verEnd...
    tableStart...
    trStart,'Line smoothing applied to the graphical output (OpenGL rendering), resulting in a drastically improved plotting appearance.  OpenGL is momentarily disabled when exporting a figure so that the exported image quality is preserved.',trEnd...
    trStart,'''Slider Mode'' added; two-dimensional variables may now be plotted as functions of time at specific position intervals that are set using the slider.<br> (Try plotting ''TE'' vs ''TE0''.)',trEnd...
    trStart,'Boundary options for axes limits added to ''Edit'' menu.  Global mode fixes each axis over the entire slider range, and Local mode updates the y-axis for each slider value.',trEnd...
    trStart,'Legend positioning options added to ''Edit'' menu.  ''Best'' mode keeps the legend away from the plot lines.',trEnd...
    trStart,'Graphics rendering options added.  In the rare event that OpenGL fails to render a plot, switching the renderer to a different engine should fix the error.',trEnd...
    trStart,'Fixed several crashing errors when plotting variables that differ in dimension size.',trEnd...
    trStart,'Major code structure overhaul, resulting in some memory and performance enhancements.',trEnd...
    tableEnd ...
    verStart,'Version 1.01',verEnd...
    tableStart...
    trStart,'''Load Variable List'' and ''Open CDF'' buttons moved to menu bar.',trEnd...
    trStart,'Increased number of variables available for plotting to five.',trEnd...
    trStart,'Added shortcut keys.',trEnd...
    trStart,'Removal of variables from plot by submitting a blank entry into the corresponding entry box.',trEnd...
    trStart,'Figures now export with a white background and updated filename.',trEnd...
    trStart,'Various interface tweaks.',trEnd...
    tableEnd ...
    ];

setSplashF(htmlStr,1,ui);

  function setSplashF(inputString,counter,ui)
       
        try
            jScrollPane = findjobj(ui.main.splashH);
            for k = 1:numel(jScrollPane)
                try
                    jViewPort=jScrollPane(k).getViewport;
                    break
                end
            end
            jEditbox = jViewPort.getComponent(0);
            jEditbox.setContentType('text/html');
            jEditbox.setText(inputString);
        catch
            disp(['failed to find splash table (',counter,')'])
            if counter <= 10 % Try up to 10 times to find the splash table
                counter=counter+1;
                setSplashF(inputString, counter);
            end
        end
  end

end
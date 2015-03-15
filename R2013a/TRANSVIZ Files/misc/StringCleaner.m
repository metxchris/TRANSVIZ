function outputString = StringCleaner(inputString, inputType)
% Clean up data taken from CDF file
% Note: The notation of the form "cm^3/cm" always appears as
% "units/cm^3/cm", so cm^3/cm is replaced with cm^4, not cm^2.

inputString = deblank(inputString);
if strcmp(inputType,'Units')
    if size(inputString)
        inputString = strrep(inputString, '**', '^');
        inputString = strrep(inputString, 'RADIANS', 'rad') ;
        inputString = strrep(inputString, 'RAD', 'rad') ;
        inputString = strrep(inputString, 'CM3', 'cm^3') ;
        inputString = strrep(inputString, 'CM2', 'cm^2') ;
        inputString = strrep(inputString, 'CM', 'cm') ;
        inputString = strrep(inputString, 'cm^3/cm', 'cm^4') ;
        inputString = strrep(inputString, 'cm^2/cm', 'cm^3') ;
        inputString = strrep(inputString, 'cm/cm', 'cm^2') ;
        inputString = strrep(inputString, 'Tesla', 'T') ;
        inputString = strrep(inputString, 'TESLA', 'T') ;
        inputString = strrep(inputString, 'SECONDS', 's') ;
        inputString = strrep(inputString, 'VOLTS', 'V') ;
        inputString = strrep(inputString, 'VOLT', 'V') ;
        inputString = strrep(inputString, 'SEC', 's') ;
        inputString = strrep(inputString, 'GRAMS', 'g') ;
        inputString = strrep(inputString, 'Nt-M', 'N*m') ;
        inputString = strrep(inputString, 'NtM', 'N*m') ;
        inputString = strrep(inputString, 'S2', 's^2') ;
        inputString = strrep(inputString, 'S3', 's^2') ;
        inputString = strrep(inputString, 's^3/s', 's^4') ;
        inputString = strrep(inputString, 's^2/s', 's^3') ;
        inputString = strrep(inputString, 's/s', 's^2') ;
        inputString = strrep(inputString, 'WATTS', 'W');
        inputString = strrep(inputString, 'JLES', 'J') ;
        inputString = strrep(inputString, 'AMPS', 'A') ;
        inputString = strrep(inputString, 'WEBERS', 'Wb') ;
        inputString = strrep(inputString, 'AMP', 'A') ;
        inputString = strrep(inputString, 'EV', 'eV') ;
        inputString = strrep(inputString, 'OHMS', '\Omega ') ;
        inputString = strrep(inputString, 'OHM', '\Omega ') ;
        inputString = strrep(inputString, 'Pascals', 'Pa') ;
        inputString = strrep(inputString, 'ARBITRARY UNITS', 'Arb. Units') ;
        inputString = strrep(inputString, 'N/', '#/') ;
        outputString = [' [',inputString,']'];
    else outputString = ''; % needed to avoid errors
    end
elseif strcmp(inputType,'TableUnits')
    inputString = strrep(inputString, 'RAD', 'rad') ;
    inputString = strrep(inputString, 'CM', 'cm') ;
    inputString = strrep(inputString, 'SECONDS', 's') ;
    inputString = strrep(inputString, 'SEC', 's') ;
    inputString = strrep(inputString, '#', 'N') ;
    outputString = strrep(inputString, '**', '^');
elseif strcmp(inputType,'Label')
    outputString = regexprep(lower(inputString),'(\<[a-z])','${upper($1)}');
    outputString = strrep(outputString, '**', '^');
    outputString = strrep(outputString, 'Exb', 'ExB');
    outputString = strrep(outputString, 'Nc', 'NC');
    outputString = strrep(outputString, 'X"R/A"', 'R/A');
end
end
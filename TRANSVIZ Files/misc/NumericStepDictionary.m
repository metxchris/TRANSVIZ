function numericStep = NumericStepDictionary(key)

        switch key
            case {'X', 'XB'}
                numericStep = 0.01; %normalized
            case 'MCINDX'
                numericStep = 1/220; %normalized
            case {'RMAJM', 'RMJSYM'}
                numericStep = 1; %cm
            case 'THETA'
                numericStep = 0.0628; %rad
            case {'ILDEN', 'ILIM', 'INTNC', 'IVISB'}
                numericStep = 1;
            case ''
                % one-dimensional variables
                numericStep = 0.01; % dimensionless
        end
        
end

classdef RS_constants < handle
   
    properties (Constant)
        
        folder_search_str   = '*Stim';                                             % Set folder search string
        file_search_str     = 'ADDS*.set';
        outputFolders = {'Raw', 'Interpolated', 'ARed'};  % Data dirs


        %% Set pre-processing parameters
        sRate         = 500                               % Sample rate
        hiCutOff      = 0.5                               % High-pass cut-off
        loCutOff      = 47                                % Low-pass cut-off
        montageFile   = 'GSN-HydroCel-128.sfp'            % Montage file
        remChans      = [14 17 21 38 43 44 48 49 56,... 
                         107 113 114 119 120 121];        % Electrodes that are ususally poorly placed
        missingChans  = 125:128                           % Electrodes that are missing
        VEOGCutoff    = 100                               % uV cutoff for VEOG
        ARwinLength   = 500                               % Length of artefact rejection window in ms
        ARwinStep     = 250                               % Step size of sliding window for artefact rejection
        
        %% Set parameters for bad channel detection
        
        hiCutOff_bc   = 0.5                               % High-pass cut-off for bad chan
        loCutOff_bc   = 20                                % Low-pass cut-off for bad chan
        
        
        
    end
    
end
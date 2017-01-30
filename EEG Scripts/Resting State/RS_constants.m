classdef RS_constants < handle
   
    properties (Constant)
        
        folder_search_str   = '*Stim';                    % Folder search string
        file_search_str     = 'ADDS*.set';                % File search string  
        outputFolders       = {'Raw', 'Interpolated', 'ARed'};  % Data output dirs

        %% Set pre-processing parameters
        
        sRate         = 500                               % Sample rate
        hiCutOff      = 0.5                               % High-pass cut-off
        loCutOff      = 47                                % Low-pass cut-off
        montageFile   = 'GSN-HydroCel-128.sfp'            % Montage file
        remChans      = [14 17 21 38 43 44 48 49 56,... 
                         107 113 114 119 120 121];        % Electrodes that are ususally poorly placed
        missChans     = 125:128                           % Electrodes that are missing
        
        %% Artefact rejection parmeters
        
        VEOGCutoff    = 100                               % uV cutoff for VEOG
        ARwinLength   = 500                               % Length of artefact rejection window in ms
        ARwinStep     = 250                               % Step size of sliding window for artefact rejection
        % Use shorter, non-overlapping window to minimise data loss during
        % artefact rejection
        firstDet      = 0                                 % Stop on first chan the includes artefact (1 = Y, 0 = N)
        fCutoff       = []                                % Cutoffs for filter pass band (empty = no filter)
        fOrder        = 100                               % Filter order
        
        ARcolour      = []                                % Colour to highlight rejected components [R G B]
        
        %% Set parameters for bad channel detection
        
        hiCutOff_bc   = 0.1                               % High-pass cut-off for bad chan
        loCutOff_bc   = 30                                % Low-pass cut-off for bad chan
        
        badChanProp   = 0.05                              % Proportion cut-off for interpolation of chanels within segments of bad data
    end
    
end
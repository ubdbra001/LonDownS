 classdef const_ETold < handle
    %CONSTANTS of our application
    
    
    properties (Constant)
        
        folder_search_str = 'ADDS*';                                               % Set folder search string
        file_search_str   = '*Buffer_T3.mat';                                      % Set file search string
        % T1 = Immediate and 10 min delay
        % T3 = 2-3 hour delay
        % T4 = Next day delay
        
        outputDir         = '/Volumes/ADDS/Dan/Exported ET';                       % Set parent data export Directory
        markerFname       = 'event_markers.txt';                                   % Set filename for event markers
        analysFname       = 'analysis_methods.txt';                                % Set filename for analysis methods
        eventDlgStr       = 'Please select which events you want to look for:';    % Event list dialogue string
        anlysDlgStr       = 'Please select which analyses you want to use:';       % Analysis list dialogue string
        timeWinStr        = 'Please select the time window length in ms:';         % Time window input dialogue string
        defaultTimeWin    = {'250'};                                               % Default time window (ms)
        selectOp         = 'multiple';                                            % Default setting for list dialogue selection
        
        

    end
  
    
end


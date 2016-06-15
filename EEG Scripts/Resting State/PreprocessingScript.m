%% Pre-processing script for Resting state data

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

folder_search_str = 'ADDS*';                                               % Set folder search string
file_search_str   = '*.raw';                                               % Set file search string

path  = uigetdir('','Select main data folder');                            % Ask participant to select main data folder
if path == 0; error('Path not selected'); end                              % Throw error if no path selected

cd(path)                                                                   % Change to main data folder
files = dir(file_search_str);                                              % Get all the ADDS files available

for file_n = 1:length(files)                                               % Run through each file
    EEG = pop_readegi(files(file_n).name, [],[],'auto');                   % Load file
    
    events.ind      = [EEG.event(strcmp({EEG.event.type}, 'MOVI')).urevent];
    events.start    = EEG.times([EEG.event(strcmp({EEG.event.type}, 'MOVI')).latency]); % Find the times for 
    events.end      = EEG.times([EEG.event(strcmp({EEG.event.type}, 'MOVX')).latency]);
    events.length   = events.end - events.start;
    

    
    
end

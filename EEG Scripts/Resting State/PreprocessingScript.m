%% Pre-processing script for Resting state data

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

res = which('eeglab.m');
addpath(genpath([res(1:end-length('eeglab.m')) 'functions']))

file_search_str   = '*.RAW';                                               % Set file search string
savepath_str = sprintf('%s/RS/%%s/', orig_path);

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
    
    ALLEEG = EEG;
    
    for event_n = 1:numel(events.ind)
        EEG = pop_epoch(EEG, {'MOVI'}, [0 events.length(event_n)/1000], 'eventindices', events.ind(event_n));
        if events.length(event_n)/1000 > 65
            savepath = sprintf(savepath_str, 'Social Stim');
        else
            savepath = sprintf(savepath_str, 'Non-Social Stim');
        end
        EEG = pop_saveset(EEG, 'filename', EEG.filename, 'filepath', savepath);
    end
    
    
end

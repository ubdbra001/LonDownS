%% Pre-processing script for Resting state data

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

res = which('eeglab.m');
addpath(genpath([res(1:end-length('eeglab.m')) 'functions']))

path  = uigetdir('','Select main data folder');                            % Ask participant to select main data folder
if path == 0; error('Path not selected'); end                              % Throw error if no path selected

file_search_str   = '*.RAW';                                               % Set file search string
savepath_str = sprintf('%s/RS/%%s/', path);

cd(path)                                                                   % Change to main data folder
files = dir(file_search_str);                                              % Get all the ADDS files available

for file_n = 70:length(files)                                               % Run through each file
    [EEG, ALLEEG, events] = deal ([]);
    EEG = pop_readegi(files(file_n).name, [],[],'auto');                   % Load file
    EEG.setname = strtok(files(file_n).name,' .');
    
    events.ind      = [EEG.event(strcmp({EEG.event.type}, 'MOVI')).urevent];
    events.start    = EEG.times([EEG.event(strcmp({EEG.event.type}, 'MOVI')).latency]); % Find the times for 
    events.end      = EEG.times([EEG.event(strcmp({EEG.event.type}, 'MOVX')).latency]);
    try
        events.length   = events.end - events.start;
    catch
        continue
    end
    ALLEEG = EEG;
    
    for event_n = 1:numel(events.ind)
        EEG = pop_epoch(EEG, {'MOVI'}, [0 events.length(event_n)/1000], 'eventindices', events.ind(event_n), 'newname', EEG.setname);
        if events.length(event_n)/1000 > 65
            EEG.condition = 'Social Stim';
        else
            EEG.condition = 'Non-Social Stim';
        end
        EEG = pop_saveset(EEG, 'filename', EEG.setname, 'filepath', sprintf(savepath_str, EEG.condition));
        EEG = ALLEEG;
    end
        
end

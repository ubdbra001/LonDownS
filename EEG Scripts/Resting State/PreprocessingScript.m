%% Pre-processing script for Resting state data

paths.script = strsplit(fileparts(mfilename('fullpath')), filesep);
paths.script{1} = filesep; 
addpath(fullfile(paths.script{:}));
addpath(fullfile(paths.script{1:end-1}))

addEEGLAB;

paths.data  = uigetdir('','Select main data folder');                      % Ask user to select main data folder
if paths.data == 0; error('Path not selected'); end                        % Throw error if no path selected

folder_search_str   = '*Stim';                                             % Set folder search string
file_search_str     = 'ADDS*.set';

% Set pre-processing parameters
params = struct('outputFolders', {{'Raw', 'Interpolated', 'Epoched'}},...  Data dirs
                'epochLength', 2,...                                       Epoch length in seconds
                'hiCutOff', 0.5,...                                        High-pass cut-off
                'lowCutOff', 45,...                                        Low-pass cut-off
                'montageFile', 'GSN-HydroCel-128.sfp',...                  Montage file (NB: Check the montage file is correct)
                'earChans', [44 48 48 113 114 119],...                     Ear electrode numbers (NB: check these)
                'VEOGChans', [126 127],...                                 Electrodes for Vertical EOG (NB: check these)
                'HEOGChans', [125 128],...                                 Electrodes for Horizontal EOG (NB: check these)
                'VEOGCutoff', 70,...                                       uV cutoff for VEOG
                'HEOGCutoff', 40,...                                       uV cutoff for HEOG
                'epochWin',1);%                                            Size of epoch window

cd(paths.data)                                                             % Change to main data dir
folders = dir(folder_search_str);                                          % Get the different stimulus types available (in different dirs)

for folder_n = 1:length(folders)                                           % Run through each dir
    params.currDir = fullfile(paths.data, folders(folder_n).name);         % Generate dir name for current loop
    cd(params.currDir)                                                     % Change to that dir
    files = dir(file_search_str);                                          % Get all .set files in that dir
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        if EEG.srate > 500                                                 % Resample to 500 Hz if original sample rate is greater
            EEG = pop_resample(EEG, 500);
        end
        EEG = pop_chanedit(EEG, 'lookup', params.montageFile);             % Change electrode montage to one we are using (EGI HydroCel GSN 128 chan)
        EEG.include = 1:EEG.nbchan;                                        % Initially include all electroeds in steps
        EEG.include = setdiff(EEG.include, params.earChans);               % Remove ear channels from analyses (caps don't fit properly around the ears so remove 3 ear electrodes from each side)

        EEG = pop_eegfiltnew(EEG, params.hiCutOff, params.lowCutOff, 3300, 0, [], 0); % Bandpass filter (NB: Correct filter order?)
        %EEG = pop_eegfiltnew(EEG, params.notchLo, params.notchHi, [],1);   % Notch filter at 49-51 Hz
        
        % Filters need to be applied before bad chan ID
        % Could temporarily filter the data to ID the bad chans and then
        % apply other filters downstream?
        
        EEG.chanStats = channel_properties(EEG, params.includedChans, []); % Calculate channel stats using FASTER algorithm
        EEG.badChans  = min_z(EEG.chanStats);                              % Determine bad channels from the stats (currently using default settings: 3+ z-scores)
        
%         Bad channel replacement (spherical spline interpolation)
%           - Use automatic methods?


        EEG = pop_saveset(EEG,...                                          % Save after interpolation
                          'filename', sprintf('%s_%s', EEG.setname, params.outputFolders{2}),...
                          'filepath', params.currDir);
                      
        if ~exist(params.outputFolders{1}, 'dir')                          % Check if raw dir exists and create if not
            mkdir(params.currDir, params.outputFolders{1})
        end
        
        % Move raw file to different folder
        movefile(files(file_n).name, fullfile(params.outputFolders{1}, files(file_n).name));
        
%         Semi - automatic artifact rejection for eye movements, blinks, & movement artifacts
%           - Need exact criteria

        EEG.include = setdiff(EEG.include, [params.VEOGChans, params.HEOGChans]); % Remove HEOG & VEOG channels from analyses

        % Generate list of latencies for epoching the data
        params.eventLatencies = num2cell((params.epochWin/2:params.epochWin:EEG.xmax-params.epochWin/2)' * EEG.srate);
        
        % Write the epochs to the EEG eventlist
        EEG.event = struct('type', repmat({'RSepoch'}, length(params.eventLatencies),1), 'latency', params.eventLatencies);


%         Add Laplacian filter or Re-reference to average ref? or Both?
%      
    end
    
end

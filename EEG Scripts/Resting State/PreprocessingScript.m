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
params = struct('outputFolders', {{'Raw', 'Interpolated', 'ARed'}},...     Data dirs
                'epochLength',   2,...                                     Epoch length in seconds
                'hiCutOff',      0.5,...                                   High-pass cut-off
                'lowCutOff',     47,...                                    Low-pass cut-off
                'montageFile',   'GSN-HydroCel-128.sfp',...                Montage file
                'remChans',      [14 17 21 38 43 44 48 49 56,... 
                                  107 113 114 119 120 121],...             Electrodes that are ususally poorly placed
                'missingChans',  125:128,...                               Electrodes that are missing
                'VEOGCutoff',    70,...                                    uV cutoff for VEOG
                'epochWin',      1);%                                      Size of epoch window

cd(paths.data)                                                             % Change to main data dir
folders = dir(folder_search_str);                                          % Get the different stimulus types available (in different dirs)

for folder_n = 1:length(folders)                                           % Run through each dir
    params.currDir = fullfile(paths.data, folders(folder_n).name);         % Generate dir name for current loop
    cd(params.currDir)                                                     % Change to that dir
    files = dir(file_search_str);                                          % Get all .set files in that dir
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        %% 1. Resample to 500 Hz if original sample rate is greater 
        if EEG.srate > 500                                                 
            EEG = pop_resample(EEG, 500);
        end
        
        %% 2. Change electrode montage to one we are using (EGI HydroCel GSN 128 chan)
        EEG = pop_chanedit(EEG, 'lookup', params.montageFile);
        
        %% 3. Update included electrode list to remove poorly placed electrodes
        EEG.removedChans = [params.remChans params.missingChans];          % Record poorly placed electrodes
        EEG.includedChans = setdiff(1:EEG.nbchan, EEG.removedChans);       % Remove these from analyses
        
        %% 4 Methods for IDing bad channels - needs work (move into single function?)
        
        EEG = BadChanID(EEG);
        
        %% 5. Interpolate Bad channels
        
%         Bad channel replacement (spherical spline interpolation)
%           - Use automatic methods?

        %% Save data and archive original files
        EEG = pop_saveset(EEG,...                                          % Save after interpolation
                          'filename', sprintf('%s_%s', EEG.setname, params.outputFolders{2}),...
                          'filepath', params.currDir);
                      
        if ~exist(params.outputFolders{1}, 'dir')                          % Check if raw dir exists and create if not
            mkdir(params.currDir, params.outputFolders{1})
        end
        
        % Move raw file to different folder
        movefile(files(file_n).name, fullfile(params.outputFolders{1}, files(file_n).name));
        
        %% 6. Filter data
        
        EEG = pop_eegfiltnew(EEG, params.hiCutOff, params.lowCutOff, 3300, 0, [], 0); % Bandpass filter (NB: Correct filter order?)

        %% 7. Remove artefacts but save removed portions
%         Semi - automatic artifact rejection for eye movements, blinks, & movement artifacts
%           - Need exact criteria

        %EEG.include = setdiff(EEG.include, [params.VEOGChans, params.HEOGChans]); % Remove HEOG & VEOG channels from analyses
        
        
        %% Save data post artefact rejection and archive interpolated files
        
        EEG = pop_saveset(EEG,...                                          % Save after interpolation
                          'filename', sprintf('%s_%s', EEG.setname, params.outputFolders{3}),...
                          'filepath', params.currDir);
                      
        if ~exist(params.outputFolders{1}, 'dir')                          % Check if raw dir exists and create if not
            mkdir(params.currDir, params.outputFolders{2})
        end
        
        % Move raw file to different folder
        movefile(files(file_n).name, fullfile(params.outputFolders{2}, files(file_n).name));
    end
    
end

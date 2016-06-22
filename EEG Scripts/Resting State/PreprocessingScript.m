%% Pre-processing script for Resting state data

scriptPath = strsplit(fileparts(mfilename('fullpath')), filesep);
addpath(fullfile(scriptPath{:}));
addpath(fullfile(scriptPath{1:end-1}))

addEEGLAB;

mainPath  = uigetdir('','Select main data folder');                        % Ask user to select main data folder
if mainPath == 0; error('Path not selected'); end                          % Throw error if no path selected

folder_search_str   = '*Stim';                                             % Set folder search string

% Set pre-processing parameters
params = struct('outputFolders', {'Interpolated', 'Epoched'},...           % Output folders
                'epochLength', 2,...                                       % Epoch length in seconds
                'hiCutOff', 0.1,...                                        % High-pass cut-off
                'lowCutOff', 30,...                                        % Low-pass cut-off
                'montageFile', 'GSN-HydroCel-128.sfp');                                          

cd(mainPath)                                                               % Change to main data folder
folders = dir(file_search_str);                                            % Get the different stimulus types available

for folder_n = 1:length(folders)                                           % Run through each folder
    cd(fullfile(mainPath, folders(folder_n).name))                         % Change to that folder
    files = dir('ADDS*.set');                                              % Get all .set files in that folder
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        if EEG.srate > 500                                                 % Resample to 500 Hz if original sample rate is greater
            EEG = pop_resample(EEG, 500);
        end
        
        EEG = pop_chanedit(EEG, 'lookup', params.montageFile);             % Change electrode montage to one we are using (EGI HydroCel GSN 128 chan)
        EEG = pop_eegfiltnew(EEG, params.hiCutOff, params.lowCutOff);      % Filter 0.1-30 Hz (remove 30Hz filter?)
%         Remove ear channels (the caps don?t fit properly around the ears in our participants so we remove 3 ear electrodes from each side)
%           - Which electrodes?
%         Bad channel replacement (spherical spline interpolation)
%           - Use automatic methods?
%           - Do this earlier (post-filter)?
%         Save after interpolation
%         Semi - automatic artifact rejection for eye movements, blinks, & movement artifacts
%           - Need exact criteria
%         Eye electrode removal
%         Epoch the data into either 1 or 2 sec segments
%           - Add phantom events located in the centre of each epoch

%         Re-reference to average ref
%           - Why here?
    end
    
end

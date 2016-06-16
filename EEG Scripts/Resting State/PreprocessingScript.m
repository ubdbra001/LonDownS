%% Pre-processing script for Resting state data

scriptPath = strsplit(fileparts(mfilename('fullpath')), filesep);
addpath(fullfile(scriptPath{:}));
addpath(fullfile(scriptPath{1:end-1}))

addEEGLAB;

mainPath  = uigetdir('','Select main data folder');                        % Ask user to select main data folder
if mainPath == 0; error('Path not selected'); end                          % Throw error if no path selected

folder_search_str   = '*Stim';                                             % Set folder search string                      

% Set pre-processing parameters
params = struct('outputFolders', {'Epoched', 'Rejected', 'Competed'},...   % Output folders
                'epochLength', 2,...                                       % Epoch length in seconds
                'hiCutOff', 0.1,...                                        % High-pass cut-off
                'lowCutOff', 30);                                          % Low-pass cut-off

cd(mainPath)                                                               % Change to main data folder
folders = dir(file_search_str);                                            % Get the different stimulus types available

for folder_n = 1:length(folders)                                           % Run through each folder
    cd(fullfile(mainPath, folders(folder_n).name))                         % Change to that folder
    files = dir('ADDS*.set');                                              % Get all .set files in that folder
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        
%         montage (we use a 128 channel net)
        EEG = pop_eegfiltnew(EEG, params.hiCutOff, params.lowCutOff);      % Filter 0.1-30 Hz
%         Remove ear channels (the caps don?t fit properly around the ears in our participants so we remove 3 ear electrodes from each side)
%           - Which electrodes?
%         Epoch the data into either 1 or 2 sec segments
%           - Add phantom events located in the centre of each epoch
%         Automatic artifact rejection for eye movement and blinks
%           - Need exact criteria
%         Visual artifact removal for movement artifacts
%         Eye electrode removal
%         Bad channel replacement (spherical spline interpolation)
%           - Use automatic methods?
%           - Do this earlier (post-filter)?
%         Re-reference to average ref
%           - Why here?
    end
    
end

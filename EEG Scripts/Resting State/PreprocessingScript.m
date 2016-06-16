%% Pre-processing script for Resting state data

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

res = which('eeglab.m');
addpath(genpath([res(1:end-length('eeglab.m')) 'functions']))

mainPath  = uigetdir('','Select main data folder');                        % Ask participant to select main data folder
if mainPath == 0; error('Path not selected'); end                          % Throw error if no path selected

folder_search_str   = '*Stim';                                             % Set folder search string
%savepath_str = sprintf('%s/RS/%%s/', path);

cd(mainPath)                                                               % Change to main data folder
folders = dir(file_search_str);                                            % Get the different stimulus types available

for folder_n = 1:length(folders)                                           % Run through each folder
    cd(fullfile(mainPath, folders(folder_n).name))                         % Change to that folder
    files = dir('ADDS*.set');                                              % Get all .set files in that folder
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        
%         montage (we use a 128 channel net)
%         filter 0.1-30 Hz
%         Remove ear channels (the caps don?t fit properly around the ears in our participants so we remove 3 ear electrodes from each side)
%           - Which electrodes?
%         I then epoched the data into either 1 or 2 sec segments
%         Automatic artifact rejection for eye movement and blinks
%           - Need exact criteria
%         Visual artifact removal for movement artifacts
%         Eye electrode removal
%         Bad channel replacement (spherical spline interpolation)
%           - Use automatic methods?
%         Re-reference to average ref
%           - Why here?

    end
    
end

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
folders = dir(file_search_str);                                            % Get all the ADDS files available

for folder_n = 1:length(folders)
    cd(fullfile(mainPath, folders(folder_n).name))
    files = dir('ADDS*');
    for file_n = 1:length(files)                                               % Run through each file
        
    end
    
end

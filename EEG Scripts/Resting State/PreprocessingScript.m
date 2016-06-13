%% Pre-processing script for Resting state data

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

folder_search_str = 'ADDS*';                                               % Set folder search string
file_search_str   = '*.raw';                                               % Set file search string

path  = uigetdir('','Select main data folder');                            % Ask participant to select main data folder
if path == 0; error('Path not selected'); end                              % Throw error if no path selected

cd(path)                                                                   % Change to main data folder
files_t = dir(folder_search_str);                                          % Get all the ADDS files available
folders = files_t([files_t.isdir]);                                        % Select only the directories



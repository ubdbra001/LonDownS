
paths.script = strsplit(fileparts(mfilename('fullpath')), filesep);
paths.script{1} = filesep; 
addpath(fullfile(paths.script{:}));
addpath(fullfile(paths.script{1:end-1}))

addEEGLAB;

paths.data  = uigetdir('','Select main data folder');                      % Ask user to select main data folder
if paths.data == 0; error('Path not selected'); end                        % Throw error if no path selected

file_search_str     = 'ADDS*.set';

cd(paths.data)                                                             % Change to main data folder
files = dir(file_search_str);                                              % Get all .set files in that folder

for file_n = length(files):-1:1
    
    EEG = pop_loadset('filename', files(file_n).name);                     % Load the data for the file
    eegplot(EEG.data, 'submean', 'on');
    waitfor( findobj('parent', gcf, 'string', 'CLOSE'), 'userdata');
    
end

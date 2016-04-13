% New Script to nalyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% Ver 0.2 - 13/04/16
% Dan Brady

filename     = 'event_markers.txt';             % Set filename
eventMarkers = importdata(filename);            % Load markers in file

path = uigetdir('','Select main data folder');  % Ask participant to select main data folder
cd(path)                                        % Change to main data folder
folders = dir('ADDS*');                         % Get all the ADDS participant files available

[eventInd,v] = listdlg('ListString',...
    eventMarkers, 'SelectionMode', 'multiple'); % Ask participant to select which event markers to find
eventsToFind = eventMarkers(eventInd);          % Get these markers

for folder_n = 1:length(folders)                % Loop through each participant
    p_path = sprintf('%s/%s', path,...
        folders(folder_n).name);                % Create path for participants folder
    cd(p_path)                                  % Change to that path
    try
        dataFilePaths = subdir('*Buffer.mat');  % Try to generate paths for the ET data for that participant
    catch
        continue                                % Is there is an error skip to next participant
    end
    
    for file_n = 1:length(dataFilePaths)        % Loop through the 
        load(dataFilePaths(file_n).name)        % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
    end % file_n
    
    allData = [double(timeBuffer) mainBuffer];  % Concatenates timeBuffer and mainBuffer
    
    clear timeBuffer mainBuffer file_n
    
end % folder_n



% Join mainBuffer and timeBuffer

% Loop through potential event codes

% Find specific event codes in eventBuffer


 
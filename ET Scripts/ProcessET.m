% New Script to nalyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% Ver 0.2 - 13/04/16
% Dan Brady

filename     = 'event_markers.txt';                                        % Set filename
eventMarkers = importdata(filename);                                       % Load markers in file

path = uigetdir('','Select main data folder');                             % Ask participant to select main data folder
cd(path)                                                                   % Change to main data folder
folders = dir('ADDS*');                                                    % Get all the ADDS participant files available

[eventInd,v] = listdlg('ListString', eventMarkers,...
                       'SelectionMode', 'multiple');                       % Ask participant to select which event markers to find
eventsToFind = eventMarkers(eventInd);                                     % Get these markers

for folder_n = 1:length(folders)                                           % Loop through each participant
    p_path = sprintf('%s/%s', path, folders(folder_n).name);               % Create path for participants folder
    cd(p_path)                                                             % Change to that path
    try
        dataFilePaths = subdir('*Buffer.mat');                             % Try to generate paths for the ET data for that participant
    catch
        continue                                                           % Is there is an error skip to next participant
    end
    
    for file_n = 1:length(dataFilePaths)                                   % Loop through the paths
        load(dataFilePaths(file_n).name)                                   % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
    end % file_n
    
    allData   = [double(timeBuffer) mainBuffer];                           % Concatenates timeBuffer and mainBuffer
    allEvents = cell(size(eventBuffer));                                   % Preallocate allEvents variable
    allEvents(:,1:2) = eventBuffer(:,1:2);                                 % Write the first two columns of eventBuffer to allEvents
    for event_n = 1:size(eventBuffer)
        allEvents(event_n,3) = eventBuffer{event_n, 3}(1,1);               % Add the trigger label from eventbuffer to the last column of allData
    end % event_n

    for eventsToFind_n = 1:length(eventsToFind)                            % For each of the specified markers
        len = length(eventsToFind{eventsToFind_n});                        % Get number of characters in that marker
        ind = strncmpi(eventsToFind{eventsToFind_n}, allEvents(:,3),len);  % Find the specified markers in the allEvents variable
        foundEvents = [allEvents(ind, 3:-1:2) cell(sum(ind),1)];           % Place matching events and times in variable, add third column for index of event in allData file 
        for foundEvent_n = 1:length(foundEvents)                           % For each matching event found
            foundEvents{foundEvent_n,3} = find(...
                allData >= foundEvents{foundEvent_n,2},1);                 % Find the index of the first sample recorded after that event and ecord in third column
        end % foundEvent_n
        
    end % eventsToFind_n
    
    %clearvars('-except', vars);                                           % Clean up workspace                      
    
end % folder_n



 
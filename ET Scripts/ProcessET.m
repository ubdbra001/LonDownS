% New Script to nalyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.4 - 19/04/16
% Dan Brady

filename     = 'event_markers.txt';                                        % Set filename
eventMarkers = importdata(filename);                                       % Load markers in file
ADDS_ET_data = struct();                                                   % Prep main output variable

output_FName = 'ADDS_ET_output.csv';
header       = 'Participant, Event, Time, Samples\n';
fid          = fopen(output_FName, 'w');
fprintf(fid, header);

orig_path = pwd;
path      = uigetdir('','Select main data folder');                        % Ask participant to select main data folder
cd(path)                                                                   % Change to main data folder
files   = dir('ADDS*');                                                    % Get all the ADDS files available
folders = files([files.isdir]);                                            % Select only the directories

[eventInd,~] = listdlg('ListString', eventMarkers,...
                       'SelectionMode', 'multiple');                       % Ask participant to select which event markers to find
eventsToFind = eventMarkers(eventInd);                                     % Put these markers into a variable

if ~isempty(eventsToFind)                                                  % Check for user input
    for folder_n = 1:length(folders)                                       % Loop through each participant
        fprintf('\nStarting %s\n\n', folders(folder_n).name)
        p_path = sprintf('%s/%s', path, folders(folder_n).name);           % Create path for participants folder
        ADDS_ET_data.(folders(folder_n).name) = struct();                  % Create fieldname for the participant in output data variable
        cd(p_path)                                                         % Change to that path
        try
            dataFilePaths = subdir('*Buffer.mat');                         % Try to generate paths for the ET data for that participant
        catch                                                              % If there is an error
            ADDS_ET_data.(folders(folder_n).name) = 'No Data';             % Make a note of the lack of data
            fprintf('\nNo data found for %s\n\n', folders(folder_n).name)
            continue                                                       % Then skip to the next participant
        end
        
        for file_n = 1:length(dataFilePaths)                               % Loop through the paths
            load(dataFilePaths(file_n).name)                               % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
        end % file_n
        
        allData   = [double(timeBuffer) mainBuffer];                       % Concatenates timeBuffer and mainBuffer
        allEvents = cell(size(eventBuffer));                               % Preallocate allEvents variable
        allEvents(:,1:2) = eventBuffer(:,1:2);                             % Write the first two columns of eventBuffer to allEvents
        for event_n = 1:size(eventBuffer)
            allEvents(event_n,3) = eventBuffer{event_n, 3}(1,1);           % Add the trigger label from eventBuffer to the last column of allData
        end % event_n
        
        clear *Buffer
        
        for eventsToFind_n = 1:length(eventsToFind)                        % For each of the specified markers
            
            len = length(eventsToFind{eventsToFind_n});                    % Get number of characters in that marker
            ind = strncmpi(eventsToFind{eventsToFind_n},...
                           allEvents(:,3),len);                            % Find the specified markers in the allEvents variable
            foundEvents = [allEvents(ind, 3:-1:2) cell(sum(ind),1)];       % Place matching events and times in variable, add blank third column
            for foundEvent_n = 1:length(foundEvents(:,1))                       % For each matching event found
                foundEvents{foundEvent_n,3} = ...
                    find(allData >= foundEvents{foundEvent_n,2},1);        % Find the index of the first sample recorded after that event and record in third column
            end % foundEvent_n
            
            if mod(length(foundEvents),2) == 0
                eventStarts = 1:2:length(foundEvents(:,1));
            else
                eventStarts = 1:2:length(foundEvents(:,1))-1;
            end
            
            for eventStarts_n = 1:length(eventStarts)
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,1) = double(foundEvents{eventStarts(eventStarts_n)+1,2} - foundEvents{eventStarts(eventStarts_n),2})/1000;
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,2) = double(foundEvents{eventStarts(eventStarts_n)+1,3} - foundEvents{eventStarts(eventStarts_n),3});
                
                fprintf(fid,'%s,%s,%s,%d\n', folders(folder_n).name, eventsToFind{eventsToFind_n},...
                    num2str(ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,1)), ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,2));
                
            end
            
        end % eventsToFind_n
        
        fprintf('\nFinished %s\n\n', folders(folder_n).name)

        %clearvars('-except', vars);                                       % Clean up workspace
        
    end % folder_n

end
fclose(fid);

cd(orig_path)
save('ADDS_ET_data', 'ADDS_ET_data');
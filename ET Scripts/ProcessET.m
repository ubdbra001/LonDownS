% New Script to analyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.4 - 20/04/16
% Dan Brady

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path

filename     = 'Event_markers.txt';                                        % Set filename
eventMarkers = importdata(filename);                                       % Load markers in file
ADDS_ET_data = struct();                                                   % Prep main output variable

output_FName = 'ADDS_ET_output.csv';                                       % Specify output filename
header       = 'Participant, Event, Time, Total Samples, Total looking, Top Left, Top Right, Bottom Left, Bottom Right\n'; % Specify output header (This will need modifying!)
fid          = fopen(output_FName, 'w');                                   % Create and open output data file
fprintf(fid, header);                                                      % Write header to data file
                                                           
path      = uigetdir('','Select main data folder');                        % Ask participant to select main data folder
cd(path)                                                                   % Change to main data folder
files   = dir('ADDS*');                                                    % Get all the ADDS files available
folders = files([files.isdir]);                                            % Select only the directories

[eventInd,~] = listdlg('ListString', eventMarkers,...
                       'SelectionMode', 'multiple');                       % Ask participant to select which event markers to find
eventsToFind = eventMarkers(eventInd);                                     % Put these markers into a variable

if ~isempty(eventsToFind)                                                  % Check for user input
    for folder_n = 1:length(folders)                                       % Loop through each participant
        fprintf('\nStarting %s\n\n', folders(folder_n).name)               % Starting message
        p_path = sprintf('%s/%s', path, folders(folder_n).name);           % Create path for participants folder
        ADDS_ET_data.(folders(folder_n).name) = struct();                  % Create fieldname for the participant in output data variable
        cd(p_path)                                                         % Change to that path
        try
            dataFilePaths = subdir('*Buffer_T1.mat');                      % Try to generate paths for the ET data for that participant
        catch                                                              % If there is an error
            ADDS_ET_data.(folders(folder_n).name) = 'No Data';             % Make a note of the lack of data
            fprintf('\nNo data found for %s\n\n', folders(folder_n).name)  % No data found message
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
        
        clear *Buffer                                                      % Clear loaded variables
        
        for eventsToFind_n = 1:length(eventsToFind)                        % For each of the specified markers
            len = length(eventsToFind{eventsToFind_n});                    % Get number of characters in that marker
            ind = strncmpi(eventsToFind{eventsToFind_n},...
                           allEvents(:,3),len);                            % Find the specified markers in the allEvents variable
            foundEvents = [allEvents(ind, 3:-1:2) cell(sum(ind),1)];       % Place matching events and times in variable, add blank third column
            for foundEvent_n = 1:length(foundEvents(:,1))                       % For each matching event found
                foundEvents{foundEvent_n,3} = ...
                    find(allData >= foundEvents{foundEvent_n,2},1);        % Find the index of the first sample recorded after that event and record in third column
            end % foundEvent_n
            
            if mod(length(foundEvents),2) == 0                             % Check that there is an even number of triggers (i.e. they come in pairs)
                eventStarts = 1:2:length(foundEvents(:,1));
            else                                                           % If not ignore the lone last trigger
                eventStarts = 1:2:length(foundEvents(:,1))-1;
            end
            
            for eventStarts_n = 1:length(eventStarts)                      % For each trigger found
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,1) =...
                    double(foundEvents{eventStarts(eventStarts_n)+1,2} - foundEvents{eventStarts(eventStarts_n),2})/1000; % Calculate the time between the start and end triggers (ms)
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,2) =...
                    length(foundEvents{eventStarts(eventStarts_n),3}:foundEvents{eventStarts(eventStarts_n)+1,3}); % Calculate the number of samples in the epoch
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,3:7) =...
                    func_quadrantsLT(allData(foundEvents{eventStarts(eventStarts_n),3}:foundEvents{eventStarts(eventStarts_n)+1,3},:)); % Calculate the looking time per quadrant
                
                fprintf(fid,'%s,%s,%s,%d%s\n',...                         % Write data to file
                    folders(folder_n).name,...                             % Participant ID
                    eventsToFind{eventsToFind_n},...                       % Event
                    num2str(ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,1)),...         % Event epoch
                    ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,2),...                  % Samples in the epoch
                    sprintf(',%d', ADDS_ET_data.(folders(folder_n).name).(eventsToFind{eventsToFind_n})(eventStarts_n,3:7)));  % Looking time quadrant output
            end
            
        end % eventsToFind_n
        
        fprintf('\nFinished %s\n\n', folders(folder_n).name)               % Finished message

        %clearvars('-except', vars);                                       % Clean up workspace
        
    end % folder_n

end
fclose(fid);                                                               % Close the data file
cd(orig_path)                                                              % Change back to the original file path
save('ADDS_ET_data', 'ADDS_ET_data');                                      % Save the ADDS_ET_data structure
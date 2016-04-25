% New Script to analyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.6 - 25/04/16
% Dan Brady

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

filename     = 'Event_markers.txt';                                        % Set filename
eventMarkers = readtable(filename);                                        % Load markers in file
ADDS_ET_data = struct();                                                   % Prep main output variable

% Add option box asking about analyses
% Modify header based of analyses indicated

output_FName = sprintf('ADDS_ET_output_%s.csv', datestr(now,'dd_mm_yy',1));% Specify output filename
header       = ['Participant,Task type,Trial Type,Block number,Trial number,Event start time,'...
                'Time between Markers(ms),Samples between markers,'...
                'Trial length(ms),Samples in trial,'...
                'Total looking,Top Left,Top Right,Bottom Left,Bottom Right\n']; % Specify output header (This will need modifying!)
fid          = fopen(output_FName, 'w');                                   % Create and open output data file
fprintf(fid, header);                                                      % Write header to data file
                                                           
path    = uigetdir('','Select main data folder');                          % Ask participant to select main data folder
cd(path)                                                                   % Change to main data folder
files   = dir('ADDS*');                                                    % Get all the ADDS files available
folders = files([files.isdir]);                                            % Select only the directories

[eventInd,~] = listdlg('ListString', eventMarkers.Event_name,...
                       'SelectionMode', 'multiple');                       % Ask participant to select which event markers to find
eventsToFind = eventMarkers(eventInd,:);                                   % Put these markers into a variable

if ~isempty(eventsToFind)                                                  % Check for user input
    for folder_n = 1:size(folders,1)                                       % Loop through each participant
        commandwindow
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
        
        for file_n = 1:size(dataFilePaths,1)                               % Loop through the paths
            load(dataFilePaths(file_n).name)                               % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
        end % file_n
        
        allData   = [double(timeBuffer) mainBuffer];                       % Concatenates timeBuffer and mainBuffer
        allEvents = cell(size(eventBuffer));                               % Preallocate allEvents variable
        allEvents(:,1:2) = eventBuffer(:,1:2);                             % Write the first two columns of eventBuffer to allEvents
        allEvents(:,3) = cellfun(@(x) x{1},eventBuffer(:,3),'UniformOutput', false); % Add the trigger label from eventBuffer to the last column of allData
        
        clear *Buffer                                                      % Clear loaded Buffer variables
        
        for eventsToFind_n = 1:size(eventsToFind,1)                        % For each of the specified markers
            len = length(eventsToFind.Event_name{eventsToFind_n});         % Get number of characters in that marker
            ind = strncmpi(eventsToFind.Event_name{eventsToFind_n},...
                           allEvents(:,3),len);                            % Find the specified markers in the allEvents variable
            foundEvents = [allEvents(ind, 3:-1:2) cell(sum(ind),1)];       % Place matching events and times in variable, add blank third column
            for foundEvent_n = 1:size(foundEvents(:,1),1)                  % For each matching event found
                foundEvents{foundEvent_n,3} = ...
                    find(allData >= foundEvents{foundEvent_n,2},1);        % Find the index of the first sample recorded after that event and record in third column
            end % foundEvent_n
            
            if mod(length(foundEvents),2) == 0                             % Check that there is an even number of triggers (i.e. they come in pairs)
                eventStarts = 1:2:length(foundEvents(:,1));
            else                                                           % If not ignore the lone last trigger
                eventStarts = 1:2:length(foundEvents(:,1))-1;
            end
            
            for eventStarts_n = 1:length(eventStarts)                      % For each trigger found
                
                event_labels = func_trial_labels(foundEvents{eventStarts(eventStarts_n),1}, eventStarts_n, eventMarkers.Trials(eventsToFind_n));% Add function to label each trial by task and admin
                % (familiarisation vs test)
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,1) =...
                    (foundEvents{eventStarts(eventStarts_n)+1,2} - foundEvents{eventStarts(eventStarts_n),2})/1000; % Calculate the time between the start and end triggers (ms)
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,2) =...
                    length(foundEvents{eventStarts(eventStarts_n),3}:foundEvents{eventStarts(eventStarts_n)+1,3}); % Calculate the number of samples in the epoch
                
                trial_end_ind =... % Find the index of the next recorded time point after the stimulus display ends
                    find(allData >= (foundEvents{eventStarts(eventStarts_n),2}+(eventsToFind.Event_length(eventsToFind_n)*1000)),1);
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,3) =...
                    (allData(trial_end_ind,1)- foundEvents{eventStarts(eventStarts_n),2})/1000; % Calculate the number of seconds stimulus was displayed for
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,4) =...
                    length(foundEvents{eventStarts(eventStarts_n),3}:trial_end_ind); % Calculate the number of samples the stimulus was displayed for
                
                ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,5:9) =...
                    func_quadrantsLT(allData(foundEvents{eventStarts(eventStarts_n),3}:trial_end_ind,:)); % Calculate the looking time per quadrant
                
                One_string = sprintf('%d,', ADDS_ET_data.(folders(folder_n).name).(eventsToFind.Event_name{eventsToFind_n})(eventStarts_n,:)); % Write all the calculated variables to a comma seperated string
                
                fprintf(fid,'%s,%s%s,%s\n',...                             % Write data to file
                    folders(folder_n).name,...                             % Participant ID
                    event_labels,...                                       % Event labels
                    num2str(foundEvents{eventStarts(eventStarts_n),2}, '%20d'),... % Event start time
                    One_string(1:end-1)); 
            end
            
        end % eventsToFind_n
        
        fprintf('\nFinished %s\n\n', folders(folder_n).name)               % Finished message

        %clearvars('-except', vars);                                       % Clean up workspace
        
    end % folder_n
end
fclose(fid);                                                               % Close the data file
cd(orig_path)                                                              % Change back to the original file path
save(sprintf('ADDS_ET_data_%s',datestr(now,'dd_mm_yy',1)), 'ADDS_ET_data');% Save the ADDS_ET_data structure
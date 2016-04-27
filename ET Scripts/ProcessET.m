% New Script to analyse MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.9 - 27/04/16
% Dan Brady

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

folder_search_str = 'ADDS*';                                               % Set folder search string
file_search_str   = '*Buffer_T1.mat';                                      % Set file search string
marker_fname_t    = 'event_markers.txt';                                   % Set filename for event markers
analys_fname_t    = 'analysis_methods.txt';                                % Set filename for analysis methods
eventDlgStr_t     = 'Please select which events you want to look for:';    % Event list dialogue string
anlysDlgStr_t     = 'Please select which analyses you want to use:';       % Analysis list dialogue string
timeWinStr_t      = 'Please select the time window length in ms:';         % Time window input dialogue string
defaultTimeWin_t  = {'250'};                                               % Default time window (ms)
selectOp_t        = 'multiple';                                            % Default setting for list dialogue selection
oldFontSize_t     = get(0, 'DefaultUicontrolFontSize');                    % Get default font size for UI elements
varsToClear       = {'*_t', '*_n'};                                        % Variable to remove during tidying
[timeWindowWidth, timeWindows] = deal([]);

set(0, 'DefaultUicontrolFontSize', 14);                                    % Set UI font size to 14 for better readability
analysesToUse = func_read_options(analys_fname_t,anlysDlgStr_t,selectOp_t);% Allow user to select analyses to use
if find(ismember(analysesToUse.analysis, 'window'))                        % If the time window analysis was selected
    timeWindowWidth = inputdlg(timeWinStr_t,'Time window',1,defaultTimeWin_t);  % Allow user to select time window to be used
    if isempty(timeWindowWidth); error('Nothing selected'); end                 % If no time window entered throw error
    timeWindowWidth = str2double(timeWindowWidth{:});                                % Convert string entered to a number
    selectOp_t = 'single';                                                 % Restrict event selection if time window analysis selected                       
end
eventsToFind = func_read_options(marker_fname_t,eventDlgStr_t,selectOp_t); % Allow user to select events to find
set(0, 'DefaultUicontrolFontSize', oldFontSize_t);                         % Set UI fonts back to original size
if ~isempty(timeWindowWidth)
    timeWindows = 0:timeWindowWidth:eventsToFind.Event_length;
end

header_t = func_specify_header(analysesToUse, timeWindows);                   % Modify header based on analyses indicated

% ADDS_ET_data   = struct();                                                 % Prep main output variable

path  = uigetdir('','Select main data folder');                            % Ask participant to select main data folder
if path == 0; error('Path not selected'); end                              % Throw error if no path selected

output_fname_t = sprintf('ADDS_ET_output_%s.csv',datestr(now,'dd_mm_yy',1)); % Specify output filename
fid            = fopen(output_fname_t, 'w');                               % Create and open output data file
fprintf(fid, header_t);                                                    % Write header to data file
                                                           
cd(path)                                                                   % Change to main data folder
files_t = dir(folder_search_str);                                          % Get all the ADDS files available
folders = files_t([files_t.isdir]);                                        % Select only the directories
clearvars(varsToClear{:})                                                  % Tidy workspace

for folder_n = 1:size(folders,1)                                           % Loop through each participant
    commandwindow
    fprintf('\nStarting %s\n\n', folders(folder_n).name)                   % Starting message
    p_path_t = sprintf('%s/%s', path, folders(folder_n).name);             % Create path for participants folder
    %p_name_t = folders(folder_n).name;                                     % Create variable to store participant ID
    %ADDS_ET_data.(p_name_t) = struct();                                    % Create fieldname for the participant in output data variable
    cd(p_path_t)                                                           % Change to that path
    try
        dataFilePaths_t = subdir(file_search_str);                         % Try to generate paths for the ET data for that participant
    catch                                                                  % If there is an error
        %ADDS_ET_data.(folders(folder_n).name) = 'No Data';                 % Make a note of the lack of data
        fprintf('\nNo data found for %s\n\n', folders(folder_n).name)      % No data found message
        continue                                                           % Then skip to the next participant
    end
    
    for file_n = 1:size(dataFilePaths_t,1)                                 % Loop through the paths
        load(dataFilePaths_t(file_n).name)                                 % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
    end % file_n
    
    allData   = [double(timeBuffer) mainBuffer];                           % Concatenates timeBuffer and mainBuffer
    allEvents = cell(size(eventBuffer));                                   % Preallocate allEvents variable
    allEvents(:,1:2) = eventBuffer(:,1:2);                                 % Write the first two columns of eventBuffer to allEvents
    allEvents(:,3) = cellfun(@(x) x{1},eventBuffer(:,3),'Uni', false);     % Add the trigger label from eventBuffer to the last column of allData
    clear *Buffer                                                          % Clear loaded Buffer variables
    
    for eventsToFind_n = 1:size(eventsToFind,1)                            % For each of the specified markers
        VAP_t = strcmpi(eventsToFind.Marker_name{eventsToFind_n},'stimulus_start'); % Check to see if the task is VAP
        
        test_t = ~isempty(strfind(lower(eventsToFind.Marker_name{eventsToFind_n}),'test')); % Check to see if trial type is test
        
        foundInd = find(strncmpi(eventsToFind.Marker_name{eventsToFind_n},allEvents(:,3),length(eventsToFind.Marker_name{eventsToFind_n}))); % Find the specified markers in the allEvents variable
        
        if test_t; foundInd(2:2:end) = []; end;                            % If the trial type is test skip every other trial
        
        foundEvents = [allEvents(foundInd, 3:-1:2) cell(size(foundInd))... % Place matching events and times in variable, add blank third column
            allEvents(foundInd+1, 3:-1:2) cell(size(foundInd))];           % Also place next events (end trial markers) and times into variable, add another blanck column
        
        foundEvents(:,7) = cellfun(@(x) x+(eventsToFind.Event_length(eventsToFind_n)*1000),foundEvents(:,2), 'Uni', false); % Calculate actual time of stimulus display
        
        for foundEvent_col_n = [3 6 8]
            foundEvents(:,foundEvent_col_n) = cellfun(@(x) find(allData(:,1) >= x,1),foundEvents(:,foundEvent_col_n-1), 'Uni', false); % Find indicies for the foundEvent time points
        end % foundEvent_col_n
        
        if VAP_t; VAP_labels_t = func_VAP_labels(allEvents, foundInd); end % If task is VAP then generate trial labels
        
        for foundEvent_n = 1:size(foundEvents, 1)                          % For each event found
            if VAP_t                                                       % If the task is VAP then used the pre-generated labels
                eventLabels_t = sprintf('%s,', VAP_labels_t{foundEvent_n,:});
            else                                                           % Otherwise produce labels for each trial by task and type
                eventLabels_t = func_trial_labels(foundEvents{foundEvent_n,1},foundEvent_n, eventsToFind.Trials(eventsToFind_n));
            end
            
            evtStartMrk_t  = foundEvents{foundEvent_n,1};
            evtStartTime_t = num2str(foundEvents{foundEvent_n,2}, '%20d');
            validLastEv_t  = ~isempty(foundEvents{foundEvent_n,8});
            
            if validLastEv_t
                dispTime_t      = length(foundEvents{foundEvent_n,2}:allData(foundEvents{foundEvent_n,8},1))/1000;      % Calculate the number of ms stimulus was displayed for
                dispSamples_t    = length(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,8});                      % Calculate the number of samples the stimulus was displayed for
            else
                [dispTime_t, dispSamples_t] = deal(NaN);
            end

            dataToWrite_t = strjoin(cellfun(@num2str, [folders(folder_n).name, eventLabels_t, evtStartMrk_t, evtStartTime_t, dispTime_t, dispSamples_t], 'Uni', 0),',');
            
            for analysis_n = 1:size(analysesToUse,1)
                    switch analysesToUse.analysis{analysis_n}
                        case 'marker_info'
                            event_info_t = func_trig_info(foundEvents(foundEvent_n,:));    % Produce info about triggers
                            dataToWrite_t = strjoin([dataToWrite_t, event_info_t],',');
                        case 'quadrant'
                            if validLastEv_t                     % If the end trigger is not empty
                                quad_info_t = func_quadrantsLT(allData(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,8},:)); % Calculate the looking time per quadrant
                            else                                                           % If the end trigger is empty then label everything NaN
                                quad_info_t = repmat({'NaN'},1,5);
                            end
                            dataToWrite_t = strjoin([dataToWrite_t, quad_info_t],',');
                        case 'window'
                            eventTimeWindows = timeWindows.*1000 + double(foundEvents{foundEvent_n,2});
                            for window_n = 1:length(eventTimeWindows)-1
                                start_ind = find(allData(:,1) >= eventTimeWindows(window_n),1,'first');
                                end_ind   = find(allData(:,1) > 0 & allData(:,1) < eventTimeWindows(window_n+1),1,'last');
                                if validLastEv_t                                                  % If the end marker is not empty
                                    dispSamples_t = num2str(length(start_ind:end_ind));                 % Calculate the number of samples in the window
                                    quad_info_t   = func_quadrantsLT(allData(start_ind:end_ind,:)); % Calculate the looking time per quadrant
                                else                                                              % If the end trigger is empty then label everything NaN
                                    dispSamples_t = 'NaN';
                                    quad_info_t = repmat({'NaN'},1,6);
                                end
                                dataToWrite_t = strjoin([dataToWrite_t, dispSamples_t, quad_info_t],',');
                            end
                    end
            end
            
            dataToWrite_t = [dataToWrite_t '\n'];

%            One_string_t = sprintf('%d,', [dispTime_t dispSamples_t quad_info_t]);  % Write all the calculated variables to a comma seperated string
            
            fprintf(fid,dataToWrite_t);                                  % Write data to file
%                 folders(folder_n).name,...                                 % Participant ID
%                 eventLabels_t,...                                         % Event labels
%                 event_info_t,...                                           % Event trigger info
%                 One_string_t(1:end-1));                                    % All other info
        end % foundEvent_n
    end % eventsToFind_n
    fprintf('\nFinished %s\n\n', folders(folder_n).name)                   % Finished message
    clearvars(varsToClear{:}, '-except', 'folder_n')                       % Tidy workspace
end % folder_n

fclose(fid);                                                               % Close the data file
clearvars(varsToClear{:})                                                  % Tidy workspace
cd(orig_path)                                                              % Change back to the original file path
% save(sprintf('ADDS_ET_data_%s',datestr(now,'dd_mm_yy',1)), 'ADDS_ET_data');% Save the ADDS_ET_data structure
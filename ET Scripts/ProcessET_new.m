% New Script to analyse the new MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.90 - 03/07/16
% Dan Brady

orig_path = fileparts(mfilename('fullpath'));                              % Record folder the script was run from
addpath(orig_path)                                                         % Add that folder to path
cd(orig_path)                                                              % Change to that folder for creation of output file

folder_search_str = '900*';                                               % Set folder search string
file_search_str   = '*Buffer.mat';                                      % Set file search string
outputDir         = '/Volumes/ADDS/Dan/Exported ET (New)';                 % Set parent data export Directory
marker_fname_t    = 'event_markers_new.txt';                               % Set filename for event markers
analys_fname_t    = 'analysis_methods_new.txt';                                % Set filename for analysis methods
eventDlgStr_t     = 'Please select which events you want to look for:';    % Event list dialogue string
anlysDlgStr_t     = 'Please select which analyses you want to use:';       % Analysis list dialogue string
timeWinStr_t      = 'Please select the time window length in ms:';         % Time window input dialogue string
defaultTimeWin_t  = {'250'};                                               % Default time window (ms)
selectOp_t        = 'single';                                            % Default setting for list dialogue selection
oldFontSize_t     = get(0, 'DefaultUicontrolFontSize');                    % Get default font size for UI elements
varsToClear       = {'*_t', '*_n'};                                        % Variable to remove during tidying
[timeWindowWidth, timeWindows] = deal([]);

set(0, 'DefaultUicontrolFontSize', 14);                                    % Set UI font size to 14 for better readability
analysesToUse = func_read_options(analys_fname_t,anlysDlgStr_t,selectOp_t);% Allow user to select analyses to use

if any(ismember(analysesToUse.analysis, 'window'))                          % If the time window analysis was selected
    timeWindowWidth = inputdlg(timeWinStr_t,'Time window',1,defaultTimeWin_t);  % Allow user to select time window to be used
    if isempty(timeWindowWidth); error('Nothing selected'); end            % If no time window entered throw error
    timeWindowWidth = str2double(timeWindowWidth{:});                      % Convert string entered to a number
    %selectOp_t = 'single';                                                 % Restrict event selection if time window analysis selected    
end

eventsToFind = func_read_options(marker_fname_t,eventDlgStr_t,selectOp_t); % Allow user to select events to find
eventsToFind = strsplit(lower(eventsToFind.Name{:}), ' - ');    % Split the event type into consituent parts (ie. Object and Test, Location and Familiarization, etc)

set(0, 'DefaultUicontrolFontSize', oldFontSize_t);                         % Set UI fonts back to original size
if ~isempty(timeWindowWidth)                                               % Generate time windows if option is selected
    timeWindows = 0:timeWindowWidth:eventsToFind.Event_length;
end

path  = uigetdir('','Select main data folder');                            % Ask participant to select main data folder
if path == 0; error('Path not selected'); end                              % Throw error if no path selected

if ~all(strcmp(analysesToUse.analysis, 'export'))                          % If only export is specified then don't produce summaries
    header_t = func_specify_header_new(analysesToUse, timeWindows, eventsToFind{1}); % Modify header based on analyses indicated
    output_fname_t = sprintf('ADDS_ET_output_%s_%s.csv',eventsToFind{1}, datestr(now,'dd_mm_yy',1)); % Specify output filename
    fid            = fopen(output_fname_t, 'w');                           % Create and open output data file
    fprintf(fid, header_t);                                                % Write header to data file
end
                                                           
cd(path)                                                                   % Change to main data folder
files_t = dir(folder_search_str);                                          % Get all the ADDS files available
folders = files_t([files_t.isdir]);                                        % Select only the directories
clearvars(varsToClear{:})                                                  % Tidy workspace

for folder_n = 1:size(folders,1)                                           % Loop through each participant
    commandwindow
    fprintf('\nStarting %s\n\n', folders(folder_n).name)                   % Starting message
    p_path_t = fullfile(path, folders(folder_n).name);                     % Create path for participants folder
    p_name_t = folders(folder_n).name;                                     % Create variable to store participant ID
    cd(p_path_t)                                                           % Change to that path
    try
        dataFilePaths_t = subdir(file_search_str);                         % Try to generate paths for the ET data for that participant
    catch                                                                  % If there is an error
        fprintf('\nNo data found for %s\n\n', folders(folder_n).name)      % No data found message
        continue                                                           % Then skip to the next participant
    end
    
    for file_n = 1:size(dataFilePaths_t,1)                                 % Loop through the paths
        load(dataFilePaths_t(file_n).name)                                 % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
    end % file_n
    
    allData   = [double(timeBuffer) mainBuffer];                           % Concatenates timeBuffer and mainBuffer
    try
        allEvents(:,1:2) = eventBuffer(:,1:2);                             % Write the first two columns of eventBuffer to allEvents
    catch
        fprintf('\nNo events found for %s\n\n', folders(folder_n).name)    % No events found message
        continue
    end
    allEvents(:,3) = lower(eventBuffer(:,3));                              % Add the trigger label from eventBuffer to the last column of allData
    clear *Buffer                                                          % Clear loaded Buffer variables
    
    for eventsToFind_n = 1:size(eventsToFind,1)                            % For each of the specified markers
                
        foundInd = find(~cellfun('isempty', strfind(allEvents(:,3), eventsToFind{1}))...
                       &~cellfun('isempty', strfind(allEvents(:,3), eventsToFind{2}))); % Find the specified markers in the allEvents variable
                
        foundEvents = [allEvents(foundInd(1:2:end), 3:-1:2) cell(size(foundInd(1:2:end)))... % Place matching events and times in variable, add blank third column
                       allEvents(foundInd(2:2:end), 3:-1:2) cell(size(foundInd(2:2:end)))];  % Also place next events (end trial markers) and times into variable, add another blank column
        
        foundEvents(:,3) = cellfun(@(x) find(allData(:,1) >= x,1),foundEvents(:,2), 'Uni', false); % Find indicies for the stimulus & marker onset time points
        foundEvents(:,6) = cellfun(@(x) find(allData(:,1) > 0 & allData(:,1) < x,1,'last'),foundEvents(:,5), 'Uni', false); % Find indicies for the marker offset time points

        if any(ismember(analysesToUse.analysis, 'export'))                 % If export data option selected
            if ~isnan(str2double(p_name_t(1)))
                p_name_t = ['p' p_name_t];
            end
            s.(p_name_t) = [];                                             % Create struct to contain data 
            eventOutputDir_t = fullfile(outputDir, sprintf('%s - %s', eventsToFind{1}, eventsToFind{2})); % Generate directory path for saving data
            if ~exist(eventOutputDir_t, 'dir'); mkdir(eventOutputDir_t); end % If directory doesn't already exist then create it
        end
        
        for foundEvent_n = 1:size(foundEvents, 1)                          % For each event found
            
            trigger_info_t = strsplit(foundEvents{foundEvent_n,1},'_');
            eventLabels_t  = {trigger_info_t{1}(1:end-1), trigger_info_t{2}, trigger_info_t{1}(end), trigger_info_t{4}};
                                    
            evtStartMrk_t   = foundEvents{foundEvent_n,1};                  % Record the Event onset marker name
            evtStartTime_t  = num2str(foundEvents{foundEvent_n,2}, '%20d'); % Record the Event onset marker time
            dispTime_t      = length(foundEvents{foundEvent_n,2}:foundEvents{foundEvent_n,5})/1000;      % Calculate the number of ms stimulus was displayed for
            dispSamples_t   = length(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,6});                      % Calculate the number of samples the stimulus was displayed for
            
            dataToWrite_t = strjoin(cellfun(@num2str, [p_name_t, eventLabels_t, evtStartMrk_t, evtStartTime_t, dispTime_t, dispSamples_t], 'Uni', 0),','); % Write the above info to a string for later export to csv
            
            for analysis_n = 1:size(analysesToUse,1)                       % Loop through the number of analyses selected
                    switch analysesToUse.analysis{analysis_n}              % Check each analysis
                        case 'marker_info'                                 % If marker_info is selected then
                            continue
                        case 'section'                                     % If quadrant analysis is selected
                            sec_info_t = func_sectionsLT(allData(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,6},:), eventsToFind{1}); % Calculate the looking time per section
                            dataToWrite_t = strjoin([dataToWrite_t, sec_info_t],','); % Add this to the string for csv export
                        case 'window'                                      % If time window analysis is selected
                            eventTimeWindows = timeWindows.*1000 + double(foundEvents{foundEvent_n,2}); % Generate specific window times for that event
                            for window_n = 1:length(eventTimeWindows)-1    % For each window
                                start_ind = find(allData(:,1) >= eventTimeWindows(window_n),1,'first'); % Find the start time index
                                end_ind   = find(allData(:,1) > 0 & allData(:,1) < eventTimeWindows(window_n+1),1,'last'); % Find the end time index
                                dispSamples_t = num2str(length(start_ind:end_ind));           % Calculate the number of samples in the window
                                sec_info_t   = func_quadrantsLT(allData(start_ind:end_ind,:)); % Calculate the looking time per quadrant
                                dataToWrite_t = strjoin([dataToWrite_t, dispSamples_t, sec_info_t],','); % Add this data to the sting for csv export
                            end
                        case 'export'                                      % If the export option is selected
                            s.(p_name_t){foundEvent_n} = func_preprocessData(allData(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,6},:)); % Just place the data from event into data structure
                    
                    end
            end            
            if exist('fid', 'var'); fprintf(fid,[dataToWrite_t '\n']); end % Write data to csv file
        end % foundEvent_n
        if any(ismember(analysesToUse.analysis, 'export'))                 % If export option selected
            ouputFile_t = fullfile(eventOutputDir_t, p_name_t);    % Generate output path (including filename)
            save(ouputFile_t, '-struct', 's', p_name_t);                   % Save the individual participant data from the data structure
        end
    end % eventsToFind_n
    fprintf('\nFinished %s\n\n', folders(folder_n).name)                   % Finished message
    clearvars(varsToClear{:}, '-except', 'folder_n')                       % Tidy workspace
end % folder_n

if exist('fid', 'var'); fclose(fid); end                                   % Close the data file
clearvars(varsToClear{:})                                                  % Tidy workspace
cd(orig_path)                                                              % Change back to the original file path
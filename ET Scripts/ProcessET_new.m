% New Script to analyse the new MEM tasks for ET tasks on the LonDownS Alzheimer's Disease in Down syndrome Study.
% V0.95 - 25/08/16
% Dan Brady

main.origDir = fileparts(mfilename('fullpath'));                           % Record folder the script was run from
addpath(main.origDir)                                                      % Add that folder to path
cd(main.origDir)                                                           % Change to that folder for creation of output file

main.folder_search = '900*';                                               % Set folder search string
main.file_search   = '*Buffer.mat';                                        % Set file search string
main.outputDir    = '/Volumes/ADDS/Dan/Exported ET (New)';                 % Set parent data export Directory
temp.selectOp     = 'single';                                              % Default setting for list dialogue selection
temp.oldFontSize  = get(0, 'DefaultUicontrolFontSize');                    % Get default font size for UI elements
[main.timeWindowWidth, main.timeWindows] = deal([]);

set(0, 'DefaultUicontrolFontSize', 14);                                    % Set UI font size to 14 for better readability
main.analysesToUse = func_getOptions(ETAnalysis_constants.analysisOpt,ETAnalysis_constants.anlysDlgStr,temp.selectOp);% Allow user to select analyses to use

if any(ismember(main.analysesToUse.analysis, 'window'))                    % If the time window analysis was selected
    timeWindowWidth = inputdlg(ETAnalysis_constants.timeWinStr,'Time window',1,ETAnalysis_constants.defaultTimeWin);  % Allow user to select time window to be used
    if isempty(timeWindowWidth); error('Nothing selected'); end            % If no time window entered throw error
    timeWindowWidth = str2double(timeWindowWidth{:});                      % Convert string entered to a number
    %temp.selectOp = 'single';                                             % Restrict event selection if time window analysis selected
elseif any(ismember(main.analysesToUse.analysis, 'section'))
    main.plots = questdlg(ETAnalysis_constants.plotStr,ETAnalysis_constants.plotTitle);
    if strcmpi(main.plots, 'cancel'); error('Cancelled');
    else main.plots = strcmpi(main.plots, 'yes'); end
end

main.eventsToFind = func_getOptions(ETAnalysis_constants.eventMarkers,ETAnalysis_constants.eventDlgStr,temp.selectOp); % Allow user to select events to find
main.eventsToFind = strsplit(lower(main.eventsToFind.Name{:}), ' - ');     % Split the event type into consituent parts (ie. Object and Test, Location and Familiarization, etc)

set(0, 'DefaultUicontrolFontSize', temp.oldFontSize);                      % Set UI fonts back to original size
if ~isempty(main.timeWindowWidth)                                          % Generate time windows if option is selected
    timeWindows = 0:main.timeWindowWidth:main.eventsToFind.Event_length;
end

main.dataDir  = uigetdir('','Select main data folder');                    % Ask participant to select main data folder
if main.dataDir == 0; error('Path not selected'); end                      % Throw error if no path selected

if ~all(strcmp(main.analysesToUse.analysis, 'export'))                     % If only export is specified then don't produce summaries
    temp.header       = func_specify_header_new(main.analysesToUse, main.timeWindows, main.eventsToFind{1}); % Modify header based on analyses indicated
    temp.output_fname = sprintf('ADDS_ET_output_%s_%s.csv',main.eventsToFind{1}, datestr(now,'dd_mm_yy',1)); % Specify output filename
    fid               = fopen(temp.output_fname, 'w');                     % Create and open output data file
    fprintf(fid, temp.header);                                             % Write header to data file
end
                                                           
cd(main.dataDir)                                                           % Change to main data folder
temp.files = dir(main.folder_search);                                      % Get all the ADDS files available
main.folders = temp.files([temp.files.isdir]);                             % Select only the directories
temp = rmfield(temp, fieldnames(temp));                                    % Tidy workspace

for folder_n = 1:size(main.folders,1)                                      % Loop through each participant
    commandwindow
    fprintf('\nStarting %s\n\n', main.folders(folder_n).name)              % Starting message
    temp.p_path = fullfile(main.dataDir, main.folders(folder_n).name);     % Create path for participants folder
    temp.p_name = main.folders(folder_n).name;                             % Create variable to store participant ID
    cd(temp.p_path)                                                        % Change to that path
    try
        temp.dataFilePaths = subdir(main.file_search);                     % Try to generate paths for the ET data for that participant
    catch                                                                  % If there is an error
        fprintf('\nNo data found for %s\n\n', temp.p_name)                 % No data found message
        continue                                                           % Then skip to the next participant
    end
    
    for file_n = 1:size(temp.dataFilePaths,1)                                 % Loop through the paths
        load(temp.dataFilePaths(file_n).name)                                 % Load the .mat files: eventBuffer, mainBuffer & timeBuffer
    end % file_n
    
    temp.allData   = [double(timeBuffer) mainBuffer];                           % Concatenates timeBuffer and mainBuffer
    try
        temp.allEvents(:,1:2) = eventBuffer(:,1:2);                             % Write the first two columns of eventBuffer to allEvents
    catch
        fprintf('\nNo events found for %s\n\n', folders(folder_n).name)    % No events found message
        continue
    end
    temp.allEvents(:,3) = lower(eventBuffer(:,3));                              % Add the trigger label from eventBuffer to the last column of allData
    clear *Buffer                                                          % Clear loaded Buffer variables
    
    for eventsToFind_n = 1:size(main.eventsToFind,1)                            % For each of the specified markers
                
        found.Ind = find(~cellfun('isempty', strfind(temp.allEvents(:,3), main.eventsToFind{1}))...
                        &~cellfun('isempty', strfind(temp.allEvents(:,3), main.eventsToFind{2}))); % Find the specified markers in the allEvents variable
                
        found.Events = [temp.allEvents(found.Ind(1:2:end), 3:-1:2) cell(size(found.Ind(1:2:end)))... % Place matching events and times in variable, add blank third column
                        temp.allEvents(found.Ind(2:2:end), 3:-1:2) cell(size(found.Ind(2:2:end)))];  % Also place next events (end trial markers) and times into variable, add another blank column
        
        found.Events(:,3) = cellfun(@(x) find(temp.allData(:,1) >= x,1),found.Events(:,2), 'Uni', false); % Find indicies for the stimulus & marker onset time points
        found.Events(:,6) = cellfun(@(x) find(temp.allData(:,1) > 0 & temp.allData(:,1) < x,1,'last'),found.Events(:,5), 'Uni', false); % Find indicies for the marker offset time points

        if any(ismember(main.analysesToUse.analysis, 'export'))                 % If export data option selected
            if ~isnan(str2double(temp.p_name(1)))
                temp.p_name = ['p' temp.p_name];
            end
            temp.(temp.p_name) = [];                                             % Create struct to contain data 
            temp.eventOutputDir = fullfile(main.outputDir, sprintf('%s - %s', main.eventsToFind{1}, main.eventsToFind{2})); % Generate directory path for saving data
            if ~exist(temp.eventOutputDir, 'dir'); mkdir(temp.eventOutputDir); end % If directory doesn't already exist then create it
        end
        
        for foundEvent_n = 1:size(found.Events, 1)                          % For each event found
            
            temp.trigger_info = strsplit(found.Events{foundEvent_n,1},'_');
            temp.eventLabels  = {temp.trigger_info{1}(1:end-1), temp.trigger_info{2}, temp.trigger_info{1}(end), temp.trigger_info{4}};
            temp.stim.image   = ETAnalysis_constants.(main.eventsToFind{1}).stim.(main.eventsToFind{2})(foundEvent_n, :);
            temp.stim.loc     = ETAnalysis_constants.(main.eventsToFind{1}).stimPos.(main.eventsToFind{2})(foundEvent_n, :);

                                    
            temp.evtStartMrk   = found.Events{foundEvent_n,1};                  % Record the Event onset marker name
            temp.evtStartTime  = num2str(found.Events{foundEvent_n,2}, '%20d'); % Record the Event onset marker time
            temp.dispTime      = length(found.Events{foundEvent_n,2}:found.Events{foundEvent_n,5})/1000;      % Calculate the number of ms stimulus was displayed for
            temp.dispSamples   = length(found.Events{foundEvent_n,3}:found.Events{foundEvent_n,6});                      % Calculate the number of samples the stimulus was displayed for
            
            temp.dataToWrite = strjoin(cellfun(@num2str, [temp.p_name, temp.eventLabels, temp.evtStartMrk, temp.evtStartTime, temp.dispTime, temp.dispSamples], 'Uni', 0),','); % Write the above info to a string for later export to csv
            
            for analysis_n = 1:size(main.analysesToUse,1)                       % Loop through the number of analyses selected
                    switch main.analysesToUse.analysis{analysis_n}              % Check each analysis
                        case 'marker_info'                                 % If marker_info is selected then
                            continue
                        case 'section'                                     % If quadrant analysis is selected
                            [temp.sec_info, temp.figHandle] = func_sectionsLT_new(temp.allData(found.Events{foundEvent_n,3}:found.Events{foundEvent_n,6},:), main.eventsToFind, temp.stim, main.plots); % Calculate the looking time per section
                            if ~isempty(temp.figHandle); saveas(temp.figHandle, sprintf('%s - %s: trial %d', main.eventsToFind{1}, main.eventsToFind{2}, foundEvent_n), 'fig'); close(temp.figHandle); end
                            temp.dataToWrite = strjoin([temp.dataToWrite, temp.sec_info],','); % Add this to the string for csv export
                        case 'window'                                      % If time window analysis is selected
                            eventTimeWindows = timeWindows.*1000 + double(found.Events{foundEvent_n,2}); % Generate specific window times for that event
                            for window_n = 1:length(eventTimeWindows)-1    % For each window
                                temp.start_ind = find(temp.allData(:,1) >= eventTimeWindows(window_n),1,'first'); % Find the start time index
                                temp.end_ind   = find(temp.allData(:,1) > 0 & temp.allData(:,1) < eventTimeWindows(window_n+1),1,'last'); % Find the end time index
                                temp.dispSamples = num2str(length(temp.start_ind:temp.end_ind));           % Calculate the number of samples in the window
                                temp.sec_info   = func_quadrantsLT(temp.allData(temp.start_ind:temp.end_ind,:)); % Calculate the looking time per quadrant
                                temp.dataToWrite = strjoin([temp.dataToWrite, temp.dispSamples, temp.sec_info],','); % Add this data to the sting for csv export
                            end
                        case 'export'                                      % If the export option is selected
                            temp.(temp.p_name){foundEvent_n} = func_preprocessData(temp.allData(found.Events{foundEvent_n,3}:found.Events{foundEvent_n,6},:)); % Just place the data from event into data structure
                    
                    end
            end            
            if exist('fid', 'var'); fprintf(fid,[temp.dataToWrite '\n']); end % Write data to csv file
        end % foundEvent_n
        if any(ismember(main.analysesToUse.analysis, 'export'))            % If export option selected
            temp.outputFile = fullfile(temp.eventOutputDir, temp.p_name);  % Generate output path (including filename)
            save(temp.outputFile, '-struct', 'temp', temp.p_name);         % Save the individual participant data from the data structure
        end
    end % eventsToFind_n
    fprintf('\nFinished %s\n\n', main.folders(folder_n).name)              % Finished message
    temp = rmfield(temp, fieldnames(temp));                                % Tidy workspace
end % folder_n
if exist('fid', 'var'); fclose(fid); clear('fid'); end                     % Close the data file
clear temp *_n
cd(main.origDir)                                                           % Change back to the original file path
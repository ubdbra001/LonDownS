%% Script for using Sam's fixation parsing scripts with our LonDownS ET data
% V1.0 - 09/06/2016
% Dan Brady 

%% Will proabbly need to define some things here
orig_path       = fileparts(mfilename('fullpath'));                 % Record folder the script was run from
addpath(cd(cd('..')))                                               % Add parent path so script can find event_markers file
dataParDir      = '/Volumes/ADDS/Dan/Exported ET (new)';            % Dir for data in
% Dir for data out
taskSelectstr   = 'Which task would you like to process?';          % String for task selection box
dataSelectstr   = 'Which participants would you like to process?';  % Sring for participant selection box
displayPlotstr  = 'Would you like to display the output graphs?';   % String for output display selection
oldFontSize_t   = get(0, 'DefaultUicontrolFontSize');               % Get default font size for UI elements
marker_fname_t  = 'event_markers.txt';                              % Set filename for event markers


%% Fixation Parameters
fixParams = struct('SamplingFrequency', 120,...     % Sampling frequency in Hz
                   'VelocityThreshold', 35,...     % In deg/sec
                   'MinFix', 0.1,...               % Minimum fixation time in Secs
                   'MaxVariance', 30,...           % Maximum permissible variance within a fixation, in pixels per second - this is equivalent to 0.96 deg per sec
                   'DispSincePrevFixationThreshold', 0.0125,... % In subFixationFilter, rejects fixations if the distance between the previous fixation and this was below a threshold. Higher=more liberal.
                   'MaxBinDispThresh', 0.15,...    % If there is a substantial binocular disparity in either the sample that triggered the saccade or the two immediately before
                   'MaxToInterpolate', 0.15,...    % Maximum time to interpolate in secs
                   'ScreenResolution', [1360 768],... % Screen resolution of the data you are processing
                   'ScreenSize', [50.5 28.5],...   % Screen size of the data you are processing in cm
                   'DistFromScreen', 60,...        % Distance from the screen in cm
                   'SmoothPursuitThreshold', 0.04);% If euclid dis between start and end of fix is > 4% of screen - ie 1 deg of vis angle

fixParams.MovWinThreshold = fixParams.VelocityThreshold/3; % If the (up to) five samples immediately preceeding the saccade were above a threshold...
fixParams.AvgVelThreshold = fixParams.VelocityThreshold/3; % If the average velocity over the previous fixation was above a threshold...                   
fixParams.DegPerPix       = mean(radtodeg(2*atan(fixParams.ScreenSize./(2*fixParams.DistFromScreen)))./fixParams.ScreenResolution); % Mean degrees per pixel ~ 0.034 @1360x768 at 60cm
fixParams.MaxSamplesToInterpolate = fixParams.MaxToInterpolate/(1/fixParams.SamplingFrequency);

%% Select task and participants to analyse
addpath(orig_path)
events = readtable(marker_fname_t);
cd(dataParDir);
folders = dir();
folders = folders(~strncmpi('.', {folders.name}, 1));

set(0, 'DefaultUicontrolFontSize', 14);                                    % Set UI font size to 14 for better readability
[t_ind, ~] = listdlg('ListString', {folders.name}, 'SelectionMode', 'single', 'PromptString', taskSelectstr, 'ListSize', [400 300]);
dataAnalysisDir = sprintf('%s/%s', dataParDir, folders(t_ind).name);
[~, e_ind] = ismember(folders(t_ind).name, events.Name);
fixParams.TrialLength = 8; %events.Event_length(e_ind)/1000;

cd(dataAnalysisDir);

files = dir('*.mat');
[p_ind, ~] = listdlg('ListString', {files.name}, 'SelectionMode', 'multiple', 'PromptString', dataSelectstr, 'ListSize', [400 300]);

selectedParticipants = {files(p_ind).name};

button = questdlg(displayPlotstr, 'Display?');

switch button
    case{'Yes', 'No'}
        dispFlag = strcmp(button, 'Yes');
    case 'Cancel'
        error 'Script cancelled'
end

set(0, 'DefaultUicontrolFontSize', oldFontSize_t);                         % Set UI font size back to default

%% Start analysis loop

[dataLoad, data]  = deal(struct());

for participant_n = 1:numel(selectedParticipants) % Loop through each selected participant

    pName   = selectedParticipants{participant_n}(1:end-4); % Generate variable name 
    dataLoad  = load(selectedParticipants{participant_n});    % Load .mat data
    trials  = numel(dataLoad.(pName)); % Get the number of trials
    
    for trial_n = 1:trials % Start loop for each trial
        
        data.(pName){trial_n}.rough = dataLoad.(pName){trial_n};
        dataDetails = {pName, folders(t_ind).name, trial_n};
        
        %dataOut.(pName){trial_n}.rough  = func_dataResample(dataIn.(pName){trial_n}, fixParams); % Resample data so it is at 60Hz
        if ~isempty(data.(pName){trial_n}.rough)
            data.(pName){trial_n}.smooth = func_dataSmooth(data.(pName){trial_n}.rough);       % Run smoothing function on rough data
            % Run fixation filter on the data
            [data.(pName){trial_n}.smooth, data.(pName){trial_n}.fixList_init, data.(pName){trial_n}.fixList_clean] = func_fixationFilter(data.(pName){trial_n}.rough, data.(pName){trial_n}.smooth, fixParams);
            if dispFlag
                func_plotData(data.(pName){trial_n}, fixParams, dataDetails); % Display results in figure
                if ~exist(pName, 'dir')
                    mkdir(pName);
                end
                saveas(gcf, sprintf('%s/%s - %s trial %d.fig',pName, dataDetails{:}))
                waitfor(gcf); % Do not proceed until the figure is closed
            end
        end
    end

end



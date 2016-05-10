%% Script for using Sam's fixation parsing scripts with our LonDownS ET data
% V0.1 - 09/05/2016
% Dan Brady 

%% Will proabbly need to define some things here
orig_path       = fileparts(mfilename('fullpath'));                       % Record folder the script was run from
dataParDir      = '/Volumes/ADDS/Dan/Exported ET';                  % Dir for data in
% Dir for data out
taskSelectstr   = 'Which task would you like to process?';          % String for task selection box
dataSelectstr   = 'Which participants would you like to process?';  % Sring for participant selection box
oldFontSize_t   = get(0, 'DefaultUicontrolFontSize');               % Get default font size for UI elements


%% Fixation Parameters
fixParams = struct('SamplingFrequency', 60,...     % Sampling frequency in Hz
                   'VelocityThreshold', 35,...     % In deg/sec
                   'MinFix', 0.1,...               % Minimum fixation time in Secs
                   'MaxVariance', 30,...           % Maximum permissible variance within a fixation, in pixels per second - this is equivalent to 0.96 deg per sec
                   'DispSincePrevFixationThreshold', 0.0125,... % In subFixationFilter, rejects fixations if the distance between the previous fixation and this was below a threshold. Higher=more liberal.
                   'MaxBinDispThresh', 0.15,...    % If there is a substantial binocular disparity in either the sample that triggered the saccade or the two immediately before
                   'MaxToInterpolate', 0.15,...    % In secs
                   'ScreenResolution', [1360 768],... % Screen resolution of the data you are processing
                   'ScreenSize', [50.5 28.5],...   % Screen size of the data you are processing in cm
                   'DistFromScreen', 60,...        % Distance from the screen in cm
                   'SmoothPursuitThreshold', 0.04);% If euclid dis between start and end of fix is > 4% of screen - ie 1 deg of vis angle

fixParams.MovWinThreshold = fixParams.VelocityThreshold/3; % If the (up to) five samples immediately preceeding the saccade were above a threshold...
fixParams.AvgVelTreshold  = fixParams.VelocityThreshold/3; % If the average velocity over the previous fixation was above a threshold...                   
fixParams.DegPerPix       = mean(radtodeg(2*atan(fixParams.ScreenSize./(2*fixParams.DistFromScreen)))./fixParams.ScreenResolution); % Mean degrees per pixel ~ 0.034 @1360x768 at 60cm

%% Select task and participants to analyse
addpath(orig_path)
cd(dataParDir);
folders = dir();
folders = folders(~strncmpi('.', {folders.name}, 1));

set(0, 'DefaultUicontrolFontSize', 14);                                    % Set UI font size to 14 for better readability
[t_ind, ~] = listdlg('ListString', {folders.name}, 'SelectionMode', 'single', 'PromptString', taskSelectstr, 'ListSize', [400 300]);
dataAnalysisDir = sprintf('%s/%s', dataParDir, folders(t_ind).name);

cd(dataAnalysisDir);

files = dir('*.mat');
[p_ind, ~] = listdlg('ListString', {files.name}, 'SelectionMode', 'multiple', 'PromptString', dataSelectstr, 'ListSize', [400 300]);

selectedParticipants = {files(p_ind).name};

set(0, 'DefaultUicontrolFontSize', oldFontSize_t);                         % Set UI font size back to default

%% Start analysis loop

[dataIn, dataOut]  = deal(struct());

for participant_n = 1:numel(selectedParticipants) % Loop through each selected participant

    pName   = selectedParticipants{participant_n}(1:end-4); % Generate variable name 
    dataIn  = load(selectedParticipants{participant_n});    % Load .mat data
    clear dataIn
    
    trials  = numel(dataIn.(pName)); % Get the number of trials
    
    for trial_n = 1:trials % Start loop for each trial

        dataOut.(pName).rough = func_dataResample(dataIn.(pName){trial_n}, fixParams); % Resample data so it's at 60Hz

        % Run smoothing function on it
        % Save original data as 'rough' and smoothed data as 'smooth' (in a
        % structure?)
        
        % Run subFixationFilter (or rewritten version of it) on data
        
    end

end

% Display results? (Need to check what the script is doing after subFixationFilter)


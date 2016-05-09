%% Script for using Sam's fixation parsing scripts with our LonDownS ET data
% V0.1 - 09/05/2016
% Dan Brady 

%% Will proabbly need to define some things here
% Dir for data in
% Dir for data out
% Fixation Parameters

SamplingFrequency       = 60;                 % Sampling frequency in Hz
VelocityThreshold       = 35;                 % In deg/sec
MinFix                  = 0.1;                % Minimum fixation time in Secs
MaxVariance             = 30;                 % Maximum permissible variance within a fixation, in pixels per second - this is equivalent to 0.96 deg per sec
DispSincePrevFixationThreshold = 0.0125;      % In subFixationFilter, rejects fixations if the distance between the previous fixation and this was below a threshold. Higher=more liberal.
MaxBinDispThresh        = 0.15;               % If there is a substantial binocular disparity in either the sample that triggered the saccade or the two immediately before
MovWinThreshold         = VelocityThreshold/3;% If the (up to) five samples immediately preceeding the saccade were above a threshold...
AvgVelTreshold          = VelocityThreshold/3;% If the average velocity over the previous fixation was above a threshold...
MaxToInterpolate        = 0.15;               % In secs
SmoothPursuitThreshold  = 0.04;               % If euclid dis between start and end of fix is > 4% of screen - ie 1 deg of vis angle
ScreenResolution        = [1360 768];         % Screen resolution of the data you are processing
ScreenSize              = [50.5 28.5];        % Screen size of the data you are processing in cm
DistFromScreen          = 60;                 % Distance from the screen in cm   
DegPerPix               = mean(radtodeg(2*atan(ScreenSize./(2*DistFromScreen)))./ScreenResolution); % Mean degrees per pixel ~ 0.034 @1360x768 at 60cm



%% Select participants to use

% Start loop for each participant
% Load .mat data

% Start loop for each trial
% Resample data so it's at 60Hz

% Run smoothing function on it
% Save original data as 'rough' and smoothed data as 'smooth' (in a
% structure?)

% Run subFixationFilter (or rewritten version of it) on data

% Display results? (Need to check what the script is doing after subFixationFilter)


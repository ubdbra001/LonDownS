function smoothData = func_getRidofFakeSaccades(smoothData, roughData, fixParams)

% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]
% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag avgVelCrit movWinCrit binocDisparityCrit displacementCrit interpolatedThruSaccade]

smoothData(:,10:14) = NaN; % Add more columns to the smoothData (see above)

% Find all saccades
[saccadeStart,saccadeEnd] = func_findDataEdges(smoothData, 'saccade');

for saccade_n = 1:numel(saccadeStart)
    fixationStart = find(smoothData(1:saccadeStart(saccade_n)-1,6) == 0, 1, 'last')+1; % Work out how far back the previous fixation was
    
    %% Check if saccade was in a noisy patch (aveVelCrit)
    AvgVel = mean(smoothData(fixationStart:saccadeStart-1), 8);   % Work out the average velocity for the period between the fixation and the saccade
    smoothData(saccadeStart,10) = AvgVel>fixParams.AvgVelThreshold; % If the average velocity exceeds the threshold then set flag in column 10
    
    %% Check if saccade was in a noisy patch (movWinCrit)
    if saccadeStart - fixationStart > 5 % If there are more than 5 samples in the fixation 
        MovWin = mean(smoothData(saccadeStart-6:saccadeStart-1,8)); 
    elseif saccadeStart - fixationStart > 1 % If there is more than one sample in the fixation
        MovWin = mean(smoothData(fixationStart:saccadeStart-1,8));
    else
        MovWin = 0;
    end
    smoothData(saccadeStart,11) = MovWin>fixParams.MovWinThreshold; % If this falls above the MovWinThreshold then set flag in column 11
    
    
end
% Run through all samples in the trial (starting from the 6th sample?)
% If the current sample is marked as a saccade and the previous one was not
% Set the fake saccade flag to 0 and check the following:


% to 1 and not in column 10

%% Check if saccade was in a noisy patch (movWinCrit)
% If the number of samples in the fixation is greater than 6 then grab the
% velocity for the 5 samples before start of the saccade

% If the number of samples in the fixation is greater than 1 but less
% than 6 then grab the number of samples

% If there is only one sample in the fixation then set the value to 0

% Calculate the mean of the samples before the saccade


%% Check if there is a substantial dinocular disparity (binocDisparityCrit)
% For the sample at the start of the saccade, or the previous two samples
% Ensure the 3 sampes taken are above 0 (proper values) and if they are
% work out the difference between the on-screen position for the L and R
% eyes for the X axis
% If they are no set the difference to 0

% Do the same for the Y axis

% Find the Maximum and Minimum from each of these values

% If any falls above the MaxBinDispThresh (for max values) or below
% -MaxBinDispThresh (for min values) 
% Then set fakeSaccFlag to 1 and mark in column 12

%% Check if samples before saccade was interpolated (interpolatedThruSaccade)

% If any of the 4 samples before the saccade have an interpolation flag
% Then set fakeSaccFlag to 1 and mark in columm 14 of the following sample

%% If the fakeSaccFlag is set to 1
% Then work backwards to the start of the fixation and remove validFix
% flags if present

% It then does smothing else I'm not sure of...

% Then work forwards to the next saccade and remove validFix flags if
% present








function smoothData = func_getRidofFakeSaccades(smoothData, roughData, fixParams)

% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]
% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag avgVelCrit movWinCrit binocDisparityCrit displacementCrit interpolatedThruSaccade]

smoothData(:,10:14) = NaN; % Add more columns to the smoothData (see above)

% Find all saccades
[saccadeStart,saccadeEnd] = func_findDataEdges(smoothData, 'saccade');

for saccade_n = 1:numel(saccadeStart)
    fixationStart = find(smoothData(1:saccadeStart(saccade_n)-1,6) == 0, 1, 'last')+1; % Work out how far back the previous fixation was
    
    %% Check if saccade was in a noisy patch (aveVelCrit)
    AvgVel = mean(smoothData(fixationStart:saccadeStart(saccade_n)-1, 8));   % Work out the average velocity for the period between the fixation and the saccade
    smoothData(saccadeStart(saccade_n),10) = AvgVel>fixParams.AvgVelThreshold; % If the average velocity exceeds the threshold then set flag in column 10
    
    %% Check if saccade was in a noisy patch (movWinCrit)
    if saccadeStart(saccade_n) - fixationStart > 5 % If there are more than 5 samples in the fixation 
        MovWin = mean(smoothData(saccadeStart(saccade_n)-6:saccadeStart(saccade_n)-1,8)); % Calculate the average velocity for the 5 samples before the saccade 
    elseif saccadeStart(saccade_n) - fixationStart > 1 % If there are less than 6 samples but more than one sample in the fixation
        MovWin = mean(smoothData(fixationStart:saccadeStart(saccade_n)-1,8)); % Calculate the average velocity for the samples available
    else % If there is only one sample in the fixation then set the value to 0
        MovWin = 0;
    end
    smoothData(saccadeStart(saccade_n),11) = MovWin>fixParams.MovWinThreshold; % If this falls above the MovWinThreshold then set flag in column 11
    
    %% Check if there is a substantial dinocular disparity (binocDisparityCrit)
    % Get the rough data from sample at the start of the saccade and the previous two samples
    % and find the binocular disparity between the samples for the L and R eyes
    XYRoughDiff = [roughData(saccadeStart(saccade_n)-2:saccadeStart(saccade_n), 3) - roughData(saccadeStart(saccade_n)-2:saccadeStart(saccade_n), 5), roughData(saccadeStart(saccade_n)-2:saccadeStart(saccade_n), 4) - roughData(saccadeStart(saccade_n)-2:saccadeStart(saccade_n), 6)];
    % If any falls above the MaxBinDispThresh (for max values) or below -MaxBinDispThresh (for min values) mark in column 12
    smoothData(saccadeStart(saccade_n),12) = max(XYRoughDiff(:,1))>fixParams.MaxBinDispThresh || min(XYRoughDiff(:,1))<-fixParams.MaxBinDispThresh || max(XYRoughDiff(:,2))>fixParams.MaxBinDispThresh || min(XYRoughDiff(:,2))<-fixParams.MaxBinDispThresh;
        
    %% Check if samples before saccade was interpolated (interpolatedThruSaccade)
    smoothData(saccadeStart(saccade_n)+1,14) = all(smoothData(saccadeStart(saccade_n)-4:saccadeStart(saccade_n)-1, 9)==1); % If all of the 4 samples before the saccade have an interpolation flag then mark in columm 14 of the following sample
    
    %% If fake saccade detected
    if any([smoothData(saccadeStart(saccade_n),10:12), smoothData(saccadeStart(saccade_n)+1,14)])
        smoothData = func_getRidofFragments(smoothData, saccadeStart(saccade_n), saccadeEnd(saccade_n));
    end
        
end
% Run through all samples in the trial (starting from the 6th sample?)
% If the current sample is marked as a saccade and the previous one was not
% Set the fake saccade flag to 0 and check the following:


%% If the fakeSaccFlag is set to 1
% Then work backwards to the start of the fixation and remove validFix
% flags if present

% It then does smothing else I'm not sure of...

% Then work forwards to the next saccade and remove validFix flags if
% present








function smoothData = func_getRidofFragments(smoothData, fixParams)

% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

[startOfMissData, endOfMissData] = func_findMissData(smoothData);

for missData_n = 1:numel(startOfMissData)
    
end

% if there is a break in the data then go back and delete the rest of that fragmentary fixation.

% Run through all samples in trial
% If the current and previous sample are valid do nothing

% Otherwise:
% If at the end of a fragment (if last sample was classified as a fixation)
% Set DeleteGo flag to one
% Record position of loop

% If at the beginning of a fragment (the next sample is classed as a
% fixation)
% Set DeleteGo flag to one
% Record position of loop
% Set next sample to not be a fixation

% DeleteGo:
% If at end of a fixation then work backwards and delete fixation maker
% until a saccade or another break in the data is found

% If at the beginning of a fixation then work forward and do the same thing
% as above

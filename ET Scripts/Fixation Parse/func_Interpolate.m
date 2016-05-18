function smoothOut = func_Interpolate(smoothIn, fixParams)

% Smooth = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

fixParams.MaxSamplesToInterpolate = fixParams.MaxToInterpolate/(1/fixParams.SamplingFrequency);

% For each sample
% If the current sample is missing and the last sample was a fixation
% Starting at the previous sample, work backwards until a saccade is found recording the data for both X and Y axes
% Calculate the mean co-ordinate for that fixation (i.e fixation point)
% Calculate the mean euclidean distance of each point in that fixation from the central point

% Count the number of samples from the start of missing data until data is available
% If it is greater than the cut-off then skip interpolation

% Interpolation:
% 
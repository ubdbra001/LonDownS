function smoothOut = func_Interpolate(smoothIn, fixParams)

% Smooth = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

fixParams.MaxSamplesToInterpolate = fixParams.MaxToInterpolate/(1/fixParams.SamplingFrequency);

missingData     = diff(isnan([0; smoothIn(:,3); 0]));
startOfMissData = find(missingData == 1);
endOfMissData   = find(missingData == -1);

for missData_n = 1:numel(startOfMissData)
    if length(startOfMissData:endOfMissData) > fixParams.MaxSamplesToInterpolate
        continue
    end
    lastSaccade = find(smoothIn(1:startOfMissData(missData_n),5)==0,1,'last');
    if isempty(lastSaccade)
        continue
    end
    averageXY = round(mean(smoothIn(lastSaccade:startOfMissData(missData_n)-1,3:4)));
    
end

% For each sample
% If the current sample is missing and the last sample was a fixation
% Starting at the previous sample, work backwards until a saccade is found recording the data for both X and Y axes
% Calculate the mean co-ordinate for that fixation (i.e fixation point)
% Calculate the mean euclidean distance of each point in that fixation from the central point?

% Count the number of samples from the start of missing data until data is available
% If it is greater than the cut-off then skip interpolation

% Interpolation:
% Set the missing values to equal the average of the fixation
% Reset the ValidFixes10 to 1 for the replaed values
% Set the InterpolateFlag to 1 for the replaced values

% Rerun the fixation filter to find find potential fixations
% Ensure that this is calculated for the sample when the data returns to ID a saccade that starts on the next sample 
function smoothData = func_Interpolate(smoothData, fixParams)

% Smooth = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

[startOfMissData, endOfMissData] = func_findDataEdges(smoothData, 'missing');

for missData_n = 1:numel(startOfMissData) % For each of the missing data starting points
    previousSampleNotFixation = ~smoothData(startOfMissData(missData_n)-1,6); % Check that the previous sample was a fixation
    missingDataTooLong = length(startOfMissData(missData_n):endOfMissData(missData_n)) > fixParams.MaxSamplesToInterpolate; % Check that the missing section is shorter than the maximum allowed 

    if previousSampleNotFixation || missingDataTooLong % If the sample prior to the missing data section was not a fixation or the missing section is longer than allowed
        continue                                       % Skip interpolation
    end
    
    lastSaccade = find(smoothData(1:startOfMissData(missData_n)-1,5)==0,1,'last'); % Find the last saccade before the data dropped
    
    if isempty(lastSaccade) % If no last saccade is found then skip interpolation
        continue
    end

    averageXY = round(mean(smoothData(lastSaccade+1:startOfMissData(missData_n)-1,3:4),1)); % Calculate the mean co-ordinate for that fixation (i.e fixation point)  
    smoothData(startOfMissData(missData_n):endOfMissData(missData_n), 3:4)    = repmat(averageXY,numel(startOfMissData(missData_n):endOfMissData(missData_n)),1);     % Set the missing values to equal the average of the fixation
    smoothData(startOfMissData(missData_n):endOfMissData(missData_n), [5 9])  = ones(size(smoothData(startOfMissData(missData_n):endOfMissData(missData_n), [5 9]))); % Set the ValidFixes10 & InterpolateFlag to 1 for the replaced values
    
    if endOfMissData(missData_n) < size(smoothData, 1)
        smoothData(startOfMissData(missData_n)-1:endOfMissData(missData_n)+1,:) = func_findFixes(smoothData(startOfMissData(missData_n)-1:endOfMissData(missData_n)+1,:), fixParams);
    else
        smoothData(startOfMissData(missData_n)-1:endOfMissData(missData_n),:) = func_findFixes(smoothData(startOfMissData(missData_n)-1:endOfMissData(missData_n),:), fixParams);
    end
end

% Calculate the mean euclidean distance of each point in that fixation from the central point?

% Rerun the fixation filter to find find potential fixations
% Ensure that this is calculated for the sample when the data returns to ID a saccade that starts on the next sample 
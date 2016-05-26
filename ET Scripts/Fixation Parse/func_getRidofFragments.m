function smoothData = func_getRidofFragments(smoothData)

% If there is a break in the data then go back and 'unmark' the rest of that fragmentary fixation.
% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

[startOfMissData, endOfMissData] = func_findDataEdges(smoothData, 'missing'); % Find the beginning and end indices for any missing data

for missData_n = 1:numel(startOfMissData) % For each section of missing data
    startOfFixation = find(smoothData(1:startOfMissData(missData_n)-1,5) == 0, 1, 'last'); % Find the index of the last saccade preceding the missing data
    if endOfMissData(missData_n) < size(smoothData,1) % If the index of the end of the missing data is less than the total length of the trial
        endOfFixation = find(smoothData(endOfMissData(missData_n)+2:end,5) == 0, 1, 'first')+endOfMissData(missData_n); % Find the next saccade after the section of missing data
    else % If not
        endOfFixation = size(smoothData,1); % Set it to the final sample index 
    end
    smoothData(startOfFixation:endOfFixation, 5) = 0; % Set the fixation marker to 0 for all samples between the two points
end

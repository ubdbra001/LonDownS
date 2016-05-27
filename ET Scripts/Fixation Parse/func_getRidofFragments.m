function smoothData = func_getRidofFragments(smoothData, varargin)

% If there is a break in the data then go back and 'unmark' the rest of that fragmentary fixation.
% SmoothData = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]
if isempty(varargin)
    [startOfData, endOfData] = func_findDataEdges(smoothData, 'missing'); % Find the beginning and end indices for any missing data
else
    startOfData = varargin(1);
    endOfData   = varargin(2);
end

for missData_n = 1:numel(startOfData) % For each section of missing data
    startOfFixation = find(smoothData(1:startOfData(missData_n)-1,5) == 0, 1, 'last'); % Find the index of the last saccade preceding the missing data
    if endOfData(missData_n) < size(smoothData,1) % If the index of the end of the missing data is less than the total length of the trial
        endOfFixation = find(smoothData(endOfData(missData_n)+2:end,5) == 0, 1, 'first')+endOfData(missData_n); % Find the next saccade after the section of missing data
    else % If not
        endOfFixation = size(smoothData,1); % Set it to the final sample index 
    end
    smoothData(startOfFixation:endOfFixation, 5) = 0; % Set the fixation marker to 0 for all samples between the two points
end

function [startInd, endInd] = func_findMissData(data)

%% Small function to find the indices for portions of missing data

missingData     = diff(isnan([0;0; data(2:end,3); 0])); % Find the edges of the missing data
startInd        = find(missingData == 1);               % Find where the missing data portions start
endInd          = find(missingData == -1)-1;            % Find where the missing data portions end
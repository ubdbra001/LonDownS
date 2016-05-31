function [startInd, endInd] = func_findDataEdges(data, type)

%% Small function to find the edges of the data

switch type
    case 'missing'
        dataEdges = diff(isnan([0;0; data(2:end,3); 0])); % 
    case 'saccade'
        dataEdges = diff([0;0; data(2:end,7); 0]);
    case 'fixation'
        dataEdges = diff([0; data(:,5)]); % Find edges of fixations
end

endInd = find(dataEdges == -1)-1;            % Find where the missing data portions end

switch type
    case {'missing', 'saccade'}
        startInd = find(dataEdges == 1); % Find where the missing data portions start
    case 'fixation'
        startInd = find(dataEdges == 1); % Find the start point of the fixations with correction if the final fixation does have an end point
        if numel(startInd) ~= numel(endInd)
            startInd = startInd(1:numel(endInd));
        end
end

function tableOut = func_PCIobjectstats(dataIn, colNums)
% FUNC_PCIOBJECTSTATS function to identify unique objects from the PCI data and produce stats about them 

headers = {'Object','totalTime', 'meanTime', 'sdTime', 'transitions'}; % Headers for output table

objects = unique(dataIn{:,colNums}); % Find the unique objects in the data
objects(ismember(objects, '.')) = []; % Remove '.' object from list
objects = cell2table(objects, 'VariableNames', headers(1)); % Convert to a table
blkTable =  array2table(nan(height(objects),length(headers(2:end))), 'VariableNames', headers(2:end)); % Generate a blank table
tableOut = horzcat(objects, blkTable); % Prepare the output table

for object_n = 1:height(objects)
    
    temp   = diff([0; any(ismember(dataIn{:,colNums}, tableOut.Object(object_n)),2); 0]); % Find where the object appears in the data
    onset  = find(temp == 1);    % Find the onset indicies
    offset = find(temp == -1)-1; % Find the offset indicies
    
    tableOut.totalTime(object_n)     = sum(dataIn.time(offset) - dataIn.time(onset));           % Calculate the total time with the object in ms
    tableOut.meanTime(object_n)      = round(mean(dataIn.time(offset) - dataIn.time(onset)));   % Calculate the mean time with the object in ms
    tableOut.sdTime(object_n)        = std(dataIn.time(offset) - dataIn.time(onset));           % Calculate the SD time with the object in ms
    tableOut.transitions(object_n)   = length(onset);                                           % Calculate the number of times object picked up
end
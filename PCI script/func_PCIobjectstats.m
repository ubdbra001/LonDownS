function tableOut = func_PCIobjectstats(dataIn, colNums)
% FUNC_PCIOBJECTSTATS function to identify  

headers = {'Object','totalTime', 'meanTime', 'transitions'}; % Headers for output table

objects = cell2table(unique(dataIn{:,colNums}),'VariableNames', headers(1)); % Find the unique objects in the data
tableOut = horzcat(objects, array2table(nan(height(objects),length(headers(2:end))), 'VariableNames', headers(2:end))); % Prepare the output table
for object_n = 1:height(objects)
    temp   = diff([0; any(ismember(dataIn{:,colNums}, tableOut.Object(object_n)),2); 0]); % Find where the object appears in the data
    onset  = find(temp == 1); % Find the onset indicies
    offset = find(temp == -1)-1; % Find the offset indicies
    
    tableOut.totalTime(object_n)     = sum(dataIn.time(offset) - dataIn.time(onset)); % Calculate the total time with the object in ms
    tableOut.meanTime(object_n)      = round(mean(dataIn.time(offset) - dataIn.time(onset))); % Calculate the mean time with the object in ms
    tableOut.transitions(object_n)   = length(onset); % Calculate the number of times object picked up
end
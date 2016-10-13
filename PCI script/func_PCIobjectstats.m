function [tableOut, times] = func_PCIobjectstats(dataIn, colNums)
% FUNC_PCIOBJECTSTATS function to identify unique objects from the PCI data and produce stats about them 

headers = {'Object','totalTime', 'meanTime', 'sdTime', 'transitions', 'starts'}; % Headers for output table
times.allObj = [];

objects = unique(dataIn{:,colNums{1}}); % Find the unique objects in the data
objects(ismember(objects, {'.', ''})) = []; % Remove '.' and '' object from list
objects  = cell2table(objects, 'VariableNames', headers(1)); % Convert to a table
blkTable = array2table(nan(height(objects),length(headers(2:end))), 'VariableNames', headers(2:end)); % Generate a blank table
tableOut = horzcat(objects, blkTable); % Prepare the output table

% Percent of total time holding an object
times.Tot   = sum(func_calcTime(any(ismember(dataIn{:,colNums{1}}, objects{:,1}),2)))*33;

% Percent of total time holding multiple objects
times.Multi = sum(func_calcTime(sum(ismember(dataIn{:,colNums{1}}, objects{:,1}),2)>1))*33;

for object_n = 1:height(objects)
    
    [objTimes, onset, offset] = func_calcTime(any(ismember(dataIn{:,colNums{1}}, tableOut.Object(object_n)),2)); % Find where the object appears in the data
    times.allObj = [times.allObj; objTimes*33];
    
    objCount = 0;
    
    for n = 1:length(onset)
        % check for onset in other columns & make sure that object is
        % manipulated
        if ~any(ismember(dataIn{onset(n)-1,colNums{2}}, objects{object_n,1})) && any(ismember(dataIn{onset(n):offset(n),colNums{2}}(:), objects{object_n,1}))% Need to replace cols so that opposite are analysed...
            objCount = objCount + 1;
        end
    end
    
    tableOut.totalTime(object_n)     = sum(objTimes);           % Calculate the total time with the object in ms
    tableOut.meanTime(object_n)      = round(mean(objTimes));   % Calculate the mean time with the object in ms
    tableOut.sdTime(object_n)        = std(objTimes);           % Calculate the SD time with the object in ms
    tableOut.transitions(object_n)   = length(onset);           % Calculate the number of times object picked up
    tableOut.starts(object_n)        = objCount;
end
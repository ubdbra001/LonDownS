function tableOut = func_genColOutput(tableIn, dataIn, times, dataDetails)

variableNames = {'totalEachObjTime', 'meanObjTime', 'sdObjTime', 'numOfUniqueObjs', 'totalNumOfObjs', 'totalNumofStarts', 'totalObjTime', 'multiObjTime'};

idCols = cell2table(dataDetails, 'VariableNames', {'Participant_ID', 'Actor'});

statsTable = table(sum(dataIn.totalTime),...    Cumulative time with each object
                   mean(times.allObj),...       Mean time with each object
                   std(times.allObj),...        SD of time with each object
                   length(dataIn.Object),...    Number of unique object handled
                   sum(dataIn.transitions),...  Total number of objects handled
                   sum(dataIn.starts),...       Total number of transistions where actor started with object and other actor followed
                   times.Tot,...                Time spent with at least one object
                   times.Multi,...              Time spent handling multiple objects
                    'VariableNames', variableNames);

fullTable = horzcat(idCols,statsTable);

tableOut = vertcat(tableIn, fullTable);
function tableOut = func_genColOutput(tableIn, dataIn, allObjTimes, dataDetails)

variableNames = {'totalObjTime', 'meanObjTime', 'sdObjTime', 'numOfUniqueObjs', 'totalNumOfObjs'};

idCols = cell2table(dataDetails, 'VariableNames', {'Participant_ID', 'Actor'});

statsTable = table(sum(dataIn.totalTime), mean(allObjTimes), std(allObjTimes), length(dataIn.Object), sum(dataIn.transitions),...
                    'VariableNames', variableNames);

fullTable = horzcat(idCols,statsTable);

tableOut = vertcat(tableIn, fullTable);
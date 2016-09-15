function tableOut = func_genOutput(tableIn, dataIn, dataDetails)

idCols = repmat(cell2table(dataDetails, 'VariableNames', {'Participant_ID', 'Actor'}), height(dataIn),1);

fullTable = horzcat(idCols,dataIn);

tableOut = vertcat(tableIn, fullTable);
function dataOut = func_calcTime(dataIn, times)

temp = diff([0; dataIn; 0]);
onset = find(temp == 1);
offset = find(temp == -1)-1;

dataOut = sum(offset - onset);
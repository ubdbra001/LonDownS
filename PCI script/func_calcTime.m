function [dataOut, onset, offset] = func_calcTime(dataIn)

temp = diff([0; dataIn; 0]);
onset = find(temp == 1);
offset = find(temp == -1)-1;

dataOut = offset - onset;
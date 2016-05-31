function [smoothData, fixList_out] = func_fixationCorrect(smoothData, roughData, fixParams, fixList_in)

for fixation_n = 1:size(fixList_in,1)
    if fixList_in(fixation_n, 3) < fixParams.MinFix % read through FixesList and overwite any fixations that are below the minimum time threshold
        smoothData(fixList_in(fixation_n, 1):fixList_in(fixation_n, 2), 5) = 0;
    end
    
    % read through the Fixes List and overwite any fixations for which the avgx
    % and avgy of the present fixation are similar to those of the previous
    % fixation - because this means that the intervening saccade was probably a
    % false one
    
    if fixation_n > 1
        XYDiff  = fixList_in(fixation_n, 4:5) - fixList_in(fixation_n-1, 4:5);
        EuclidDis  = (sqrt((XYDiff(1))^2)+(XYDiff(2))^2)/2;
        if EuclidDis<fixParams.DispSincePrevFixationThreshold
            smoothData(fixList_in(fixation_n, 1):fixList_in(fixation_n, 2), 5) = 0;
            smoothData(fixList_in(fixation_n-1, 1):fixList_in(fixation_n-1, 2), 5) = 0;
            smoothData(fixList_in(fixation_n, 1)+1,13)=1;
        end      
    end
end

fixList_out = func_writeFixesList(smoothData, roughData, fixParams);       % Call writeFixesList function

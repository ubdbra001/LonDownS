function fixesList = func_writeFixesList(roughIn, smoothIn, fixParams)

% roughIn   = [time1 time2 XL YL XR YR]
% smoothIn  = [time1 time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

% FixesList = [FixStartIt FixEndIt FixDur FixAvgX FixAvgY FixAvgVar SmoothPursuit FixStartTime FixEndTime]

[fixationStart, fixationEnd] = func_findDataEdges(smoothIn, 'fixation');

fixesList = zeros(numel(fixationStart),9);            % Generate variable to store fixations

fixesList(:,1:2) = [fixationStart, fixationEnd];                                  % Note the sample numbers where the fixation samples started and ended
fixesList(:,3)   = (fixesList(:,2) - fixesList(:,1))/fixParams.SamplingFrequency; % Calculate the duration of the fixation
fixesList(:,8:9) = reshape(smoothIn(fixesList(:,1:2),2), size(fixesList(:,1:2))); % Not the times (relative to the start) when the fixation started and ended

for fix_n = 1:size(fixesList,1)

    [FixAvgX, XData] = quick_average(1); % Calculate mean X value for fixation
    [FixAvgY, YData] = quick_average(2); % Calculate mean Y value for fixation
    
    FixAvgVar = mean(sqrt((XData-FixAvgX).^2+(YData-FixAvgY).^2)/2); % Calculate mean variation around the mean fixation value produced in last 2 lines

    fixesList(fix_n, 4:6) = [FixAvgX FixAvgY FixAvgVar*1000]; % Write all to output varible 
    
    if fixesList(:,2) - fixesList(:,1) > 10                                                            % Ensure that the fixation is at least 10 samples long
        StartOfFix = mean(smoothIn(fixesList(:,1):fixesList(:,1)+5, 3:4))./fixParams.ScreenResolution; % Get the mean position for the first 5 samples of the fixation
        EndOfFix   = mean(smoothIn(fixesList(:,2)-5:fixesList(:,2), 3:4))./fixParams.ScreenResolution; % Get the mean position for the last 5 samples of the fixation
        FixTravel  = sqrt(((EndOfFix(1)-StartOfFix(1))^2)+((EndOfFix(2)-StartOfFix(2))^2))/2;          % Calculate the mean euclidian distance between the mean start and end positions
        if FixTravel>fixParams.SmoothPursuitThreshold                                                  % If this is greater than the SmoothPursuitThreshold then mark it as a smooth pursuit
            fixesList(fix_n,7)=1;
        end
    end
end % fix_n

%%
function [average, data] = quick_average(XorY)
    
    % Small nested function to generate X or Y data (with interpolated
    % substitutions if needed) and the means

    if XorY == 1; RCol = [3 5]; SCol = 3; % X axis = 1
    else RCol = [4 6]; SCol = 4; end      % Y axis = 2

    data = mean(roughIn(fixesList(fix_n,1):fixesList(fix_n,2)-1, RCol),2); % Put the rough data in the data variable
    ind = find(smoothIn(fixesList(fix_n,1):fixesList(fix_n,2)-1, 9)==1);   % Find any instances of interpolated data
    data(ind) = smoothIn(ind+fixesList(fix_n,1)-1, SCol)./fixParams.ScreenResolution(XorY); % Replace all missing values with interpolated smooth data
    
    average = mean(data);
end

end  
 

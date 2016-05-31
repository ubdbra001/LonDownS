function [smoothOut, fixesList_init, fixesList_clean] = func_fixationFilter(roughIn, smoothIn, fixParams)

% SmoothIn  = [Time1 Time2 X Y]
% SmoothOut = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

smoothIn(:,5:9) = NaN;                                          % Add additional columns for data
smoothIn(:,3:4) = [smoothIn(:,3).*fixParams.ScreenResolution(1), smoothIn(:,4).*fixParams.ScreenResolution(2)]; % Convert X and Y coordinated from screen proportions to pixels
smooth1        = func_findFixes(smoothIn, fixParams);                     % Find the fixations in the data
smooth2        = func_Interpolate(smooth1, fixParams);                   % Call interpolation function
fixesList_init  = func_writeFixesList(smooth2, roughIn, fixParams);       % Call writeFixesList function
smooth3        = func_getRidofFragments(smooth2);                        % Call getRidofFragments function to get rid of fragmentary fixations
smooth4        = func_getRidofFakeSaccades(smooth3, roughIn, fixParams); % Call GetRidofFakeSaccades function to get rid of any fixations around fake saccades
[smoothOut, fixesList_clean] = func_fixationCorrect(smooth4, roughIn, fixParams, fixesList_init);



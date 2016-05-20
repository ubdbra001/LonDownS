function [smoothOut, fixesList_init, fixesList_clean] = func_fixationFilter(roughIn, smoothIn, fixParams)

% SmoothIn  = [Time1 Time2 X Y]
% SmoothOut = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

smoothIn(:,5:9) = NaN;                                          % Add additional columns for data
smoothIn(:,3:4) = [smoothIn(:,3).*fixParams.ScreenResolution(1), smoothIn(:,4).*fixParams.ScreenResolution(2)]; % Convert X and Y coordinated from screen proportions to pixels
smoothIn        = func_findFixes(smoothIn, fixParams);              % Find the fixations in the data
smoothIn        = func_Interpolate(smoothIn, fixParams);            % Call interpolation function
fixesList_init  = func_writeFixesList(roughIn, smoothIn, fixParams);% Call WriteFixesList function
smoothIn        = func_getRidofFragments(smoothIn, roughIn, fixParams);
smoothIn        = func_getRidofFakeSaccades(smoothIn, roughIn, fixParams);



% Call GetRidofFragments function to get rid of fragmentary fixations
% Call GetRidofFakeSaccades function to get rid of any fixations around fake saccades


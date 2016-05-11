function dataOut = func_fixationFilter(roughIn, smoothIn, fixParams)

% SmoothIn  = [Time1 Time2 X Y]
% SmoothOut = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

smoothIn(:,5:9) = NaN; % Add additional columns for data

% Convert from proportions to pixels?


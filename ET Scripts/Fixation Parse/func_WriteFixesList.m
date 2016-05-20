function fixesList = func_writeFixesList(roughIn, smoothIn, fixParams)

% roughIn   = [time1 time2 XL YL XR YR]
% smoothIn  = [time1 time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]


% FixesList=[FixStartIt FixEndIt FixDur FixAvgX FixAvgY FixAvgVar SmoothPursuit FixStartTime FixEndTime]

% Starts by setting up a load of flags(?)

% Run through length of trial
% If there is a valid fix & it is not already processing a fixation
    % Add one to the found fixes counter
    % Record fixation start time point (They use column 1: absolute time,
    % may be worth using column 2: relative time)
    % Record sample fixation started at
    % Switch to processing fixation mode
% If in processing fixation mode & end of a fixation is reached
    % Record fixation end time point (see above)
    % Record sample fixation ended at
    % calculate the fixation duration
    
    % Calculate average fixation position
    % If data has been interpolated use the interpolated samples, otherwise
    % use the rough data
    % NB: This uses the proportion of the screen, so the smooth XY values
    % need to be converted back
    
% Caclulate the average variation for the fixation

% Work out if it is smooth pursuit
    % If the fixation is longer than 10 samples
    
 

function smoothOut = func_fixationFilter(roughIn, smoothIn, fixParams)

% SmoothIn  = [Time1 Time2 X Y]
% SmoothOut = [Time1 Time2 X Y ValidFixes10 BelowVeloc10 Saccs10 Vel InterpolatingFlag]

smoothIn(:,5:9) = NaN;                                          % Add additional columns for data
smoothIn(:,3:4) = round([smoothIn(:,3).*fixParams.ScreenResolution(1), smoothIn(:,4).*fixParams.ScreenResolution(2)]); % Convert X and Y coordinated from screen proportions to pixels
Amplitudes      = sqrt((diff(smoothIn(:,3)).^2 + diff(smoothIn(:,4)).^2)/2); % Calculate the Root Mean Squared (RMS) amplitudes for the sample points
                                                                             % RMS = sqrt(1/n*(X1^2 + X2^2 + ... + Xn^2)), where n = number of values and X = value (in this case n = 2, X1 = X and X2 = Y) 
Velocity        = (Amplitudes.*fixParams.DegPerPix)./(1/fixParams.SamplingFrequency); % calculate the velocity
smoothIn(2:end,8) = Velocity;                                              % Record velocity
smoothIn(:,5:6)   = repmat(smoothIn(:,8)<fixParams.VelocityThreshold,1,2); % If the velocity is below the velocity threshold then mark in BelowVeloc10 and ValidFixes10 column
                                                                           % The ValidFixes10 column will get overwritten by cleaner data later on
smoothIn(:,7)     = smoothIn(:,8)>fixParams.VelocityThreshold;             % If not then mark in the Saccs10 column
smoothIn          = func_Interpolate(smoothIn,FixParams);                  % Call interpolation function
fixesList         = func_WriteFixesList(roughIn, smoothIn, fixParams);     % Call WriteFixesList function


% Call GetRidofFragments function to get rid of fragmentary fixations
% Call GetRidofFakeSaccades function to get rid of any fixations around fake saccades


function data = func_findFixes(data, fixParams)

Amplitudes    = sqrt((diff(data(:,3)).^2 + diff(data(:,4)).^2)/2); % Calculate the Root Mean Squared (RMS) amplitudes for the sample points
                                                                   % RMS = sqrt(1/n*(X1^2 + X2^2 + ... + Xn^2)), where n = number of values and X = value (in this case n = 2, X1 = X and X2 = Y) 
Velocity      = (Amplitudes.*fixParams.DegPerPix)./(1/fixParams.SamplingFrequency); % calculate the velocity
data(2:end,8) = Velocity;                                          % Record velocity
data(:,5:6)   = repmat(data(:,8)<fixParams.VelocityThreshold,1,2); % If the velocity is below the velocity threshold then mark in BelowVeloc10 and ValidFixes10 column
                                                                   % The ValidFixes10 column will get overwritten by cleaner data later on
data(:,7)     = data(:,8)>fixParams.VelocityThreshold;             % Indicate if the data may be a saccade (velocity is above threshold)
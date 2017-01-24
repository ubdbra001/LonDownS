function EEG = func_continuousRej(EEG)

% This finds the bad sections of the continuous data...
[windRej, chanRej] = basicrap(EEG); % chanArray, ampth, windowms, stepms, firstdet, fcutoff, forder)

% chanArray   - channel index(ices) to look for c.r.a.p.
% - Use EEG.include?

% ampth       - 1 single value for peak-to-peak threshold within the moving window.
%               2 values for extreme thresholds within the moving window, e.g [-200 200] or [-150 220]
% - Need to work out (+- 100 uV?)

% windowms    - moving window width in msec (default 2000 ms)
% stepms      - moving window step in msec (default 1000 ms)
% - These can be worked out from infnat ERPs?

% firstdet    - 1 means move the moving-window after detecting the first artifactual channel (faster). 0 means scan all channel
%               then move the window (slower).
% - Not sure which to use here? Probably the latter...

% fcutoff     - 2 values for frequency cutoffs. empty means no filtering (default)
% forder      - 1 value indicating the order (number of points) of the FIR filter to be used. Default 26
% - Should already be filtered...


% Plot the data showing IDed bad sections

% Store the rejected sections before removal

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

colormatrej = repmat(colorseg, size(WinRej,1),1); % This looks like it generates the colours to indicate rejections

matrixrej = [WinRej colormatrej chanrej];

% WinRej      - Rejection limits in frames from beginning of data [start end]
% Colormatrej - Specifies marking colour [R G B]
% Chanrej     - Logical vector marking channels for rejection [ 1:nchans, 1
% = mark, 0 = not mark]

assignin('base', 'WinRej', WinRej) % Do I need this? Looks like it assigns a variable in base stack? Might be useful...

fprintf('\n %g segments were marked.\n\n', size(WinRej,1));

commrej = sprintf('%s = eeg_eegrej( %s, WinRej);', inputname(1), inputname(1));
% call figure
eegplot(EEG.data, 'winrej', matrixrej, 'srate', EEG.srate,'butlabel','REJECT','command', commrej,'events', EEG.event,'winlength', 50);
    
% Plot the data showing IDed bad sections

% Store the rejected sections before removal

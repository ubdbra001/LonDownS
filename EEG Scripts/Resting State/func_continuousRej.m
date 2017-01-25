function EEG = func_continuousRej(EEG)

%       Semi - automatic artifact rejection for eye movements, blinks, & movement artifacts
%           - Need exact criteria
%       Sliding window

params = RS_constants;

% This finds the bad sections of the continuous data...
[windRej, chanRej] = basicrap(EEG, EEG.includedChans, params.VEOGCutoff, params.ARwinLength,...
                              params.ARwinStep, params.firstDet, params.fCutoff, params.fOrder);

colormatRej = repmat(colorseg, size(windRej,1),1); % This looks like it generates the colours to indicate rejections

matrixRej = [windRej colormatRej chanRej]; % Combine the matricies produced

% WinRej      - Rejection limits in frames from beginning of data [start end]
% Colormatrej - Specifies marking colour [R G B]
% Chanrej     - Logical vector marking channels for rejection [ 1:nchans, 1
% = mark, 0 = not mark]

assignin('base', 'windRej', windRej) % Do I need this? Looks like it assigns a variable in base stack? Might be useful...

fprintf('\n %g segments were marked.\n\n', size(windRej,1)); % Output for user

commrej = sprintf('%s = eeg_eegrej( %s, windRej);', inputname(1), inputname(1)); % Generate command for rejecting sections

% Plot the data showing IDed bad sections
eegplot(EEG.data, 'winrej', matrixRej,...   % Show rejected portions
                  'srate', EEG.srate,...    % Set sample rate
                  'butlabel','REJECT',...   % Set button label
                  'command', commrej,...    % Set command on button push
                  'events', EEG.event,...   % Display events (needed?)
                  'winlength', 50);         % Set window length (s) - too long, shortern
              
              % May need to add: spacing?
uiwait(gcf)   % Wait for figure to close

% Store the rejected sections before removal - Put in command function
% above?

function EEG = func_continuousRej(EEG)

%       Semi - automatic artifact rejection for eye movements, blinks, & movement artifacts
%           - Need exact criteria
%       Sliding window

params = RS_constants;

% This finds the bad sections of the continuous data...
[windRej, chanRej] = basicrap(EEG, 1:EEG.nbchan, params.VEOGCutoff, params.ARwinLength,...
                              params.ARwinStep, params.firstDet, params.fCutoff, params.fOrder);

%% Identfy segments with artefacts in a less than a predefined number of channels (see RS_constants)

saveableSegments = sum(chanRej,2) < params.badChanProp;
                          
%% One Option is to just treat these segments as useable 

[windRej(saveableSegments,:), chanRej(saveableSegments,:)]= deal([]);

%% The alternamtive is to try to interpolate the data from the bad channels in each of these segments
% Will require building/adapting a function for the purpose
% May produce more discontinuities in the data affecting frequency?
% (Probably easiest to look at the differences between the options...)
% 
% % Loop through all bad segments
% for segment_n = 1:length(segments2Interp)
%     chans2Interp = find(chanRej(segments2Interp(1),:));
% end

%%
colormatRej = repmat(colorseg, size(windRej,1),1); % This looks like it generates the colours to indicate rejections

matrixRej = [windRej colormatRej chanRej]; % Combine the matricies produced

% WinRej      - Rejection limits in frames from beginning of data [number of segments by [start end]]
% Colormatrej - Specifies marking colour [R G B]
% Chanrej     - Logical vector marking channels for rejection [ number of segments by 1:nchans, 1
% = mark, 0 = not mark]

assignin('base', 'windRej', windRej) % Do I need this? Looks like it assigns a variable in base stack? Might be useful...

fprintf('\n %g segments were marked.\n\n', size(windRej,1)); % Output for user

commrej = sprintf('%s = eeg_eegrej( %s, windRej);', inputname(1), inputname(1)); % Generate command for rejecting sections

% Plot the data showing IDed bad sections
eegplot(EEG.data, 'winrej', matrixRej,...       % Show rejected portions
                  'srate', EEG.srate,...        % Set sample rate
                  'butlabel','REJECT',...       % Set button label
                  'command', commrej,...        % Set command on button push
                  'eloc_file', EEG.chanlocs,... % Display electrode names
                  'winlength', 5);              % Set window length (s) - too long, shortern
              
              % May need to add: spacing?
uiwait(gcf)   % Wait for figure to close

% Need to double check that the manual data selection propagates back to
% the windRej variable...

% Store the rejected sections before removal - Put in command function
% above?

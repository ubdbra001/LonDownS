function EEG = func_badChanID(EEG)

%% Save data from bad channels and then remove them from the dataset

EEG.removedChanData = EEG.data(EEG.removedChans,:);                 % Save the data from the removed channels

EEG = pop_select(EEG, 'nochannel', EEG.removedChans);               % Remove the channels from the dataset

%% Find channels that haven't recorded anything
EEG.deadChans     = EEG.includedChans(sum(diff(EEG.data(EEG.includedChans,:),1,2),2) == 0); 

% If channels found then iterpolate them
if ~isempty(EEG.deadChans);
    EEG = pop_interp(EEG, EEG.deadChans, 'spherical');
end

%% Temporary filter data to remove high frequency noise for easier identification of Bad Channels
EEG_t = pop_eegfiltnew(EEG, RS_constants.hiCutOff_bc, RS_constants.loCutOff_bc, [], 0, [], 0); % Bandpass filter (NB: Correct filter order?)

%% Find bad channels using the FASTER algorithm

EEG.chanStats     = channel_properties(EEG_t, 1:EEG.nbchan, []);  % Calculate channel stats using FASTER algorithm
EEG.badChans      = min_z(EEG.chanStats);           % Determine bad channels from the stats (currently using default settings: 3+ z-scores)

%% Is it worth plotting the identified channels? - May mean building additional interface to accept/reject channels selected

chanColours = repmat({[0.2 0.2 0.8]}, EEG.nbchan,1);
chanColours(EEG.badChans) = {[0.7 0 0]};

eegplot(EEG.data, 'color', chanColours, 'eloc_file', EEG.chanlocs)

% This will probably need some degree of checking...
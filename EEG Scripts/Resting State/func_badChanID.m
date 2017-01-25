function EEG = func_badChanID(EEG)

%EEG.deadChans = egiDeadChans(EEG);                                 % Find dead channels

% - Channels will not record anything, but will still have reference
% signal subtracted
% - However, the resulting raw signals should have perfect
% correlation...
% - We know eye-chans 125-128 not included so dead chans should
% have perfect correlation with them
% - Can test with Guilia's data

% temporary filter data to remove high frequency noise for easier ID of Bad
% Channels
EEG_t = pop_eegfiltnew(EEG, RS_constants.hiCutOff_bc, RS_constants.loCutOff_bc, 3300, 0, [], 0); % Bandpass filter (NB: Correct filter order?)


% Filters need to be applied before bad chan ID
% Could temporarily filter the data to ID the bad chans and then
% apply other filters downstream?

% Remove channels that haven't recorded anything
EEG.deadChans     = EEG.includedChans(sum(round(EEG_t.data(EEG.includedChans,:)),2) == 0);

EEG.includedChans = setdiff(EEG.includedChans, EEG.deadChans);

EEG.chanStats     = channel_properties(EEG_t, EEG.includedChans, []);  % Calculate channel stats using FASTER algorithm
EEG.badChans      = EEG.includedChans(min_z(EEG.chanStats));           % Determine bad channels from the stats (currently using default settings: 3+ z-scores)

chanColours = repmat({[0.2 0.2 0.8]}, EEG.nbchan,1);
chanColours(EEG.removedChans) = {[1 1 1]};
chanColours(EEG.badChans) = {[0.7 0 0]};

eegplot(EEG_t.data, 'color', chanColours)


% Show bad channels?
% This will probably need some degree of checking...
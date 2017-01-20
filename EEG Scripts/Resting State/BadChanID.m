function EEG = BadChanID(EEG)

params.hiCutOff = 30;
params.loCutOff = 0.1;

EEG.deadChans = egiDeadChans(EEG);                                 % Find dead channels

% - Channels will not record anything, but will still have reference
% signal subtracted
% - However, the resulting raw signals should have perfect
% correlation...
% - We know eye-chans 125-128 not included so dead chans should
% have perfect correlation with them
% - Can test with Guilia's data

% temporay filter data to remove high frequency noise for easier ID of Bad
% Channels
EEG_t = pop_eegfiltnew(EEG, params.hiCutOff, params.loCutOff, 3300, 0, [], 0); % Bandpass filter (NB: Correct filter order?)

% Filters need to be applied before bad chan ID
% Could temporarily filter the data to ID the bad chans and then
% apply other filters downstream?

EEG.chanStats = channel_properties(EEG_t, EEG.includedChans, []);  % Calculate channel stats using FASTER algorithm
EEG.badChans  = EEG.includedChans(min_z(EEG.chanStats));           % Determine bad channels from the stats (currently using default settings: 3+ z-scores)

% This will probably need some degree of checking...
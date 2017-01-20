function deadChanIDs = egiDeadChans(EEG, missChan)

% Function attempting to identify dead channels in an EGI recording
% Inputs: EEG - EEG structure
%         missChan - Known missing channel (eg 128)

% Outputs: deadChanIDs - Vector of chans ID-ed as dead

% Reasoning:

% - Reference signal is subtracted from all channels so dead channels will have 'signal' in the recording
% - However, the resulting raw 'signal' should be very simlar for all data and will have very high correlation...
% - No data recorded from Chans 125-128 so dead chans should have perfect correlation with them

% - Need to test with Guilia's data in order to estabish this...

corr = abs(corrcoef(EEG.data'));
deadChanIDs = find(round(corr(:,missChan),4)==1)';

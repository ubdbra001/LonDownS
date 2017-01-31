function data_out = func_anticipAG(data_in)

LXRX_LYRY = func_preprocessData(data_in);

eyeXY = [nanmean(LXRX_LYRY(:,3:4),2)'; nanmean(LXRX_LYRY(:,5:6),2)']';     % Calculate single coordinate for looking 

TotLook = sum(~isnan(eyeXY(:,1)) & ~isnan(eyeXY(:,2)));                    % Calculate the number of samples where the participant was looking at the screen

CentreX = eyeXY(:,1) > 0.353 & eyeXY(:,1) < 0.647;
CentreY = eyeXY(:,2) > 0.240 & eyeXY(:,2) < 0.760;

Centre = sum(CentreX & CentreY);

Samples = size(eyeXY,1);

data_out = cellfun(@num2str,{Samples TotLook Centre},'Uni',0); % Concatenate the measures into a single vector
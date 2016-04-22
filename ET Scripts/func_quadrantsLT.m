function data_out = func_quadrantsLT(data_in)

LXRX_LYRY = data_in(:,[9, 22, 10, 23]);                                    % Extract data for individual eyes from epoch

LXRX_LYRY(LXRX_LYRY<-0.05|LXRX_LYRY>1.05) = NaN;                           % Remove samples where participant was not looking at the screen

eyeXY = [nanmean(LXRX_LYRY(:,1:2),2)'; nanmean(LXRX_LYRY(:,3:4),2)']';     % Calculate single coordinate for looking 

TotLook = sum(~isnan(eyeXY(:,1)) & ~isnan(eyeXY(:,2)));                    % Calculate the number of samples where the participant was looking at the screen

TopL = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)<0.5);                               % Calculate the number of samples where the participant was looking at the top left of the screen
TopR = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)<0.5);                               % Calculate the number of samples where the participant was looking at the top right of the screen
BotL = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)>0.5);                               % Calculate the number of samples where the participant was looking at the bottom left of the screen
BotR = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)>0.5);                               % Calculate the number of samples where the participant was looking at the bottom right of the screen

data_out = [TotLook TopL TopR BotL BotR];                                  % Concatenate the measures into a single vector
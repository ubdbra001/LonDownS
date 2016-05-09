function data_out = func_quadrantsLT(data_in)

LXRX_LYRY = func_preprocessData(data_in);

eyeXY = [nanmean(LXRX_LYRY(:,2:3),2)'; nanmean(LXRX_LYRY(:,4:5),2)']';     % Calculate single coordinate for looking 

TotLook = sum(~isnan(eyeXY(:,1)) & ~isnan(eyeXY(:,2)));                    % Calculate the number of samples where the participant was looking at the screen

TopL = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)<0.5);                               % Calculate the number of samples where the participant was looking at the top left of the screen
TopR = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)<0.5);                               % Calculate the number of samples where the participant was looking at the top right of the screen
BotL = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)>0.5);                               % Calculate the number of samples where the participant was looking at the bottom left of the screen
BotR = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)>0.5);                               % Calculate the number of samples where the participant was looking at the bottom right of the screen

data_out = cellfun(@num2str,{TotLook TopL TopR BotL BotR},'Uni',0); % Concatenate the measures into a single vector
function data_out = func_sectionsLT(data_in, event)

LXRX_LYRY = func_preprocessData(data_in);

eyeXY = [nanmean(LXRX_LYRY(:,3:4),2)'; nanmean(LXRX_LYRY(:,5:6),2)']';     % Calculate single coordinate for looking 

TotLook = sum(~isnan(eyeXY(:,1)) & ~isnan(eyeXY(:,2)));                    % Calculate the number of samples where the participant was looking at the screen

AoIs = ETAnalysis_constants.(event).AoIs;

switch event
    case 'location'                                                        % Calculate the number of samples where the participant was looking at:
        output{1} = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)<0.5);                  % The top left of the screen
        output{2} = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)<0.5);                  % The top right of the screen
        output{3} = sum(eyeXY(:,1)<0.5 & eyeXY(:,2)>0.5);                  % The bottom left of the screen
        output{4} = sum(eyeXY(:,1)>0.5 & eyeXY(:,2)>0.5);                  % The bottom right of the screen
        
    case 'object'
        for AoI_n = 1:numel(AoIs)
            output{AoI_n} = sum(inpolygon(eyeXY(:,1), eyeXY(:,2), AoIs(AoI_n).x, AoIs(AoI_n).y));
        end
end
        
data_out = cellfun(@num2str,[TotLook output],'Uni',0); % Concatenate the measures into a single vector
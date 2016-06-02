n = 4;
y = [1 1 1.05 1.05]';

% Plot X and Y data
h = axes;
plot(h,dataOut.ADDS_010{n}.smooth(:,2),dataOut.ADDS_010{n}.smooth(:,3)./fixParams.ScreenResolution(1),dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,4)./fixParams.ScreenResolution(2));

% Prep fixation list highlighting 
clear fixes_s
fixes_s.FaceColor = 'red';
fixes_s.FaceAlpha = 0.8;
fixes_s.EdgeColor = 'none';
fixes_s.Vertices = [];

% Generate coordinates for each of the fixtions
for fix_n = 1:size(dataOut.ADDS_010{n}.fixList_init,1)
    x = [dataOut.ADDS_010{n}.fixList_init(fix_n, 8:9), dataOut.ADDS_010{n}.fixList_init(fix_n, 9:-1:8)]';
    fixes_s.Vertices = [fixes_s.Vertices; x y];
end 

fixes_s.Faces = reshape(1:length(fixes_s.Vertices), 4, length(fixes_s.Vertices)/4)';

patch(fixes_s)
ylim([0 max(y)]); % set Y limits
set(h, 'ytick', [])
h.YRuler.Axle.Visible = 'off'
set(h, 'box', 'off')
set(h, 'xgrid', 'on')
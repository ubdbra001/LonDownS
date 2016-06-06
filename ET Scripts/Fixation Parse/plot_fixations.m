n = 4;

%% Draw the axes for each element
el_list = {'rough', 1:3;
           'smooth', 4:6;
           'fixes', 7;
           'flags', 8;
           'velocity', 9:11};

max_el = max([el_list{:,2}]);

for element_n = 1:size(el_list,1)
    ETplot.(el_list{element_n,1}) = subplot(max_el,1,el_list{element_n,2}); 
end


%% Plot Rough
plot(ETplot.rough, dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,3),'or',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,4),'ob',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,5),'xr',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,5),'xb')
       
%legend(h(1), {'X Coordinates - Left Eye', 'Y Coordinates - Left Eye', 'X Coordinates - Right Eye', 'Y Coordinates - Right Eye'}, 'location', 'NorthEastOutside');
       
ETplot.rough.XTick = round(min(dataOut.ADDS_010{n}.rough(:,2)),1):0.5:round(max(dataOut.ADDS_010{n}.rough(:,2)),1);
ETplot.rough.XLim  = [round(min(dataOut.ADDS_010{n}.rough(:,2)),1) round(max(dataOut.ADDS_010{n}.rough(:,2)),1)];
ETplot.rough.YLim  = [0 1];
ETplot.rough.XAxisLocation = 'top';
ETplot.rough.Box = 'off';
ETplot.rough.XGrid = 'on';
ETplot.rough.YRuler.Visible = 'off';



%% Plot Smooth
plot(ETplot.smooth, dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,3)./fixParams.ScreenResolution(1), 'r',...
                    dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,4)./fixParams.ScreenResolution(2), 'b');
       
%legend(h(2), {'X Coordinates', 'Y Coordinates'}, 'location', 'NorthEastOutside');
       
ETplot.smooth.XTick = round(min(dataOut.ADDS_010{n}.smooth(:,2)),1):0.5:round(max(dataOut.ADDS_010{n}.smooth(:,2)),1);
ETplot.smooth.XLim  = [round(min(dataOut.ADDS_010{n}.smooth(:,2)),1) round(max(dataOut.ADDS_010{n}.smooth(:,2)),1)];
ETplot.smooth.YLim  = [0 1];
[ETplot.smooth.YRuler.Visible, ETplot.smooth.XRuler.Visible] = deal('off');
ETplot.smooth.Box = 'off';
ETplot.smooth.XGrid = 'on';

%% Prep fixation list highlighting 
clear fixes_s
fixes_s.FaceColor = 'red';
fixes_s.FaceAlpha = 0.8;
fixes_s.EdgeColor = 'none';
fixes_s.Vertices = [];

y = [1 1 2 2]';

% Generate coordinates for each of the fixtions
for fix_n = 1:size(dataOut.ADDS_010{n}.fixList_init,1)
    x = [dataOut.ADDS_010{n}.fixList_init(fix_n, 8:9), dataOut.ADDS_010{n}.fixList_init(fix_n, 9:-1:8)]';
    fixes_s.Vertices = [fixes_s.Vertices; x y];
end 
fixes_s.Faces = reshape(1:length(fixes_s.Vertices), 4, length(fixes_s.Vertices)/4)';

%% Draw fixation list
axes(ETplot.fixes)
patch(fixes_s)
ETplot.fixes.YLim = [0 2]; % set Y limits
ETplot.fixes.XLim = ETplot.rough.XLim;
ETplot.fixes.XTick = ETplot.rough.XTick;
ETplot.fixes.XGrid = 'on';
[ETplot.fixes.YRuler.Visible, ETplot.fixes.XRuler.Visible] = deal('off');

%% Draw the various flags
axes(ETplot.fixes)
ETplot.flags.XLim = ETplot.rough.XLim;
ETplot.flags.XTick = ETplot.rough.XTick;
ETplot.flags.XGrid = 'on';
[ETplot.flags.YRuler.Visible, ETplot.flags.XRuler.Visible] = deal('off');


%% Draw the velocity graph

axes(ETplot.velocity)

plot(ETplot.velocity, dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,8));
       
ETplot.velocity.XLim = ETplot.rough.XLim;
ETplot.velocity.XTick = ETplot.rough.XTick;
ETplot.velocity.Box = 'off';
ETplot.velocity.XGrid = 'on';
ETplot.velocity.YRuler.Visible = 'off';
ETplot.velocity.YDir = 'reverse';
ETplot.velocity.YLim = [0 200];

line(ETplot.velocity.XLim, [35 35],'LineStyle', '--', 'Color', 'k');

n = 4;
flag_colors = {'red', 'green', 'blue', 'yellow', 'cyan' };


%% Draw the axes for each element
el_list = {'rough', 1:3;
           'smooth', 4:6;
           'fixes', 7;
           'flags', 8:9;
           'velocity', 10:12};

max_el = max([el_list{:,2}]);

for element_n = 1:size(el_list,1)
    ETplot.(el_list{element_n,1}) = subplot(max_el,1,el_list{element_n,2}); 
end


%% Make function to create & customise each element of the plot?

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
fix_names = fieldnames(dataOut.ADDS_010{n});
fix_names = fix_names(strncmp(fix_names, 'fix', 3));
axes(ETplot.fixes)

for fix_list_n = 1:numel(fix_names)
    
    %clear fixes_s
    fixes_s(fix_list_n).FaceColor = flag_colors{fix_list_n};
    fixes_s(fix_list_n).FaceAlpha = 0.8;
    fixes_s(fix_list_n).EdgeColor = 'none';
    fixes_s(fix_list_n).Vertices = [];
    
    y = [fix_list_n-1 fix_list_n-1 fix_list_n fix_list_n]';
    % Generate coordinates for each of the fixtions
    for fix_n = 1:size(dataOut.ADDS_010{n}.(fix_names{fix_list_n}),1)
        x = [dataOut.ADDS_010{n}.(fix_names{fix_list_n})(fix_n, 8:9), dataOut.ADDS_010{n}.(fix_names{fix_list_n})(fix_n, 9:-1:8)]';
        fixes_s(fix_list_n).Vertices = [fixes_s(fix_list_n).Vertices; x y];
    end
    fixes_s(fix_list_n).Faces = reshape(1:length(fixes_s(fix_list_n).Vertices), 4, length(fixes_s(fix_list_n).Vertices)/4)';
    
    %% Draw fixation list
    patch(fixes_s(fix_list_n))
end


ETplot.fixes.YLim = [0 2]; % set Y limits
ETplot.fixes.XLim = ETplot.rough.XLim;
ETplot.fixes.XTick = ETplot.rough.XTick;
ETplot.fixes.XGrid = 'on';
ETplot.fixes.YDir = 'reverse';
[ETplot.fixes.YRuler.Visible, ETplot.fixes.XRuler.Visible] = deal('off');

%% Draw the various flags
axes(ETplot.flags)
flag_cols = 10:14;

for flag_n = 1:numel(flag_cols)
    [flag_times, x] = deal ([]);
    flag_times = dataOut.ADDS_010{n}.smooth(dataOut.ADDS_010{n}.smooth(:,flag_cols(flag_n))==1,2);
    flag_times = [flag_times, flag_times+0.2];
    flag_s(flag_n).FaceColor = flag_colors{flag_n};
    flag_s(flag_n).FaceAlpha = 0.8;
    flag_s(flag_n).EdgeColor = 'none';
    flag_s(flag_n).Vertices = [];
    
    y = [flag_n-1 flag_n-1 flag_n flag_n]';
    for flag_time_n = 1:size(flag_times,1)
        x = [flag_times(flag_time_n,1:2) flag_times(flag_time_n,2:-1:1)]';
        flag_s(flag_n).Vertices = [flag_s(flag_n).Vertices; x y];
    end
    flag_s(flag_n).Faces = reshape(1:length(flag_s(flag_n).Vertices), 4, length(flag_s(flag_n).Vertices)/4)';
    
    patch(flag_s(flag_n))
end
ETplot.flags.YLim = [0 5];
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

line(ETplot.velocity.XLim, [35 35],'LineStyle', ':', 'Color', 'k');

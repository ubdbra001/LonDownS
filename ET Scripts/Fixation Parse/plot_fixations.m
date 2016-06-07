n = 4;

p = get(0,'MonitorPositions');
set(0, 'DefaultFigurePosition', p(1,:))

flag_colors = {'red', 'green', 'blue', 'magenta', 'cyan' };

legend_labels = {{'X Coordinates - Left Eye', 'Y Coordinates - Left Eye', 'X Coordinates - Right Eye', 'Y Coordinates - Right Eye'};
                 {'X Coordinates', 'Y Coordinates'}};
             
%              {'Tentative fixations', 'Saved fixations'}
%              {'Avg Vel during previous fixation', 'Vel Immediately pre-saccade', 'Binocular disparity pre-saccade', 'Displacement from previous fixation', 'Interpolated through saccade'}
legend_defaults = {'Box', 'off',...
                   'FontSize', 11};

plot_defaults = {'Box', 'off',...
                 'XGrid', 'on',...
                 'XTick', round(min(dataOut.ADDS_010{n}.smooth(:,2)),1):0.5:round(max(dataOut.ADDS_010{n}.smooth(:,2)),1),...
                 'XLim', [round(min(dataOut.ADDS_010{n}.smooth(:,2)),1) round(max(dataOut.ADDS_010{n}.smooth(:,2)),1)],...
                 'FontSize', 12,...
                 'TickLength', [0.005 0]};
             
patch_defaults = struct('FaceAlpha', 0.8, 'EdgeColor', 'none', 'Vertices', []);
             
%% Draw the axes for each element
el_list = {'rough',    'Rough\ndata', [0.04 0.72 0.8 0.20];
           'smooth',   'Smooth\ndata',[0.04 0.50 0.8 0.20];
           'fixes',    'Fixations',   [0.04 0.43 0.8 0.05];
           'flags',    'Flags',       [0.04 0.32 0.8 0.09];
           'velocity', 'Velocity',    [0.04 0.10 0.8 0.20]};
       
legend_pos = el_list{1,3}(1) + el_list{1,3}(3);

for element_n = 1:size(el_list,1)
    ETplot.(el_list{element_n,1}) = subplot('position', el_list{element_n,3});
end
set(gcf, 'ToolBar', 'none', 'MenuBar', 'none');


%% Plot Rough
plot(ETplot.rough, dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,3),'or',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,4),'ob',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,5),'xr',...
                   dataOut.ADDS_010{n}.rough(:,2), dataOut.ADDS_010{n}.rough(:,5),'xb')
 
%axes(ETplot.rough);t = text('String', sprintf(el_list{1,2}), 'Units', 'normalized', 'Position', [0 0.5], 'FontWeight', 'bold', 'HorizontalAlignment', 'right', 'FontSize', 12);

%text(ETplot.rough,'String', el_list{1,2}, 'Units', 'normalized', 'Position', [1 0])

set(ETplot.rough, plot_defaults{:},...
    'YLim', [0 1],...
    'XAxisLocation', 'top')
     
ETplot.rough.YRuler.Visible = 'off';

%% Plot Smooth
plot(ETplot.smooth, dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,3)./fixParams.ScreenResolution(1), 'r',...
                    dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,4)./fixParams.ScreenResolution(2), 'b');

set(ETplot.smooth, plot_defaults{:},...
    'YLim', [0 1]);
               
[ETplot.smooth.YRuler.Visible, ETplot.smooth.XRuler.Visible] = deal('off');
       
%% Prep fixation list highlighting
fix_names = fieldnames(dataOut.ADDS_010{n});
fix_names = fix_names(strncmp(fix_names, 'fix', 3));
axes(ETplot.fixes)

for fix_list_n = 1:numel(fix_names)
    
    %clear fixes_s
    fixes_s(fix_list_n) = patch_defaults;
    fixes_s(fix_list_n).FaceColor = flag_colors{fix_list_n};
    
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

set(ETplot.fixes, plot_defaults{:},...
    'YLim', [0 2],...
    'YDir', 'reverse')

[ETplot.fixes.YRuler.Visible, ETplot.fixes.XRuler.Visible] = deal('off');

%% Draw the various flags
axes(ETplot.flags)
flag_cols = 10:14;

for flag_n = 1:numel(flag_cols)
    [flag_times, x] = deal ([]);
    flag_times = dataOut.ADDS_010{n}.smooth(dataOut.ADDS_010{n}.smooth(:,flag_cols(flag_n))==1,2);
    flag_times = [flag_times, flag_times+0.1];
    flag_s(flag_n) = patch_defaults;
    flag_s(flag_n).FaceColor = flag_colors{flag_n};
    
    y = [flag_n-1 flag_n-1 flag_n flag_n]';
    for flag_time_n = 1:size(flag_times,1)
        x = [flag_times(flag_time_n,1:2) flag_times(flag_time_n,2:-1:1)]';
        flag_s(flag_n).Vertices = [flag_s(flag_n).Vertices; x y];
    end
    flag_s(flag_n).Faces = reshape(1:length(flag_s(flag_n).Vertices), 4, length(flag_s(flag_n).Vertices)/4)';
    
    patch(flag_s(flag_n))
end

set(ETplot.flags, plot_defaults{:},...
    'YLim',[0 5],...
    'YDir', 'reverse');

[ETplot.flags.YRuler.Visible, ETplot.flags.XRuler.Visible] = deal('off');

% for leg_ent_n = 1:numel(flag_cols)
%     icons(leg_ent_n).Color = icons(leg_ent_n+numel(flag_cols)).FaceColor;
%     icons(leg_ent_n+size(flag_cols,1)).Visible = 'off';
% end


%% Draw the velocity graph

axes(ETplot.velocity)

plot(ETplot.velocity, dataOut.ADDS_010{n}.smooth(:,2), dataOut.ADDS_010{n}.smooth(:,8));

set(ETplot.velocity, plot_defaults{:},...
    'YLim', [0 200],...
    'YDir', 'reverse');
ETplot.velocity.YRuler.Visible = 'off';
line(ETplot.velocity.XLim, [35 35],'LineStyle', ':', 'Color', 'k');

%% Add the legends

plot_names = fieldnames(ETplot);

for plot_n = 1:numel(legend_labels)
    ETlegend.(plot_names{plot_n}) = legend(ETplot.(plot_names{plot_n}), legend_labels{plot_n});
    set(ETlegend.(plot_names{plot_n}), legend_defaults{:});
    ETlegend.(plot_names{plot_n}).Position(1) = legend_pos;
end

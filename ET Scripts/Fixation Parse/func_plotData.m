function func_plotData(Data,fixParams, dataName)

%% Prep various parameters for plotting

p = get(0,'MonitorPositions');
set(0, 'DefaultFigurePosition', p(1,:))

params = struct();

params.colors = lines(5);

params.labels = struct('rough', {{'X Coordinates - Left Eye', 'Y Coordinates - Left Eye', 'X Coordinates - Right Eye', 'Y Coordinates - Right Eye'}},...
                       'smooth', {{'X Coordinates', 'Y Coordinates'}},...
                       'fixation',{{'Tentative fixations', 'Saved fixations'}},...
                       'flags', {{'Avg Vel during previous fixation', 'Vel Immediately pre-saccade', 'Binocular disparity pre-saccade', 'Displacement from previous fixation', 'Interpolated through saccade'}});

params.legend = {'Box', 'off',...
                 'FontSize', 11};

params.plot = {'Box', 'off',...
               'XGrid', 'on',...
               'XTick', round(min(Data.smooth(:,2)),1):0.5:round(max(Data.smooth(:,2)),1),...
               'XLim', [round(min(Data.smooth(:,2)),1) round(max(Data.smooth(:,2)),1)],...
               'FontSize', 12,...
               'TickLength', [0.005 0]};
             
params.patch = {'FaceColor', [], 'FaceAlpha', 0.8, 'EdgeColor', 'none', 'Vertices', [], 'Faces', []};

params.text = {'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'right'};

params.ScreenResolution = fixParams.ScreenResolution;
             
elementList = {'rough',    [0.06 0.69 0.8 0.20], {-0.05,0.90,sprintf('Rough\ndata')};
               'smooth',   [0.06 0.47 0.8 0.20], {-0.05,0.90,sprintf('Smooth\ndata')};
               'fixation', [0.06 0.42 0.8 0.04], {-0.05,0.5,'Fixations'};
               'flags',    [0.06 0.31 0.8 0.10], {-0.05,0.5,'Flags'};
               'velocity', [0.06 0.10 0.8 0.20], {-0.05,8,'Velocity'}};
       
params.legend_pos = elementList{1,2}(1) + elementList{1,2}(3);

%% Create each axes on a subplot and then draw each element on that axis

for element_n = 1:size(elementList,1)
    ETplot.(elementList{element_n,1}) = subplot('position', elementList{element_n,2});
    ETplot.(elementList{element_n,1}) = func_plotElements(ETplot.(elementList{element_n,1}), elementList(element_n,:), Data, params);
end
set(gcf, 'ToolBar', 'none', 'MenuBar', 'none');

title(ETplot.rough,sprintf('%s\n%s trial %d',dataName{:}),'Position', [round(max(Data.smooth(:,2)),1)/2 1.25 0], 'FontSize', 16, 'Interpreter','none')

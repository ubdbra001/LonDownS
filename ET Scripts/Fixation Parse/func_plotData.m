function plotHandle = func_plotData(plotHandle, elementInfo, Data, params)

switch elementInfo{1}
    case 'rough'
        plot(plotHandle, Data.rough(:,2), Data.rough(:,3),'or',...
            Data.rough(:,2), Data.rough(:,4),'ob',...
            Data.rough(:,2), Data.rough(:,5),'xr',...
            Data.rough(:,2), Data.rough(:,5),'xb')
        
        %axes(ETplot.rough);t = text('String', sprintf(el_list{1,2}), 'Units', 'normalized', 'Position', [0 0.5], 'FontWeight', 'bold', 'HorizontalAlignment', 'right', 'FontSize', 12);
        
        %text(ETplot.rough,'String', el_list{1,2}, 'Units', 'normalized', 'Position', [1 0])
        
        set(plotHandle, params.plot{:},...
            'YLim', [0 1],...
            'XAxisLocation', 'top')
        
        plotHandle.YRuler.Visible = 'off';
        
        addLegends
        
    case 'smooth'
        plot(plotHandle, Data.smooth(:,2), Data.smooth(:,3)./params.ScreenResolution(1), 'r',...
                         Data.smooth(:,2), Data.smooth(:,4)./params.ScreenResolution(2), 'b');
        
        set(plotHandle, params.plot{:},...
            'YLim', [0 1]);
        
        [plotHandle.YRuler.Visible, plotHandle.XRuler.Visible] = deal('off');
        addLegends
        
    case 'fixation'
        
        fix_names = fieldnames(Data);
        fix_names = fix_names(strncmp(fix_names, 'fix', 3));
        axes(plotHandle)
        
        for fix_list_n = 1:numel(fix_names)
            
            %clear fixes_s
            fixes_s(fix_list_n) = struct(params.patch{:});
            fixes_s(fix_list_n).FaceColor = params.colors{fix_list_n};
            
            y = [fix_list_n-1 fix_list_n-1 fix_list_n fix_list_n]';
            % Generate coordinates for each of the fixtions
            for fix_n = 1:size(Data.(fix_names{fix_list_n}),1)
                x = [Data.(fix_names{fix_list_n})(fix_n, 8:9), Data.(fix_names{fix_list_n})(fix_n, 9:-1:8)]';
                fixes_s(fix_list_n).Vertices = [fixes_s(fix_list_n).Vertices; x y];
            end
            fixes_s(fix_list_n).Faces = reshape(1:length(fixes_s(fix_list_n).Vertices), 4, length(fixes_s(fix_list_n).Vertices)/4)';
            
            %% Draw fixation list
            patch(fixes_s(fix_list_n))
            text(9.52, mean([fix_list_n-1 fix_list_n]), params.labels.(elementInfo{1}){fix_list_n}, 'Color', params.colors{fix_list_n}, 'Parent', plotHandle)
        end
        
        set(plotHandle, params.plot{:},...
            'YLim', [0 2],...
            'YDir', 'reverse')
        
        [plotHandle.YRuler.Visible, plotHandle.XRuler.Visible] = deal('off');
        
        addLabels
        
    case 'flags'
        
        axes(plotHandle)
        flag_cols = 10:14;
        
        for flag_n = 1:numel(flag_cols)
            [flag_times, x] = deal ([]);
            flag_times = Data.smooth(Data.smooth(:,flag_cols(flag_n))==1,2);
            flag_times = [flag_times, flag_times+0.1];
            flag_s(flag_n) = struct(params.patch{:});
            flag_s(flag_n).FaceColor = params.colors{flag_n};
            
            y = [flag_n-1 flag_n-1 flag_n flag_n]';
            for flag_time_n = 1:size(flag_times,1)
                x = [flag_times(flag_time_n,1:2) flag_times(flag_time_n,2:-1:1)]';
                flag_s(flag_n).Vertices = [flag_s(flag_n).Vertices; x y];
            end
            flag_s(flag_n).Faces = reshape(1:length(flag_s(flag_n).Vertices), 4, length(flag_s(flag_n).Vertices)/4)';
            
            patch(flag_s(flag_n))
            text(9.52, mean([flag_n-1 flag_n]), params.labels.(elementInfo{1}){flag_n}, 'Color', params.colors{flag_n}, 'Parent', plotHandle)
        end
        
        set(plotHandle, params.plot{:},...
            'YLim',[0 5],...
            'YDir', 'reverse');
        
        [plotHandle.YRuler.Visible, plotHandle.XRuler.Visible] = deal('off');
        
        addLabels
        
    case 'velocity'
        
        plot(plotHandle, Data.smooth(:,2), Data.smooth(:,8));
        
        set(plotHandle, params.plot{:},...
            'YLim', [0 200],...
            'YDir', 'reverse');
        plotHandle.YRuler.Visible = 'off';
        line(plotHandle.XLim, [35 35],'LineStyle', ':', 'Color', 'k');
        
end


ETlabel.(elementInfo{1}) = text(elementInfo{3}{:}, params.text{:}, 'Parent', plotHandle);


    function addLegends
        
        ETlegend.(elementInfo{1}) = legend(plotHandle, params.labels.(elementInfo{1}));
        set(ETlegend.(elementInfo{1}), params.legend{:});
        ETlegend.(elementInfo{1}).Position(1) = params.legend_pos;
    end

    function addLabels
        
    end

end



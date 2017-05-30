function headerOut = func_specify_header_new(analyses, windows, event)

headerOut = {'Participant,Task_type,Trial_Type,Order,Trial_number,Start_marker_name,Start_marker_time,Trial_length_(ms),Samples_in_trial'};
eventHeader = {'End_marker,Time_between_Markers_(ms),Samples_between_markers'};
quadHeader_opt = {'Samples_in_window' 'Total_looking' 'Top_Left' 'Top_Right' 'Bottom_Left' 'Bottom_Right'};
secHeader_opt  =  {'Samples_in_window' 'Total_looking' 'Top_Left' 'Bottom' 'Top_Right'};


for analysis_n = 1:size(analyses,1)
    switch analyses.analysis{analysis_n}
        case 'marker_info'
            headerOut = strjoin([headerOut eventHeader], ',');
        case 'section'
            switch event
                case {'location', 'obj_change', 'pos_change'}
                    secHeader = strjoin(quadHeader_opt(2:end),',');
                case 'object'
                    secHeader = strjoin(secHeader_opt(2:end),',');
            end
            headerOut = strjoin([headerOut {secHeader}], ',');
        case 'window'
            for window_n = 1:length(windows)-1
                windowTimes     = repmat({sprintf('%d-%d', windows(window_n), windows(window_n+1))}, size(quadHeader_opt));
                timeWinHeader   = sprintf(sprintf(repmat('%s_%%s,', size(quadHeader_opt)), windowTimes{:}), quadHeader_opt{:});
                headerOut       = strjoin([headerOut {timeWinHeader(1:end-1)}], ',');
            end
    end
end

headerOut = [headerOut '\n'];
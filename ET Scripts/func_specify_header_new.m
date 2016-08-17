function headerOut = func_specify_header_new(analyses, windows, event)

headerOut = {'Participant,Task type,Trial Type,Order,Trial number,Start marker name,Start marker time,Trial length (ms),Samples in trial'};
eventHeader = {'End marker,Time between Markers (ms),Samples between markers'};
quadHeader_opt = {'Samples in window' 'Total looking' 'Top Left' 'Top Right' 'Bottom Left' 'Bottom Right'};
secHeader_opt  =  {'Samples in window' 'Total looking' 'Top Left' 'Bottom' 'Top Right'};


for analysis_n = 1:size(analyses,1)
    switch analyses.analysis{analysis_n}
        case 'marker_info'
            headerOut = strjoin([headerOut eventHeader], ',');
        case 'section'
            switch event
                case 'location'
                    secHeader = strjoin(quadHeader_opt(2:end),',');
                case 'object'
                    secHeader = strjoin(secHeader_opt(2:end),',');
            end
            headerOut = strjoin([headerOut {secHeader}], ',');
        case 'window'
            for window_n = 1:length(windows)-1
                windowTimes     = repmat({sprintf('%d-%d', windows(window_n), windows(window_n+1))}, size(quadHeader_opt));
                timeWinHeader   = sprintf(sprintf(repmat('%s - %%s,', size(quadHeader_opt)), windowTimes{:}), quadHeader_opt{:});
                headerOut       = strjoin([headerOut {timeWinHeader(1:end-1)}], ',');
            end
    end
end

headerOut = [headerOut '\n'];
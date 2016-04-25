function trigs_out = func_trig_info(eventsIn)

info{1} = num2str(eventsIn{1,2}, '%20d');
info{2} = eventsIn{1,1};
info{3} = eventsIn{1,4};
info{4} = num2str(length(eventsIn{1,2}:eventsIn{1,5})/1000); % Calculate the time between the start and end triggers (ms)
info{5} = num2str(length(eventsIn{1,3}:eventsIn{1,6}));      % Calculate the number of samples in the epoch

trigs_out = sprintf('%s,', info{:});
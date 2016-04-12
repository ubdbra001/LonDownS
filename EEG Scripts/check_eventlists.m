fnames=fieldnames(events);

event_ns = [108, 135, 189, 216];

lines = [1, 28, 109];

a = fnames(n_events==189);

for n = 1:length(a);
    varname = sprintf('events.%s', a(n));
    
    
end
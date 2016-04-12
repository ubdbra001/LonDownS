path        = '/Volumes/ADDS/Dan/Exported EEG';
outputVar   = 'events';
cd(path)

files = dir('*.txt');
eval(sprintf('%s = struct();', outputVar))
n_events = [];

for id = 1:length(files)
    name = files(id).name(1:end-4);
    
    if isnan(str2double(files(id).name(1)))
        varname = sprintf('events.%s', strtok(name));
    else
        varname = sprintf('events.ADDS%s', strtok(name));
    end
    
    eval(sprintf('%s = importfile(files(id).name);', varname))
    
    eval(sprintf('n_events(id) = length(%s);', varname))
    
end

%save('events.mat', 'events');
 
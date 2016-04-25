%% Function to label trials by task and type

function labels = func_trial_labels(event, event_n, expected_n_trials)

trial_tasks = {'context', 'Context';...     % Define the different tasks
               'obj', 'Object change';...
               'pos', 'Position change'};
           
trial_type  = {'Familiarization';...        % Define the different trial types
               'Test'};

label{1} = type(event, trial_tasks);                 % Work out task type from event marker 
label{2} = type(event, trial_type);                  % Work out trial type from event marker
label{3} = floor((event_n-1)/expected_n_trials)+1;   % Calculate Block number from event_n
label{4} = event_n-((label{3}-1)*expected_n_trials); % Calculate Trial number from event_n

label = cellfun(@num2str, label, 'UniformOutput', false); % Convert all to strings

labels = sprintf('%s,', label{:});                  % Concatenate label into single, comma seperated string

end


%%
function label_out = type(event, label_options)

% Function to work out event label (task or type) from event marker
% 
label_out = [];
for n = 1:size(label_options,1)                               % Loop through all potential labels
    if ~isempty(strfind(lower(event), lower(label_options{n,1})))    % If a label matches the input
        label_out = label_options{n,size(label_options,2)};   % That is the label
    end
end

if isempty(label_out)   % If no match found label as unknown
    label_out = 'Unknown';
end

end


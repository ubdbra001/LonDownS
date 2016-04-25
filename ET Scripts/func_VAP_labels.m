%% Initial ideas for dividing and labelling VAP task trials

function labels_out = func_VAP_labels(allEvents, stim_ind)   

movie_event = 'play_movie';

movie_ind = [1; find(strncmpi(allEvents(:,3), movie_event, length(movie_event))); size(allEvents(:,3),1)];
block = cell(length(movie_ind)-1,1);
labels_out = [];

for block_n = 1:size(block,1)
    block{block_n} = stim_ind(stim_ind>movie_ind(block_n)&stim_ind<movie_ind(block_n+1));
    out_temp = cell(length(block{block_n}),4);
    out_temp(:,1) = {'VAP'};
    out_temp(:,3) = {block_n};
    if length(block{block_n}) == 10
        out_temp(1:8,2)     = {'Familiarization'};
        out_temp(9:10,2)    = {'Test'};
        out_temp(1:8,4)     = num2cell(1:8);
        out_temp(9:10,4)    = num2cell(1:2);
    elseif length(block{block_n}) == 2
        out_temp(:,2)       = {'Test'};
        out_temp(:,4)       = num2cell(1:2);
    else
        out_temp(:,2)       = {'Unknown'};
        out_temp(:,3:4)     = {NaN};
    end
    labels_out = [labels_out; out_temp];
    clear out_temp
end

labels_out = cellfun(@(x) num2str(x), labels_out, 'uni', false);
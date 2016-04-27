%% Initial ideas for dividing and labelling VAP task trials

function labels_out = func_VAP_labels(allEvents, stim_ind)   

movie_event = 'play_movie';

movie_ind = [1; find(strncmpi(allEvents(:,3), movie_event, length(movie_event)))];
block = cell(length(movie_ind)-1,1);
labels_out = cell(length(stim_ind), 4);
labels_out(:,1) = {'VAP'};

for block_n = 1:size(block,1)
    block{block_n} = find(stim_ind>movie_ind(block_n)&stim_ind<movie_ind(block_n+1));
    if length(block{block_n}) >= 10
        ind = find(stim_ind<movie_ind(block_n+1), 10, 'last');
        labels_out(ind,2)     = {'Familiarization'};
        labels_out(ind,3)     = {block_n};
        labels_out(ind,4)     = num2cell(1:10);        
    end
    ind = find(stim_ind<movie_ind(block_n+1), 2, 'last');
    labels_out(ind,2)     = {'Test'};
    labels_out(ind,3)     = {block_n};
    labels_out(ind,4)     = num2cell(1:2);
end
labels_out(cellfun('isempty', labels_out)) = {'Unknown'};
labels_out = strjoin(cellfun(@num2str, labels_out, 'uni', false),',');
Fs = 60;
time = 9.5;
trial_n = 1;

test_data = allData(foundEvents{trial_n,3}:foundEvents{trial_n,8},columns);
test_data(test_data == -1) = NaN;
test_data(:,1) = (test_data(:,1) - test_data(1,1))/1000000;

resampled_data = NaN(time*Fs,length(columns));
sample_points= 0:1/Fs:time-1/Fs;

if max(diff(test_data(:,1))) >= 1
   % Skip trial & note
else
    [resampled_data(:,2:5), resampled_data(:,1)] = resample(test_data(:,2:5), test_data(:,1), Fs,3,1);
    for sample_n = 1:size(resampled_data,1)
        sample_before = find(test_data(:,1) < resampled_data(sample_n),1,'last');
        sample_after  = find(test_data(:,1) >= resampled_data(sample_n),1,'first');
        notLooking = isnan(test_data([sample_before, sample_after], :));
        if any(notLooking(:))
            resampled_data(sample_n, any(notLooking)) = NaN;
        end           
    end
end
   

% 04/04/2016 - 0.1
% Old-New event code fix

% Programmed by D. Brady

fh      = @(x) all(isnan(x(:))); % Function for determining if cell is NaN (or blank apparently!?)
[l, ~]  = size(test); % Find the lengths of the imported data
output  = cell(l,13); % Prep output variable

for n = 1:l
    output(n,1:length(test(n,~cellfun(fh, test(n,:))))) = test(n,~cellfun(fh, test(n,:))); % Run above function (fh) on that line of data and write the results to output variable
end
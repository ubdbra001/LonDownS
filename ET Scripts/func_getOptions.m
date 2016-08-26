function selectedInfo = func_getOptions(file_info, prompt_str, select)

[ind,~] = listdlg('ListString', file_info.Name,... % Ask participant to select which info to use
                  'SelectionMode', select,...
                  'PromptString', prompt_str,...
                  'ListSize', [400 300]);

if isempty(ind)
    error('Nothing selected');       % Throw error if nothing selected
else
    selectedInfo = file_info(ind,:); % Put selected info into output variable
end                 


              
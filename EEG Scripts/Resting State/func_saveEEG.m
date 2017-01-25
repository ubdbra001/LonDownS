function EEG = func_saveEEG(EEG, paths, filename, folder_n)

currStage = RS_constants.outputFolders{folder_n};    % Current stage of processing
prevStage = RS_constants.outputFolders{folder_n-1};  % Previous stage of processing

EEG = pop_saveset(EEG,...                            % Save EEG 
                  'filename', sprintf('%s_%s', EEG.setname, currStage),...
                  'filepath', paths.currDir);
                      
if ~exist(prevStage, 'dir')                          % Check if dir exists and create if not
    mkdir(paths.currDir, prevStage)
end
        
movefile(filename, fullfile(prevStage, filesname));  % Move file for previous stage to different folder
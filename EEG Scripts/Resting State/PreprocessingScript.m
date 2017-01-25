%% Pre-processing script for Resting state data

paths.script = strsplit(fileparts(mfilename('fullpath')), filesep);
paths.script{1} = filesep; 
addpath(fullfile(paths.script{:}));
addpath(fullfile(paths.script{1:end-1}))

%addEEGLAB;

paths.data  = uigetdir('','Select main data folder');                      % Ask user to select main data folder
if paths.data == 0; error('Path not selected'); end                        % Throw error if no path selected

cd(paths.data)                                                             % Change to main data dir
folders = dir(folder_search_str);                                          % Get the different stimulus types available (in different dirs)

for folder_n = 1:length(folders)                                           % Run through each dir
    paths.currDir = fullfile(paths.data, folders(folder_n).name);          % Generate dir name for current loop
    cd(paths.currDir)                                                      % Change to that dir
    files = dir(file_search_str);                                          % Get all .set files in that dir
    for file_n = 1:length(files)                                           % Run through each file
        EEG = pop_loadset('filename', files(file_n).name);                 % Load the data for the file
        
        %% 1. Resample to 500 Hz if original sample rate is greater 
        if EEG.srate > RS_constants.sRate                                                 
            EEG = pop_resample(EEG, RS_constants.sRate);
        end
        
        %% 2. Change electrode montage to one we are using (EGI HydroCel GSN 128 chan)
        EEG = pop_chanedit(EEG, 'lookup', RS_constants.montageFile);
        
        %% 3. Update included electrode list to remove poorly placed electrodes
        EEG.removedChans = [RS_constants.remChans RS_constants.missingChans];% Record poorly placed electrodes
        EEG.includedChans = setdiff(1:EEG.nbchan, EEG.removedChans);       % Remove these from analyses
        
        %% 4 Methods for IDing bad channels - needs work
        
        EEG = func_badChanID(EEG);
        
        %% 5. Interpolate Bad channels
        
        % EEG = pop_interp(EEG, EEG.bad_chans, 'spherical');
        
        EEG = erplab_interpolateElectrodes(EEG, EEG.badChans,...           % Interpolate bad channels ignoring the removed channels
                                           EEG.removedChans, 'spherical');
        
        %% Save data and archive original files
        
        EEG = func_saveEEG(EEG, paths, files(file_n).name, 2);
        
        %% 6. Filter data
        
        EEG = pop_eegfiltnew(EEG, RS_constants.hiCutOff, RS_constants.lowCutOff, 3300, 0, [], 0); % Bandpass filter (NB: Correct filter order?)

        %% 7. Remove artefacts but save removed portions - needs work
                
        EEG = func_continuousRej(EEG); 

        %EEG.include = setdiff(EEG.include, [params.VEOGChans, params.HEOGChans]); % Remove HEOG & VEOG channels from analyses
        
        
        %% Save data post artefact rejection and archive interpolated files
        
        EEG = func_saveEEG(EEG, paths, files(file_n).name, 3);
    end
    
end

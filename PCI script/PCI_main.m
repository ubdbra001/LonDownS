%% Script to import the PCI csv data and extract stats about each of the objects played with for both children and parents

%% User editable variables
filenameFormat = 'PCI*.csv'; % General filename structure of the PCI files
defaultDir = '/Volumes/ADDS/ADDS DATA All Subjects/Behavioural analyses/PCI/PCI datavyu coding MK RTP/PCI Datavyu export/export Ruby/'; % Initial directory to open for dir select
addpath(fileparts(mfilename('fullpath')))
outputHeader = 'Participant ID,Actor,Object,totalTime,meanTime,sdTime,Transitions';

%% Main script
dataDir = strsplit(uigetdir(defaultDir), filesep);
cd(strjoin(dataDir, filesep))     % Select data dir and change to it
files = dir(filenameFormat); % Find all PCI csv files

exportFlag = questdlg('Would you like to export the data?', 'Export data', 'Yes', 'No', 'Yes');
exportFlag = strcmp(exportFlag, 'Yes');
if exportFlag
    [outName, outDir] = uiputfile('*.csv', 'Save output as');
    outFile = fullfile(outDir, outName);
    outTable = table();
end

analysisParams.actor = {'child', 'parent'};

switch dataDir{end}
    case 'actions<baby,parent>'
        analysisParams.codeType       = 1;
        analysisParams.ObjCols        = {5:7, 11:13};   % The columns of the file that indicate the objects each actor has picked up
    case 'babyactions<>, parentactions<>'
        analysisParams.codeType       = 2;
        analysisParams.childObjCols   = {5:7, 15:17};   % The columns of the file that indicate the objects each actor has picked up
    otherwise
        error('Folder selected not recognised');
end

for file_n = 1:length(files)
    name = strsplit(files(file_n).name, {'.', ' '});
    p_name = name{2};                                          % Generate participant name
    try
        PCI.(p_name).raw    = func_importPCI(files(file_n).name, analysisParams.codeType);         % Import data from the files found
        for actor_n = 1:length(analysisParams.actor)
            PCI.(p_name).(analysisParams.actor{actor_n})  = func_PCIobjectstats(PCI.(p_name).raw, analysisParams.ObjCols{actor_n});  % Produce stats for objects
            if exportFlag
                outTable = vertcat(outTable, horzcat(repmat(table({p_name}, {analysisParams.actor{actor_n}}, 'VariableNames', {'Participant_ID', 'Actor'}), height(PCI.(p_name).(analysisParams.actor{actor_n})),1), PCI.(p_name).(analysisParams.actor{actor_n})));
            end
        end
    catch ME
        disp(p_name)
        disp(getReport(ME))
        disp('Moving onto next file');
    end
end

if exportFlag
    writetable(outTable, outFile, 'FileType', 'text')
end
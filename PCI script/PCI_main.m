%% Script to import the PCI csv data and extract stats about each of the objects played with for both children and parents

% Need to add:
% Directionality of transitions: Parent-child/child-parent
% Measure of overlap in objects (Amount of time spent manipulating multiple
% objects)
% Proportion time spent maniplulation overall (proportion of 5 mins spent
% with at least one object)

%% User editable variables
filenameFormat = 'PCI*.csv'; % General filename structure of the PCI files
defaultDir = '/Volumes/ADDS/ADDS DATA All Subjects/Behavioural analyses/PCI/PCI datavyu coding MK RTP/PCI Datavyu export/export Ruby/'; % Initial directory to open for dir select
addpath(fileparts(mfilename('fullpath')))
analysisParams.actor = {'child', 'parent'};

%% Main script
dataDir = strsplit(uigetdir(defaultDir), filesep);
cd(strjoin(dataDir, filesep))     % Select data dir and change to it
files = dir(filenameFormat);      % Find all PCI csv files

exportFlag = questdlg('Would you like to export the output?', 'Export data', 'Yes', 'No', 'Yes');
exportFlag = strcmp(exportFlag, 'Yes');
if exportFlag
    [out.Name, out.Dir] = uiputfile('*.csv', 'Save output as');
    out.File            = fullfile(out.Dir, out.Name);
    out.Table           = table();

    out.colName         = func_appendFilename(out.Name,' _collapsed');
    out.colFile         = fullfile(out.Dir, out.colName);
    out.colTable        = table();
end


switch dataDir{end}
    case 'actions<baby,parent>'
        analysisParams.codeType       = 1;
        analysisParams.ObjCols        = {{5:7, 11:13}, {11:13, 5:7}};   % The columns of the file that indicate the objects each actor has picked up
    case 'babyactions<>, parentactions<>'
        analysisParams.codeType       = 2;
        analysisParams.ObjCols        = {{5:7, 15:17}, {15:17, 5:7}};   % The columns of the file that indicate the objects each actor has picked up
    otherwise
        error('Folder selected not recognised');
end

for file_n = 1:length(files)
    p_name = strsplit(files(file_n).name, {'.', ' '});
    p_name = p_name{2};                                          % Generate participant name
    try
        PCI.(p_name).raw    = func_importPCI(files(file_n).name, analysisParams.codeType);  % Import data from the files found
        for actor_n = 1:length(analysisParams.actor)                                        % For each actor (in this case: child and parent)  
            [PCI.(p_name).(analysisParams.actor{actor_n}), allTimes] = func_PCIobjectstats(PCI.(p_name).raw, analysisParams.ObjCols{actor_n});  % Produce stats for objects
            if exportFlag
                % If the export flag is tagged concatenate the table of stats produced with the output table 
                out.Table    = func_genOutput(out.Table, PCI.(p_name).(analysisParams.actor{actor_n}), [{p_name}, analysisParams.actor(actor_n)]);
                out.colTable = func_genColOutput(out.colTable, PCI.(p_name).(analysisParams.actor{actor_n}), allTimes, [{p_name}, analysisParams.actor(actor_n)]);
            end
        end
    catch ME % Error handling
        disp(p_name)
        disp(getReport(ME))
        disp('Moving onto next file');
    end
end

if exportFlag % Write tables to file
    writetable(out.Table, out.File, 'FileType', 'text')
    writetable(out.colTable, out.colFile, 'FileType', 'text')
end
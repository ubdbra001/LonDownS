%% Script to import the PCI csv data and extract stats about each of the objects played with for both children and parents

%% User editable variables
filenameFormat = 'PCI*.csv'; % General filename structure of the PCI files
defaultDir = '/Volumes/ADDS/ADDS DATA All Subjects/Behavioural analyses/PCI/PCI datavyu coding MK RTP/PCI Datavyu export/export Ruby/'; % Initial directory to open for dir select
addpath(fileparts(mfilename('fullpath')))

%% Main script
dataDir = strsplit(uigetdir(defaultDir), filesep);
cd(strjoin(dataDir, filesep))     % Select data dir and change to it
files = dir(filenameFormat); % Find all PCI csv files

switch dataDir{end}
    case 'actions<baby,parent>'
        analysisParams.codeType       = 1;
        analysisParams.childObjCols   = 5:7;   % The columns of the file that indicate the objects the child has picked up
        analysisParams.parentObjCols  = 11:13; % The columns of the file that indicate the objects the parent has picked up
    case 'babyactions<>, parentactions<>'
        analysisParams.codeType       = 2;
        analysisParams.childObjCols   = 5:7;   % The columns of the file that indicate the objects the child has picked up
        analysisParams.parentObjCols  = 15:17; % The columns of the file that indicate the objects the parent has picked up
    otherwise
        error('Folder selected not recognised');
end

for file_n = 1:length(files)
    name = strsplit(files(file_n).name, {'.', ' '});
    p_name = name{2};                                          % Generate participant name
    try
        PCI.(p_name).raw    = func_importPCI(files(file_n).name, analysisParams.codeType);                  % Import data from the files found
        PCI.(p_name).child  = func_PCIobjectstats(PCI.(p_name).raw, analysisParams.childObjCols);  % Produce stats for child objects
        PCI.(p_name).parent = func_PCIobjectstats(PCI.(p_name).raw, analysisParams.parentObjCols); % Produce stats for adult objects
    catch ME
        disp(p_name)
        disp(getReport(ME))
        disp('Moving onto next file');
    end
end
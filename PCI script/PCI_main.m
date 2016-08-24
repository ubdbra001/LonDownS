%% Script to import the PCI csv data and extract stats about each of the objects played with for both children and parents

%% User editable variables
filenameFormat = 'PCI*.csv'; % General filename structure of the PCI files
defaultDir = '/Volumes/ADDS/ADDS DATA All Subjects/Behavioural analyses/PCI/PCI datavyu coding MK RTP/PCI Datavyu export/export Ruby/actions <baby,parent>'; % Initial directory to open for dir select

childObjCols   = 5:7;   % The columns of the file that indicate the objects the child has picked up
parentObjCols  = 11:13; % The columns of the file that indicate the objects the parent has picked up

addpath(fileparts(mfilename('fullpath')))

%% Main script
cd(uigetdir(defaultDir))     % Select data dir and change to it
files = dir(filenameFormat); % Find all PCI csv files

for file_n = 1:length(files)
    p_name = files(file_n).name(5:12);                                          % Generate participant name
    try
        PCI.(p_name).raw    = func_importPCI(files(file_n).name);                   % Import data from the files found
        PCI.(p_name).child  = func_PCIobjectstats(PCI.(p_name).raw, childObjCols);  % Produce stats for child objects
        PCI.(p_name).parent = func_PCIobjectstats(PCI.(p_name).raw, parentObjCols); % Produce stats for adult objects
    catch ME
        disp(getReport(ME))
        disp('Moving onto next file');
    end
end
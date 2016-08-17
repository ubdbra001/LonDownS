files = dir('PCI*.csv'); % Find all PCI csv files

for file_n = 1:length(files)
    p_name = files(file_n).name(5:12);
    PCI.(p_name).raw    = func_importPCI(files(file_n).name); % Import data from the files found
    PCI.(p_name).child  = func_PCIobjectstats(PCI.(p_name).raw, 6:7);
    PCI.(p_name).parent = func_PCIobjectstats(PCI.(p_name).raw, 11:12);
end
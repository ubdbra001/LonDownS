%% Add EEGLAB directories to path
function addEEGLAB

eeglabDir = fileparts(which('eeglab.m'));
addpath(genpath(fullfile(eeglabDir, 'functions')));
addpath(genpath(fullfile(eeglabDir, 'plugins')), '-end');
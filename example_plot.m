%--------------------------------------------------------------------------
% Example script to load magnetic step width results from the BIDS dataset 
% and plot it
% jph 2025
%--------------------------------------------------------------------------
clear
% close all
clc

addpath('auxiliary')

% User select -------------------------------------------------------------
% Select local path of the dataset
path = 'C:/data/';

% Select subfolder (e.g., sub-01) and task (e.g., task-walk05ms) to load
data_select = {'01', 'walk05ms'};

% Load result -------------------------------------------------------------
result = importResultFromBids(path, data_select);
if ~isstruct(result)
    return
end

% Plot result -------------------------------------------------------------
visualizeStepWidthResult(result);
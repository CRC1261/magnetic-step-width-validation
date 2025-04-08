%--------------------------------------------------------------------------
% Example script to load magnetic step width results from the BIDS dataset 
% and plot it
% jph 2024
%--------------------------------------------------------------------------
clear
close all
clc

addpath('auxiliary')

% User select -------------------------------------------------------------

% Select local path of the dataset
path = 'C:/motion_distest_bids/step_width/data/';

% Select subfolder (e.g., sub-11) and task (e.g., task-walk05ms) to load
data_select = {'01', 'walk05ms'};


% Load --------------------------------------------------------------------
result = importResultFromBids(path, data_select);
if ~isstruct(result)
    return
end

% task = deriveDistances(task, calib);

% Plot results ------------------------------------------------------------
% Plot results without calibration
% visualizeDistanceOverTime(task, false);
% visualizeDistanceOverDistance(task, false);

figure
plot(result.omc.sc.sw_l)
hold on
plot(result.omc.ts.sw_l)
plot(result.omc.ic.sw_l)
plot(result.magn.sc.sw_l)
%--------------------------------------------------------------------------
% Example script to load magnetic step width results from the BIDS dataset 
% and validate them against the different reference methods
% jph 2025
%--------------------------------------------------------------------------
clear
close all
clc

addpath('auxiliary')

% User select -------------------------------------------------------------

% Select local path of the dataset
path = 'C:/data/';

data_select = {...
    {'01', 'walk05ms'},...
    {'02', 'walk05ms'},...
    {'03', 'walk05ms'},...
    {'04', 'walk05ms'},...
    {'05', 'walk05ms'},...
    {'06', 'walk05ms'},...
    {'07', 'walk05ms'},...
    {'08', 'walk05ms'},...
            };

% Load data and compute error metrics -------------------------------------
N_max = 0;
N_sel = length(data_select);
for i = 1 : N_sel

    result = importResultFromBids(path, data_select{i});
    if ~isstruct(result)
        return
    end
    
    % Descriptive statistics
    stat_sw.magn.sc(i) = calcDescStatistics(result.magn.sc);
    stat_sw.omc.sc(i) = calcDescStatistics(result.omc.sc);
    stat_sw.omc.ts(i) = calcDescStatistics(result.omc.ts);
    stat_sw.omc.ic(i) = calcDescStatistics(result.omc.ic);

    % Distance comparison
    e_d.sc_vs_sc(i) = compareDistance(result.omc.sc, result.magn.sc);
    
    % Timing comparison
    e_t.sc_vs_sc(i) = compareTiming(result.omc.sc, result.magn.sc);
    e_t.sc_vs_ts(i) = compareTiming(result.omc.ts, result.magn.sc);

    % Step width comparison
    e_sw.sc_vs_sc(i) = compareStepWidth(result.omc.sc, result.magn.sc);
    e_sw.sc_vs_ts(i) = compareStepWidth(result.omc.ts, result.magn.sc);
    e_sw.sc_vs_ic(i) = compareStepWidth(result.omc.ic, result.magn.sc);
end

method_names = {'shank clearance', 'mid-swing', 'initial contact'};

%% Visualize descriptive statistics and MAE
visualizeStepWidthStat(stat_sw, e_sw);

%% Print error metrics: Distance ------------------------------------------
ae_d.sc_vs_sc = averageErrorMetrics(e_d.sc_vs_sc);
fprintf('Distance results: %s estimate vs. %s reference\n', method_names{1}, method_names{1})

labels = {'low', 'up', 'all'};
c = 100; % Conversion to cm
for i = 1 : length(labels)
    em = ae_d.sc_vs_sc.(labels{i});
    fprintf('%s: ME: %.1f cm, SD: %.2f cm, MAE: %.1f cm, RMSE: %.1f cm, SCC: %.2f\n',...
        labels{i},...
        em.me * c, em.std * c,...
        em.mae * c, em.rmse * c,...
        em.scc);
end

%% Print error metrics: Timing --------------------------------------------
ae_t.sc_vs_sc = averageErrorMetrics(e_t.sc_vs_sc);
ae_t.sc_vs_ts = averageErrorMetrics(e_t.sc_vs_ts);

fprintf('\nTiming results:\n')

labels = {'low', 'up', 'all'};
methods = {'sc_vs_sc', 'sc_vs_ts'};
c = 1000; % Conversion to ms
for i_m = 1 : length(methods)
    fprintf('%s estimate vs. %s reference\n', method_names{1}, method_names{i_m})
    for i = 1 : length(labels)
        em = ae_t.(methods{i_m}).(labels{i});
        fprintf('%s: ME: %.0f ms, SD: %.0f ms, MAE: %.0f ms, RMSE: %.0f ms\n',...
            labels{i},...
            em.me * c, em.std * c,...
            em.mae * c, em.rmse * c);
    end
end
%% Print error metrics: Step width ----------------------------------------
ae_sw.sc_vs_sc = averageErrorMetrics(e_sw.sc_vs_sc);
ae_sw.sc_vs_ts = averageErrorMetrics(e_sw.sc_vs_ts);
ae_sw.sc_vs_ic = averageErrorMetrics(e_sw.sc_vs_ic);

fprintf('\nStep width results\n');

labels = {'l', 'r', 'lr'};
methods = {'sc_vs_sc', 'sc_vs_ts', 'sc_vs_ic'};
c = 100; % Conversion to cm

for i_m = 1 : length(methods)
    fprintf('%s estimate vs. %s reference\n', method_names{1}, method_names{i_m})
    for i = 1 : length(labels)
        em = ae_sw.(methods{i_m}).(labels{i});
        fprintf('%s: ME: %.1f cm, SD: %.2f cm, MAE: %.1f cm, RMSE: %.1f cm, SCC: %.2f, MAE-VAR: %.2f cm\n',...
            labels{i},...
            em.me * c, em.std * c,...
            em.mae * c, em.rmse * c,...
            em.scc, em.var_mae * c);
    end
end

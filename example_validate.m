%--------------------------------------------------------------------------
% Example script to load magnetic motion data from the BIDS dataset 
% and validate the accuracy of the magnetic motion tracking approach
% jph 2024
%--------------------------------------------------------------------------
clear
close all
clc

addpath('auxiliary')

% User select -------------------------------------------------------------

% Select local path of the dataset
path = 'C:/motion_distest_bids/step_width/data/';

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

method_names = {'shank clearance', 'terminal swing', 'initial contact'};

%% Visualize descriptive statistics and MAE
visualizeStepWidthStat(stat_sw, e_sw)
%%

%% Print error metrics: Distance ------------------------------------------
ae_d.sc_vs_sc = averageErrorMetrics(e_d.sc_vs_sc);
fprintf('Distance results: %s estimate vs. %s reference\n', method_names{1}, method_names{1})

labels = {'low', 'up', 'all'};
c = 100; % Conversion to cm
for i = 1 : length(labels)
    em = ae_d.sc_vs_sc.(labels{i});
    fprintf('%s: MAE: %.1f+%.1f cm, ME: %.1f+%.1f cm, RMSE: %.1f+%.1f cm, MAPE: %.1f+%.1f%%, SCC: %.2f+%.2f\n',...
        labels{i},...
        em.mae * c, em.mae_std * c,...
        em.me * c, em.me_std * c,...
        em.rmse * c, em.rmse_std * c,...
        em.mape, em.mape_std,...
        em.scc, em.scc_std);
end

%% Print error metrics: Timing --------------------------------------------
ae_t.sc_vs_sc = averageErrorMetrics(e_t.sc_vs_sc);
ae_t.sc_vs_ts = averageErrorMetrics(e_t.sc_vs_ts);

fprintf('Timing results:\n')

labels = {'low', 'up', 'all'};
methods = {'sc_vs_sc', 'sc_vs_ts'};
c = 1000; % Conversion to ms
for i_m = 1 : length(methods)
    fprintf('%s estimate vs. %s reference\n', method_names{1}, method_names{i_m})
    for i = 1 : length(labels)
        em = ae_t.(methods{i_m}).(labels{i});
        fprintf('%s: MAE: %.0f+%.0f ms, ME: %.0f+%.0f ms, RMSE: %.0f+%.0f ms\n',...
            labels{i},...
            em.mae * c, em.mae_std * c,...
            em.me * c, em.me_std * c,...
            em.rmse * c, em.rmse_std * c);
    end
end
%% Print error metrics: Step width ----------------------------------------
ae_sw.sc_vs_sc = averageErrorMetrics(e_sw.sc_vs_sc);
ae_sw.sc_vs_ts = averageErrorMetrics(e_sw.sc_vs_ts);
ae_sw.sc_vs_ic = averageErrorMetrics(e_sw.sc_vs_ic);

fprintf('Step width results\n');

labels = {'l', 'r', 'lr'};
methods = {'sc_vs_sc', 'sc_vs_ts', 'sc_vs_ic'};
c = 100; % Conversion to cm

for i_m = 1 : length(methods)
    fprintf('%s estimate vs. %s reference\n', method_names{1}, method_names{i_m})
    for i = 1 : length(labels)
        em = ae_sw.(methods{i_m}).(labels{i});
        fprintf('%s: MAE: %.1f+%.1f cm, ME: %.1f+%.1f cm, RMSE: %.1f+%.1f cm, MAPE: %.1f+%.1f%%, SCC: %.2f+%.2f, MAE-VAR: %.2f+%.2f cm\n',...
            labels{i},...
            em.mae * c, em.mae_std * c,...
            em.me * c, em.me_std * c,...
            em.rmse * c, em.rmse_std * c,...
            em.mape, em.mape_std,...
            em.scc, em.scc_std,...
            em.var_mae * c, em.var_mae_std * c);
    end
end

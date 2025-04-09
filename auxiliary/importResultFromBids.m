function result = importResultFromBids(path, selection)
%IMPORTSUBFROMBIDS Summary of this function goes here
%   Detailed explanation goes here

    % Append slash at the end if necessary
    if (path(end) ~= '/') && (path(end) ~= '\')
        path = [path '/'];
    end

    % Set to result path
    path_result = [path 'derivatives/results/'];

    % Number of tracksystems in this dataset is fixed
    p.tracksystems = {'omc', 'magn'};


    result = struct();

    % Check participants list ---------------------------------------------
    participants = readcell([path 'participants.tsv'], 'FileType', 'text', 'Delimiter', '\t');
    for i_p = 2 : length(participants)
        if strcmp(participants{i_p, 1}, ['sub-' selection{1}]) 
            result.data_type = participants{i_p, 2};
            break;
        end
    end
    if ~isfield(result, 'data_type')
        fprintf('Selected subset ''sub-%s'' not found in participants.tsv in directory ''%s''\n', selection{1}, path)
        result = false;
        return;
    end


    % List contents in selected result directory
    list_con = dir(path_result);

    i_s = 0;

    % Check if subset exists in selected result directory -----------------
    for i_c = 1 : length(list_con)
        if list_con(i_c).isdir && strcmp(list_con(i_c).name, ['sub-' selection{1}])
            i_s = i_c;
        end
    end

    if ~i_s
        fprintf('Selected subset ''sub-%s'' not found in directory ''%s''\n', selection{1}, path_result)
        result = false;
        return;
    end

    % Check optical result files
    path_omc_result = sprintf('%ssub-%s/sub-%s_task-%s_tracksys-%s', path_result, selection{1}, selection{1}, selection{2}, p.tracksystems{1});
    if ~exist([path_omc_result '_results.tsv'], 'file') %|| ~exist([path_omc_result '_channels.tsv'], 'file')
        fprintf('Tracksys ''%s'' files missing in selected task ''%s'' of subset ''sub-%s'' in directory ''%s''\n', p.tracksystems{1}, selection{2}, selection{1}, path_omc_result)
        result = false;
        return;
    end

    % Check magnetic result files -------------------------------------------
    path_magn_result = sprintf('%ssub-%s/sub-%s_task-%s_tracksys-%s', path_result, selection{1}, selection{1}, selection{2}, p.tracksystems{2});
    if ~exist([path_magn_result '_results.tsv'], 'file') %|| ~exist([path_magn_result '_channels.tsv'], 'file')
        fprintf('Tracksys ''%s'' files missing in selected task ''%s'' of subset ''sub-%s'' in directory ''%s''\n', p.tracksystems{2}, selection{2}, selection{1}, path_magn_result)
        result = false;
        return;
    end


    % At this point, all required files are available
    % Load optical data ---------------------------------------------------
    M_sig = readmatrix([path_omc_result '_results.tsv'], 'FileType','text', 'Delimiter', '\t');
    % M_ch = readcell([path_omc_result '_channels.tsv'], 'FileType','text', 'Delimiter', '\t');
    % specs = jsondecode(fileread([path_omc_common '_motion.json']));

    k = 1;
    % Shank clearance result
    result.omc.sc.name = 'Shank clearance';
    result.omc.sc.N = size(M_sig, 1);
    result.omc.sc.inds_l = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.sc.inds_r = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.sc.vals_l = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.sc.vals_r = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.sc.sw_l = M_sig(:, k)';
    k = k + 1;
    result.omc.sc.sw_r = M_sig(:, k)';
    k = k + 1;

    % Terminal swing result
    result.omc.ts.name = 'Terminal swing';
    result.omc.ts.N = size(M_sig, 1);
    result.omc.ts.inds_l = M_sig(:, k)';
    k = k + 1;
    result.omc.ts.inds_r = M_sig(:, k)';
    k = k + 1;
    result.omc.ts.sw_l = M_sig(:, k)';
    k = k + 1;
    result.omc.ts.sw_r = M_sig(:, k)';
    k = k + 1;

    % Initial contact result
    result.omc.ic.name = 'Initial contact';
    result.omc.ic.N = size(M_sig, 1);
    result.omc.ic.inds_l = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.ic.inds_r = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.omc.ic.sw_l = M_sig(:, k)';
    k = k + 1;
    result.omc.ic.sw_r = M_sig(:, k)';
    k = k + 1;


    % Load magnetic data ---------------------------------------------------
    M_sig = readmatrix([path_magn_result '_results.tsv'], 'FileType','text', 'Delimiter', '\t');
    % M_ch = readcell([path_omc_result '_channels.tsv'], 'FileType','text', 'Delimiter', '\t');
    % specs = jsondecode(fileread([path_omc_common '_motion.json']));

    k = 1;
    % Shank clearance result
    result.magn.sc.name = 'Shank clearance';
    result.magn.sc.N = size(M_sig, 1);
    result.magn.sc.inds_l = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.magn.sc.inds_r = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.magn.sc.vals_l = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.magn.sc.vals_r = M_sig(:, k  + [0, 1])';
    k = k + 2;
    result.magn.sc.sw_l = M_sig(:, k)';
    k = k + 1;
    result.magn.sc.sw_r = M_sig(:, k)';
    k = k + 1;


    result.magn.sc.l.mn = mean(result.magn.sc.sw_l);
    result.magn.sc.l.std = std(result.magn.sc.sw_l);
    
    result.magn.sc.l.mn = mean(result.magn.sc.sw_l);
    result.magn.sc.l.std = std(result.magn.sc.sw_l);

    % % Calc error metrics: 
    % % Shank clearance estimate vs. shank clearance reference
    % result.e.sc_vs_sc.l = calcErrorMetrics(result.omc.sc.sw_l, result.magn.sc.sw_l);
    % result.e.sc_vs_sc.r = calcErrorMetrics(result.omc.sc.sw_r, result.magn.sc.sw_r);
    % result.e.sc_vs_sc.lr = calcErrorMetrics([result.omc.sc.sw_l, result.omc.sc.sw_r],...
    %     [result.magn.sc.sw_l, result.magn.sc.sw_r]);
    % 
    % % Shank clearance estimate vs. terminal swing reference
    % result.e.sc_vs_ts.l = calcErrorMetrics(result.omc.ts.sw_l, result.magn.sc.sw_l);
    % result.e.sc_vs_ts.r = calcErrorMetrics(result.omc.ts.sw_r, result.magn.sc.sw_r);
    % result.e.sc_vs_ts.lr = calcErrorMetrics([result.omc.ts.sw_l, result.omc.ts.sw_r],...
    %     [result.magn.sc.sw_l, result.magn.sc.sw_r]);
    % 
    % % Shank clearance estimate vs. initial contact reference
    % result.e.sc_vs_ic.l = calcErrorMetrics(result.omc.ic.sw_l, result.magn.sc.sw_l);
    % result.e.sc_vs_ic.r = calcErrorMetrics(result.omc.ic.sw_r, result.magn.sc.sw_r);
    % result.e.sc_vs_ic.lr = calcErrorMetrics([result.omc.ic.sw_l, result.omc.ic.sw_r],...
    %     [result.magn.sc.sw_l, result.magn.sc.sw_r]);
    % 

    result.selection = selection;
end


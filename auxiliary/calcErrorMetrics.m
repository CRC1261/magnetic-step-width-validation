function em = calcErrorMetrics(v, v_est)
    % Length (for averaging purposes)
    em.N = length(v);

    % Error signal
    em.e = v - v_est;

    % Absolute error signal
    em.ae = abs(em.e);

    % Squared error signal
    em.se = em.e.^2;

    % Absolute percentage error signal
    em.ape = 100 * abs(em.e ./ v);

    % Mean value
    em.me = mean(em.e);
    em.me_std = std(em.e);

    % Mean absolute error
    em.mae = mean(em.ae);
    em.mae_std = std(em.ae);

    % Mean squared error
    em.mse = mean(em.se);
    em.mse_std = std(em.se);
    em.rmse = sqrt(em.mse);
    em.rmse_std = sqrt(em.mse_std);

    % Mean absolute percentage error
    em.mape = mean(em.ape);
    em.mape_std = std(em.ape);

    % Correlation
    em.pcc = corr(v', v_est', "Type", "Pearson");
    em.scc = corr(v', v_est', "Type", "Spearman");

    % MAE of variability
    em.var_mae = abs(std(v) - std(v_est));
end
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

    % Standard deviation
    em.std = std(em.e);

    % Mean absolute error
    em.mae = mean(em.ae);

    % Mean squared error
    em.mse = mean(em.se);
    em.rmse = sqrt(em.mse);

    % Mean absolute percentage error
    em.mape = mean(em.ape);

    % Correlation
    em.pcc = corr(v', v_est', "Type", "Pearson");
    em.scc = corr(v', v_est', "Type", "Spearman");

    % Error and absolute error of variability
    em.var_e = std(v) - std(v_est);
    em.var_ae = abs(std(v) - std(v_est));
end
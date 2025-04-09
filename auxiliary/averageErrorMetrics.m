function aem = averageErrorMetrics(em)
    fn = fieldnames(em(1));

    for i = 1 : length(fn)
        em_s = [em.(fn{i})];
        N_max = sum([em_s.N]);
        
        % Mean absolute error
        aem.(fn{i}).mae = sum([em_s.N] .* [em_s.mae]) / N_max;
        aem.(fn{i}).mae_std = sqrt(sum([em_s.N] .* [em_s.mae_std].^2) / N_max);
        
        % Mean error
        aem.(fn{i}).me = sum([em_s.N] .* [em_s.me]) / N_max;
        aem.(fn{i}).me_std = sqrt(sum([em_s.N] .* [em_s.me_std].^2) / N_max);
        
        % Root mean squared error (use MSE for averaging!)
        aem.(fn{i}).rmse = sqrt(sum([em_s.N] .* [em_s.mse]) / N_max); 
        aem.(fn{i}).rmse_std = sqrt(sqrt(sum([em_s.N] .* [em_s.mse_std].^2) / N_max)); 

        % Mean absolute percentage error
        aem.(fn{i}).mape = sum([em_s.N] .* [em_s.mape]) / N_max;
        aem.(fn{i}).mape_std = sqrt(sum([em_s.N] .* [em_s.mape_std].^2) / N_max);

        % Spearman correlation coefficient
        aem.(fn{i}).scc = sum([em_s.N] .* [em_s.scc]) / N_max;
        aem.(fn{i}).scc_std = std([em_s.scc], [em_s.N]);

        % MAE of the variability
        aem.(fn{i}).var_mae = sum([em_s.N] .* [em_s.var_mae]) / N_max;
        aem.(fn{i}).var_mae_std = std([em_s.var_mae], [em_s.N]);
    end
end
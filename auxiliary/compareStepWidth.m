function em = compareStepWidth(b, b_est)
    em.l = calcErrorMetrics(b.sw_l, b_est.sw_l);
    em.r = calcErrorMetrics(b.sw_r, b_est.sw_r);
    em.lr = calcErrorMetrics([b.sw_l, b.sw_r],...
        [b_est.sw_l, b_est.sw_r]);
end
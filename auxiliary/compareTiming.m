function em = compareTiming(b, b_est)

    % Use same minima times for lower and upper distance (for terminal swing)
    if size(b.inds_r, 1) == 1
        b.inds_r = [b.inds_r; b.inds_r];
        b.inds_l = [b.inds_l; b.inds_l];
    end
    if size(b_est.inds_r, 1) == 1
        b_est.inds_r = [b_est.inds_r; b_est.inds_r];
        b_est.inds_l = [b_est.inds_l; b_est.inds_l];
    end


    % Lower distance minima times from both left and right steps
    em.low = calcErrorMetrics([b.inds_l(1, :), b.inds_r(1, :)],...
        [b_est.inds_l(1, :), b_est.inds_r(1, :)]);

    % Upper distance minima times from both left and right steps
    em.up = calcErrorMetrics([b.inds_l(2, :), b.inds_r(2, :)],...
        [b_est.inds_l(2, :), b_est.inds_r(2, :)]);

    % Lower and upper distance minima times from all steps
    em.all = calcErrorMetrics(...
        [b.inds_l(1, :), b.inds_l(2, :),...
        b.inds_r(1, :), b.inds_r(2, :)],...
        [b_est.inds_l(1, :), b_est.inds_l(2, :),...
        b_est.inds_r(1, :), b_est.inds_r(2, :)]);
end
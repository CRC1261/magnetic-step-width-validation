function gf = visualizeStepWidthStat(stat, em)
    gf = figure;

    sides = {'l', 'r'};
    side_names = {'left', 'right'};
    c = 100; % Conversion to cm
    methods = {'Shank clearance', 'Mid-swing', 'Initial contact'};

    di = 0.2;
    di_l = 0.3;

    cmap = lines(4);


    N_p = length(stat.magn.sc);
    x_sc = [1 - di_l, N_p + di_l];
    y_sc = [5 30];
    i_p = 1 : N_p;

    % Distribution plots --------------------------------------------------
    for i = 1 : 2
        ax = subplot(3, 2, i);
        ax.TickLabelInterpreter = 'latex';

        plotStatErrorBar(i_p, [stat.magn.sc.(sides{i})], -di, c, cmap(1, :));
        hold on
        plotStatErrorBar(i_p, [stat.omc.sc.(sides{i})], -di/2, c, cmap(2, :));
        plotStatErrorBar(i_p, [stat.omc.ts.(sides{i})], di/2, c, cmap(3, :));
        plotStatErrorBar(i_p, [stat.omc.ic.(sides{i})], di, c, cmap(4, :));
        grid on
        xlabel('Participant', 'Interpreter', 'latex', 'FontSize', 14)
        ylabel('Step width (cm)', 'Interpreter', 'latex', 'FontSize', 14)
        ylim(y_sc)
        xlim(x_sc)

        title(['Comparison of ' side_names{i} ' step width'], 'Interpreter', 'latex', 'FontSize', 16);
        legend({['Estimate: ' methods{1}], ['Reference: ' methods{1}], ['Reference: ' methods{2}], ['Reference: ' methods{1}]}, 'FontSize', 14, 'Interpreter', 'latex', 'Location', 'northwest');
    end


    % Error plots ---------------------------------------------------------
    y_sc = [-10 4];
    for i = 1 : 2
        ax = subplot(3, 2, 2+i);
        ax.TickLabelInterpreter = 'latex';

        yline(0, '--', 'Color', 'black', 'HandleVisibility', 'off');
        hold on
        plotBiasErrorBar(i_p, [em.sc_vs_sc.(sides{i})], -di/2, c, cmap(2, :));
        plotBiasErrorBar(i_p, [em.sc_vs_ts.(sides{i})], di/2, c, cmap(3, :));
        plotBiasErrorBar(i_p, [em.sc_vs_ic.(sides{i})], di, c, cmap(4, :));
        grid on
        xlabel('Participant', 'Interpreter', 'latex', 'FontSize', 14)
        ylabel('Error (cm)', 'Interpreter', 'latex', 'FontSize', 14)
        ylim(y_sc)
        xlim(x_sc)

        title(['Error of ' side_names{i} ' step width'], 'Interpreter', 'latex', 'FontSize', 16);
        legend({['Compared to ' lower(methods{1})], ['Compared to ' lower(methods{2})], ['Compared to ' lower(methods{3})]}, 'FontSize', 14, 'Interpreter', 'latex', 'Location', 'northwest');
    end

    % Variability error plots ---------------------------------------------
    y_sc = [-1 2];
    for i = 1 : 2
        ax = subplot(3, 2, 4+i);
        ax.TickLabelInterpreter = 'latex';

        yline(0, '--', 'Color', 'black', 'HandleVisibility', 'off');
        hold on
        plotVariability(i_p, [em.sc_vs_sc.(sides{i})], -di/2, c, cmap(2, :));
        plotVariability(i_p, [em.sc_vs_ts.(sides{i})], di/2, c, cmap(3, :));
        plotVariability(i_p, [em.sc_vs_ic.(sides{i})], di, c, cmap(4, :));
        grid on
        xlabel('Participant', 'Interpreter', 'latex', 'FontSize', 14)
        ylabel('Error (cm)', 'Interpreter', 'latex', 'FontSize', 14)
        ylim(y_sc)
        xlim(x_sc)

        title(['Variability error of ' side_names{i} ' step width'], 'Interpreter', 'latex', 'FontSize', 16);
        legend({['Compared to ' lower(methods{1})], ['Compared to ' lower(methods{2})], ['Compared to ' lower(methods{3})]}, 'FontSize', 14, 'Interpreter', 'latex', 'Location', 'northwest');
    end

end

function plotStatErrorBar(i_p, es, dx, c, color)
    y = [es.mn] * c;
    z = [es.std] * c;

    errorbar(i_p + dx, y, z, 's', 'Color', color, 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', color);
end

function plotBiasErrorBar(i_p, es, dx, c, color)
    y = [es.me] * c;
    z = [es.std] * c;

    errorbar(i_p + dx, y, z, 's', 'Color', color, 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', color);
end

function plotVariability(i_p, es, dx, c, color)
    y = [es.var_e] * c;

    plot(i_p + dx, y, 's', 'Color', color, 'LineWidth', 1, 'MarkerSize', 4, 'MarkerFaceColor', color);
end


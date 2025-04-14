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

    for i = 1 : 2
        ax = subplot(2, 2, i);
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

    y_sc = [0 13];

    for i = 1 : 2
        ax = subplot(2, 2, 2+i);
        ax.TickLabelInterpreter = 'latex';

        plotMaeErrorBar(i_p, [em.sc_vs_sc.(sides{i})], -di/2, c, cmap(2, :));
        hold on
        plotMaeErrorBar(i_p, [em.sc_vs_ts.(sides{i})], di/2, c, cmap(3, :));
        plotMaeErrorBar(i_p, [em.sc_vs_ic.(sides{i})], di, c, cmap(4, :));
        grid on
        xlabel('Participant', 'Interpreter', 'latex', 'FontSize', 14)
        ylabel('MAE (cm)', 'Interpreter', 'latex', 'FontSize', 14)
        ylim(y_sc)
        xlim(x_sc)

        title(['Error of ' side_names{i} ' step width'], 'Interpreter', 'latex', 'FontSize', 16);
        legend({['Compared to ' lower(methods{1})], ['Compared to ' lower(methods{2})], ['Compared to ' lower(methods{3})]}, 'FontSize', 14, 'Interpreter', 'latex', 'Location', 'northwest');
    end

end

function plotStatErrorBar(i_p, es, dx, c, color)
    y = [es.mn] * c;
    z = [es.std] * c;

    errorbar(i_p + dx, y, z, '.', 'Color', color, 'LineWidth', 1);
end

function plotMaeErrorBar(i_p, es, dx, c, color)
    y = [es.mae] * c;
    z = [es.mae_std] * c;

    errorbar(i_p + dx, y, z, '.', 'Color', color, 'LineWidth', 1);
end


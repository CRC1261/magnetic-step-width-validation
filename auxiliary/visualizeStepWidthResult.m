function gf = visualizeStepWidthResult(result)
    gf = figure;

    label_header = ['Subfolder: sub-' result.selection{1} ', Task: ' result.selection{2}];
    sgtitle(label_header, 'Interpreter', 'latex');

    
    x_sc = [1 result.magn.sc.N];

    % cm = lines(4);

    sides = {'l', 'r'};
    titles = {'Left steps', 'Right steps'};
    c = 100; % Conversion to cm

    for i = 1 : 2
        ax(i) = subplot(1, 2, i);
        plot(result.magn.sc.(['sw_' sides{i}]) * c);
        hold on
        plot(result.omc.sc.(['sw_' sides{i}]) * c);
        plot(result.omc.ts.(['sw_' sides{i}]) * c);
        plot(result.omc.ic.(['sw_' sides{i}]) * c);
        grid on
        ax(i).TickLabelInterpreter = 'latex';
        xlabel('Index', 'Interpreter', 'latex', 'FontSize', 14)
        ylabel('Step width (cm)', 'Interpreter', 'latex', 'FontSize', 14)
        xlim(x_sc)
        title(titles{i}, 'Interpreter', 'latex', 'FontSize', 16)

        legend({['Estimate: ' result.magn.sc.name], ['Reference: ' result.omc.sc.name], ['Reference: ' result.omc.ts.name], ['Reference: ' result.omc.ic.name]}, 'FontSize', 14, 'Interpreter', 'latex');
    end

    linkaxes(ax, 'x')
end
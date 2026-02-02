function draw_outcome_screen(ptb, trial, params, choseGamble, n2, outcome)
    Screen('FillRect', ptb.win, ptb.bgColor);

    header = 'Outcome';
    DrawFormattedText(ptb.win, header, 'center', ptb.center(2)-250, ptb.textColor);

    if ~choseGamble
        msg = sprintf('SAFE chosen\n+$%d', params.money.safeAmount);
    else
        msg = sprintf('GAMBLE chosen\nFirst: %d   Second: %d\nResult: %s', trial.probCue, n2, upper(char(outcome)));
        if outcome == "win"
            msg = sprintf('%s\n+$%d', msg, trial.gambleAmount);
        else
            msg = sprintf('%s\n+$0', msg);
        end
    end

    DrawFormattedText(ptb.win, msg, 'center','center', ptb.textColor);

    % Optional: show block type small
    DrawFormattedText(ptb.win, sprintf('Block: %s', trial.blockType), 'center', ptb.center(2)+250, [180 180 180]);
end

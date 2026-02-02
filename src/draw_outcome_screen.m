function draw_outcome_screen(ptb, trial, params, choseGamble, n2, outcome)
    Screen('FillRect', ptb.win, ptb.bgColor);

    header = 'Outcome';
    DrawFormattedText(ptb.win, header, 'center', ptb.center(2)-250, ptb.textColor);

    if ~choseGamble
        msg = sprintf('SAFE chosen\nPayout: $%d', params.money.safeAmount);
    else
        base = sprintf('GAMBLE chosen\nFirst: %d   Second: %d\nResult: %s', trial.probCue, n2, upper(char(outcome)));
        if outcome == "win"
            msg = sprintf('%s\nPayout: $%d   (Safe would be $%d)', base, trial.gambleAmount, params.money.safeAmount);
        else
            msg = sprintf('%s\nPayout: $%d   (Safe would be $%d)', base, params.money.gambleLossAmount, params.money.safeAmount);
        end
    end

    DrawFormattedText(ptb.win, msg, 'center','center', ptb.textColor);

    % Optional: show block type small
    DrawFormattedText(ptb.win, sprintf('Block: %s', trial.blockType), 'center', ptb.center(2)+250, [180 180 180]);
end

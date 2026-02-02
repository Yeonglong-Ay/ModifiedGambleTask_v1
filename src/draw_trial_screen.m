function draw_trial_screen(ptb, trial, params, mode)
    Screen('FillRect', ptb.win, ptb.bgColor);

    cueText = sprintf('Cue: %d (0-10)', trial.probCue);

    safeText = sprintf('SAFE\n$%d', params.money.safeAmount);
    gambleText = sprintf('GAMBLE\n$%d', trial.gambleAmount);

    leftText = safeText; rightText = gambleText;
    if trial.leftIsGamble
        leftText = gambleText; rightText = safeText;
    end

    % positions
    cx = ptb.center(1); cy = ptb.center(2);
    xOffset = 300;

    leftPos  = [cx - xOffset, cy];
    rightPos = [cx + xOffset, cy];

    % draw cue at top
    DrawFormattedText(ptb.win, cueText, 'center', cy - 250, ptb.textColor);

    % draw options
    DrawFormattedText(ptb.win, leftText, leftPos(1)-150, leftPos(2), ptb.textColor);
    DrawFormattedText(ptb.win, rightText, rightPos(1)-150, rightPos(2), ptb.textColor);

    DrawFormattedText(ptb.win, 'Choose with Left/Right arrows', 'center', cy + 250, ptb.textColor);

    if mode == "highlight_choice" && isfield(trial,'choice')
        if trial.choice == "left"
            Screen('FrameRect', ptb.win, [0 255 0], CenterRectOnPoint([0 0 350 220], leftPos(1), leftPos(2)+40), 4);
        elseif trial.choice == "right"
            Screen('FrameRect', ptb.win, [0 255 0], CenterRectOnPoint([0 0 350 220], rightPos(1), rightPos(2)+40), 4);
        end
    end
end

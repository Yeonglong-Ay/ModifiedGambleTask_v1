function draw_fixation(ptb, symbol)
    Screen('FillRect', ptb.win, ptb.bgColor);
    DrawFormattedText(ptb.win, symbol, 'center', 'center', ptb.textColor);
end

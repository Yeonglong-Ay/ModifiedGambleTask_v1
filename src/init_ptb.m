function [ptb, io] = init_ptb(params)
    Screen('Preference','SkipSyncTests', 1); % Set to 0 for real experiments

    screens = Screen('Screens');
    if params.screen.screenId == -1
        screenId = max(screens);
    else
        screenId = params.screen.screenId;
    end

    [win, winRect] = Screen('OpenWindow', screenId, params.screen.bgColor);
    Screen('TextSize', win, params.screen.textSize);
    Screen('TextFont', win, 'Arial');

    HideCursor;
    Priority(MaxPriority(win));

    if params.useKbQueue
        KbQueueCreate;
        KbQueueStart;
    end

    ptb.win = win;
    ptb.winRect = winRect;
    ptb.ifi = Screen('GetFlipInterval', win);
    ptb.center = [RectCenter(winRect)];
    ptb.textColor = params.screen.textColor;
    ptb.bgColor = params.screen.bgColor;

    io = struct();
    io.startTime = GetSecs;
end

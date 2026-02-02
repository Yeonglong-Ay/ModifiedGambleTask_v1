function [choice, rt, aborted] = collect_choice(params, tStart, timeoutSec)
    choice = "none";
    rt = NaN;
    aborted = false;

    while (GetSecs - tStart) < timeoutSec
        [down, ~, keyCode] = KbCheck;
        if down
            if keyCode(params.keys.quitCode)
                aborted = true;
                return;
            elseif keyCode(params.keys.leftCode)
                choice = "left";
                rt = GetSecs - tStart;
                return;
            elseif keyCode(params.keys.rightCode)
                choice = "right";
                rt = GetSecs - tStart;
                return;
            end
        end
    end

    % timeout: treat as no response; caller can decide what to do
    choice = "none";
    rt = NaN;
end

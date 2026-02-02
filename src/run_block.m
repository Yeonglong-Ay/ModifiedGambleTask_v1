function [dataTable, eventsTable] = run_block(ptb, params, trials, blockLabel)
    nTrials = numel(trials);

    data = [];
    events = [];

    % State for streak enforcement (within this block run)
    state = struct();
    state.blockLabel = blockLabel;
    state.currentStreakType = "none";  % "win" or "loss" or "none"
    state.streakRemaining = 0;
    state.lastOutcome = "none";
    state.trialCount = 0;

    send_trigger(ptb.trig, params.triggers.codes.block_start);
    for t = 1:nTrials
        state.trialCount = t;

        % Decide whether to enforce outcome on this trial (only affects gamble choices)
        [trials(t), state] = enforce_streak_logic(params, trials(t), state);

        [trialResult, trialEvents] = run_trial(ptb, params, trials(t));

        % Update state based on realized outcome (only meaningful if gambled)
        if trialResult.choseGamble
            state.lastOutcome = trialResult.outcome; % "win"|"loss"
            if trialResult.outcome == "win"
                if state.currentStreakType == "win"
                    % continue
                else
                    state.currentStreakType = "win";
                    state.streakRemaining = 0;
                end
            else
                if state.currentStreakType == "loss"
                    % continue
                else
                    state.currentStreakType = "loss";
                    state.streakRemaining = 0;
                end
            end
        else
            state.lastOutcome = "safe";
        end

        data = [data; trialResult]; %#ok<AGROW>
        events = [events; trialEvents]; %#ok<AGROW>

        % ITI
        DrawFormattedText(ptb.win, '', 'center','center', ptb.textColor);
        Screen('Flip', ptb.win);
        WaitSecs(params.timing.itiSec);
    end
    send_trigger(ptb.trig, params.triggers.codes.block_end);
    
    dataTable = struct2table(data);
    eventsTable = struct2table(events);
end

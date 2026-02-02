function [trial, state] = enforce_streak_logic(params, trial, state)
% Implements:
% - Neutral: no enforcement
% - Loss-heavy: enforce long loss streaks (4–6) on gamble trials
% - Win-heavy: enforce long win streaks (4–6) on gamble trials
% Enforcement is preferentially applied when probCue == enforcementProbCueTarget (default 5 => 50%).

    trial.forceOutcome = "none";
    trial.enforcementApplied = false;

    if ~params.blocks.enforceStreaks
        return;
    end

    bt = string(trial.blockType);

    if bt == "neutral"
        return;
    end

    % Only attempt enforcement on target probability cue (naturalistic constraint)
    if trial.probCue ~= params.blocks.enforcementProbCueTarget
        return;
    end

    % Only a subset of post-loss trials get stim in your text; here we just mimic an "enforcement rate"
    if rand > params.blocks.enforcementRatePostLossTrial
        return;
    end

    % If we are in the middle of enforcing a streak, continue it.
    if state.streakRemaining > 0
        if state.currentStreakType == "win"
            trial.forceOutcome = "force_win";
            trial.enforcementApplied = true;
            state.streakRemaining = state.streakRemaining - 1;
        elseif state.currentStreakType == "loss"
            trial.forceOutcome = "force_loss";
            trial.enforcementApplied = true;
            state.streakRemaining = state.streakRemaining - 1;
        end
        return;
    end

    % Otherwise, start a new enforced streak depending on block type
    longLo = params.blocks.streakLongRange(1);
    longHi = params.blocks.streakLongRange(2);
    L = randi([longLo, longHi]);

    if bt == "loss_heavy"
        state.currentStreakType = "loss";
        state.streakRemaining = L;
        trial.forceOutcome = "force_loss";
        trial.enforcementApplied = true;
        state.streakRemaining = state.streakRemaining - 1;
    elseif bt == "win_heavy"
        state.currentStreakType = "win";
        state.streakRemaining = L;
        trial.forceOutcome = "force_win";
        trial.enforcementApplied = true;
        state.streakRemaining = state.streakRemaining - 1;
    end
end

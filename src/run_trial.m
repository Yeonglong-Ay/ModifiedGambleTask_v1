function [result, events] = run_trial(ptb, params, trial)
    events = [];

    t0 = GetSecs;

    % Fixation
    draw_fixation(ptb, '+');
    vbl = Screen('Flip', ptb.win);
    send_trigger(ptb.trig, params.triggers.codes.fix_on);
    events = [events; log_event('fix_on', vbl, trial)];
    WaitSecs(params.timing.fixationSec);

    % Game presentation screen
    draw_trial_screen(ptb, trial, params, "show_options");
    vbl = Screen('Flip', ptb.win);
    send_trigger(ptb.trig, params.triggers.codes.fix_on);
    events = [events; log_event('options_on', vbl, trial)];
    WaitSecs(params.timing.gamePresentationSec);

    % Decision window: collect response
    decisionOnset = GetSecs;
    [choice, rt, aborted] = collect_choice(params, decisionOnset, params.timing.decisionTimeoutSec);

    if aborted
        sca; error('Task aborted (ESC).');
    end

    % Immediately after choice, keep options on screen but highlight choice (optional)
    trial.choice = choice;
    draw_trial_screen(ptb, trial, params, "highlight_choice");
    vbl = Screen('Flip', ptb.win);
    events = [events; log_event('choice_made', vbl, trial)];

    % Wait until outcome reveal time (550ms post-choice)
    WaitSecs(params.timing.postChoiceDelayToOutcomeSec);

    % Determine outcome if gamble chosen
    choseGamble = false;
    if choice == "left"
        send_trigger(ptb.trig, params.triggers.codes.choice_left);
    elseif choice == "right"
        send_trigger(ptb.trig, params.triggers.codes.choice_right);
    else
        send_trigger(ptb.trig, params.triggers.codes.choice_none);
    end

    outcome = "safe";
    n1 = trial.probCue;
    n2 = NaN;
    win = NaN;

    if choseGamble
        % produce second integer and compute win/loss.
        % No ties allowed, so sample from 0..10 excluding n1.
        candidates = 0:10;
        candidates(candidates == n1) = [];
        n2raw = candidates(randi(numel(candidates)));

        % Apply enforcement (only affects gamble outcomes)
        if string(trial.forceOutcome) == "force_win"
            if n2raw <= n1
                % resample until win
                while n2raw <= n1
                    n2raw = candidates(randi(numel(candidates)));
                end
            end
        elseif string(trial.forceOutcome) == "force_loss"
            if n2raw > n1
                % resample until loss
                while n2raw > n1
                    n2raw = candidates(randi(numel(candidates)));
                end
            end
        end

        n2 = n2raw;
        win = (n2 > n1);

        if win
            outcome = "win";
        else
            outcome = "loss";
        end
    end

    % Outcome screen
    draw_outcome_screen(ptb, trial, params, choseGamble, n2, outcome);
    vbl = Screen('Flip', ptb.win);
    send_trigger(ptb.trig, params.triggers.codes.outcome_on);
    
    if ~choseGamble
        send_trigger(ptb.trig, params.triggers.codes.safe_chosen);
    else
        if outcome == "win"
            send_trigger(ptb.trig, params.triggers.codes.outcome_win);
        elseif outcome == "loss"
            send_trigger(ptb.trig, params.triggers.codes.outcome_loss);
        end
    end
    events = [events; log_event('outcome_on', vbl, trial)];

    payout = NaN;
    
    if ~choseGamble
        payout = params.money.safeAmount;          % always $10 [1]
    else
        if win
            payout = trial.gambleAmount;           % $15-$30
        else
            payout = params.money.gambleLossAmount; % $0 (your choice)
        end
    end
    
    result.payout = payout;
    
    % Keep outcome visible for a short moment; your doc specifies outcome reveal timing,
    % not the duration. We'll show it briefly (e.g., 0.55s) to match "feedback epoch".
    WaitSecs(0.55);

    % Build result struct
    result = struct();
    result.taskTime0 = t0;
    result.session = getfield_safe(trial,'session',NaN);
    result.blockIndex = getfield_safe(trial,'blockIndex',NaN);
    result.blockType = string(trial.blockType);

    result.trialIndex = trial.trialIndex;
    result.probCue = trial.probCue;
    result.winProb = trial.winProb;
    result.gambleAmount = trial.gambleAmount;
    result.safeAmount = trial.safeAmount;
    result.leftIsGamble = trial.leftIsGamble;

    result.choice = choice;
    result.rtSec = rt;
    result.choseGamble = choseGamble;

    result.n1 = n1;
    result.n2 = n2;
    result.outcome = string(outcome);
    result.win = win;

    result.forceOutcome = string(trial.forceOutcome);
    result.enforcementApplied = trial.enforcementApplied;
end

function v = getfield_safe(s, fname, defaultVal)
    if isfield(s, fname)
        v = s.(fname);
    else
        v = defaultVal;
    end
end

function design = make_design(params, mode)
% Returns either:
% - practice: a struct array of trials
% - main: a cell array {session} where each session is a struct array of trials (with blocks)

    if mode == "practice"
        n = params.design.nPracticeTrials;
        design = make_trials(params, n, "neutral");
        return;
    end

    % Main: build sessions; each session has trialsPerSession spread across block types
    nSessions = params.design.nSessions;
    tps = params.design.trialsPerSession;
    blockTypes = string(params.blocks.blockTypes);
    nBlocks = numel(blockTypes);

    trialsPerBlock = floor(tps / nBlocks);
    leftover = tps - trialsPerBlock*nBlocks;

    design = cell(nSessions,1);
    for s = 1:nSessions
        blockOrder = blockTypes;
        if params.blocks.orderMode == "random"
            blockOrder = blockOrder(randperm(nBlocks));
        end

        sessionTrials = [];
        for b = 1:nBlocks
            nThis = trialsPerBlock + (b <= leftover);
            bt = blockOrder(b);
            blockTrials = make_trials(params, nThis, bt);
            % annotate
            for k = 1:numel(blockTrials)
                blockTrials(k).session = s;
                blockTrials(k).blockType = char(bt);
                blockTrials(k).blockIndex = b;
            end
            sessionTrials = [sessionTrials, blockTrials]; %#ok<AGROW>
        end
        design{s} = sessionTrials;
    end
end

function trials = make_trials(params, nTrials, blockType)
    cueVals = params.design.probCueValues(:)';
    trials = repmat(struct(), 1, nTrials);

    for t = 1:nTrials
        cue = cueVals(randi(numel(cueVals))); % uniform sampling
        gambleAmt = sample_gamble_amount(params);

        % Randomize left/right mapping per trial
        if rand < 0.5
            leftIsGamble = true;
        else
            leftIsGamble = false;
        end

        trials(t).trialIndex = t;
        trials(t).blockType = char(blockType);

        trials(t).probCue = cue;                 % 0..10 shown to subject
        trials(t).winProb = compute_winprob_from_cue(cue); % derived
        trials(t).gambleAmount = gambleAmt;
        trials(t).safeAmount = params.money.safeAmount;

        trials(t).leftIsGamble = leftIsGamble;

        % Placeholders for enforcement outcome control
        trials(t).forceOutcome = "none"; % "none" | "force_win" | "force_loss"
        trials(t).enforcementApplied = false;
    end
end

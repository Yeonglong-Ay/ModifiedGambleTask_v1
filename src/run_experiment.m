function run_experiment(ptb, io, params, subjId)
    sessionStamp = datestr(now,'yyyymmdd_HHMMSS');
    outDir = fullfile('data', ['sub-' subjId], ['ses-' sessionStamp]);
    if ~exist(outDir, 'dir'), mkdir(outDir); end

    % Save params used
    fid = fopen(fullfile(outDir,'params.json'),'w');
    fwrite(fid, jsonencode(params, 'PrettyPrint', true));
    fclose(fid);

    % Welcome
    DrawFormattedText(ptb.win, ...
        'Welcome.\n\nChoose SAFE ($10) or GAMBLE ($15-$30).\n\nPress any key to start practice.', ...
        'center','center', ptb.textColor);
    Screen('Flip', ptb.win);
    KbStrokeWait;

    % Make designs
    practiceDesign = make_design(params, "practice");
    mainDesign = make_design(params, "main");

    % Run practice
    [practiceData, practiceEvents] = run_block(ptb, params, practiceDesign, "practice");
    save_data(outDir, "practice", practiceData, practiceEvents);

    % Instructions
    DrawFormattedText(ptb.win, ...
        'Practice complete.\n\nNow the main task begins.\n\nPress any key.', ...
        'center','center', ptb.textColor);
    Screen('Flip', ptb.win);
    KbStrokeWait;

    allData = table();
    allEvents = table();

    for s = 1:params.design.nSessions
        [sessionData, sessionEvents] = run_block(ptb, params, mainDesign{s}, sprintf("session_%02d", s));
        allData = [allData; sessionData]; %#ok<AGROW>
        allEvents = [allEvents; sessionEvents]; %#ok<AGROW>

        DrawFormattedText(ptb.win, sprintf('Session %d/%d complete.\n\nPress any key.', s, params.design.nSessions), ...
            'center','center', ptb.textColor);
        Screen('Flip', ptb.win);
        KbStrokeWait;
    end

    save_data(outDir, "main", allData, allEvents);

    DrawFormattedText(ptb.win, 'Done.\n\nThank you!', 'center','center', ptb.textColor);
    Screen('Flip', ptb.win);
    WaitSecs(1.0);
end

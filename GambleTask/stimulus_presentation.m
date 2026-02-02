function stimulus_presentation(task_params)
    % Present the stimulus (safe bet or gamble option)
    screen('Prepare', task_params.win_probability, task_params.gamble_risk);
    screen('Flip', task_params.win_probability, task_params.gamble_risk);
    
    % Wait for the participant's response
    [keyIsDown, ~, ~] = KbCheck();
    while ~keyIsDown
        WaitSecs(0.1);
        [keyIsDown, ~, ~] = KbCheck();
    end
    
    % Get the participant's response
    response = KbName(keyIsDown);
    
    % Return the participant's response
    return response;
end

function task_setup()
    % Initialize task parameters
    win_probability = 0.5;  % win probability for each trial
    gamble_risk = 0.2;      % gamble risk for each trial
    trial_duration = 4;     % trial duration in seconds
    
    % Save task parameters to a struct
    task_params = struct('win_probability', win_probability, ...
                         'gamble_risk', gamble_risk, ...
                         'trial_duration', trial_duration);
    
    % Return the task parameters
    return task_params;
end

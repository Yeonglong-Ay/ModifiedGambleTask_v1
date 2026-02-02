function main()
    % Initialize task parameters
    task_params = task_setup();
    
    % Present the stimulus (safe bet or gamble option)
    response = stimulus_presentation(task_params);
    
    % Collect the participant's response (button press or keyboard input)
    response = response_collection(response);
    
    % Perform time-frequency analysis
    [freq, time, power] = time_frequency_analysis(response);
    
    % Analyze power modulations in different frequency bands
    [freq_band, power_modulation] = power_modulation_analysis(power);
    
    % Perform regression analysis
    beta = regression_analysis(response);
    
    % Generate plots of the results
    plot_results(freq, time, power, power_modulation, beta);
    
    % Return the results
    return;
end

function time_frequency_analysis(data)
    % Perform time-frequency analysis
    [freq, time, power] = ft_freqanalysis(data, 'freqrange', [1 40], ...
                                          'timestep', 0.01, 'padratio', 2);
    
    % Return the time-frequency analysis results
    return freq, time, power;
end

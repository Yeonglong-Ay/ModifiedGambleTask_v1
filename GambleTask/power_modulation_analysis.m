function power_modulation_analysis(power)
    % Analyze power modulations in different frequency bands
    [freq_band, power_modulation] = ft_poweranalysis(power, 'freqrange', [1 40]);
    
    % Return the power modulation analysis results
    return freq_band, power_modulation;
end

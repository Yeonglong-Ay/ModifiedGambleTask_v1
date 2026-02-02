function plot_results(freq, time, power, power_modulation, beta)
    % Generate plots of the results
    figure;
    subplot(2, 2, 1);
    imagesc(freq, time, power);
    title('Time-Frequency Analysis');
    
    subplot(2, 2, 2);
    plot(freq_band, power_modulation);
    title('Power Modulation Analysis');
    
    subplot(2, 2, 3);
    plot(beta);
    title('Regression Analysis');
    
    % Return the plot
    return;
end

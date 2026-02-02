function regression_analysis(data)
    % Perform regression analysis
    [beta, ~, ~] = ft_regress(data, 'regressors', {'win_probability', 'gamble_risk'});
    
    % Return the regression analysis results
    return beta;
end

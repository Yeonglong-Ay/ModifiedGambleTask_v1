function amt = sample_gamble_amount(params)
    lo = params.money.gambleMin;
    hi = params.money.gambleMax;
    amt = randi([lo, hi]);
end

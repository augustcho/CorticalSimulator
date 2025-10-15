function plot_alpha_behavior_results(results, config, varargin)
%PLOT_ALPHA_BEHAVIOR_RESULTS Plot RT and response rate vs alpha power.

p = inputParser;
addParameter(p, 'compareStudies', false, @islogical);
parse(p, varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6;
linewidth2 = 2;

n_idx = length(results.alpha_level);
val_idx = round(n_idx/2-5):round(n_idx/2+5);

xalpha = results.alpha_level.^2 / max(results.alpha_level.^2);

% ---- Response rate ----
figure;
simX = zscore(xalpha(val_idx));
simY = zscore(results.response_rate(val_idx));

plot(simX, simY, ...
    'LineWidth', linewidth1, 'DisplayName','Cortical Simulator');
ylabel('Normalized Response Rate'); xlabel('Normalized Alpha Power');
set(gca,'FontSize',20,'LineWidth',linewidth2); box off; hold on;

if compareStudies
    load vanDijk2008 % provides variable 'hit_rates'
    x_van = linspace(0,1,length(hit_rates));
    y_van = hit_rates;

    plot(zscore(x_van), zscore(y_van), ...
        'LineWidth', linewidth2, 'DisplayName','van Dijk 2008');

    % ---- Correlation ----
    [r_van, p_van] = corr_btw_study(simX, simY, ...
                                    zscore(x_van), ...
                                    zscore(y_van));
    fprintf('van Dijk 2008: r = %.3f, p = %.3g\n', r_van, p_van);
end

legend show;

end

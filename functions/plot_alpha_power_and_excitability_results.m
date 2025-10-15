function plot_alpha_power_and_excitability_results(results, config, varargin)
% Plot relationship between alpha power and excitability
%   plot_alpha_results(results, config)
%   plot_alpha_results(results, config, 'compareStudies', true)

% Parse optional input
p = inputParser;
addParameter(p, 'compareStudies', false, @islogical);
parse(p, varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6;
linewidth2 = 2;

figure;
plot(zscore(config.alpha_level), zscore(results.alpha_bin_avg), ...
    'LineWidth', linewidth1, 'DisplayName', 'Cortical Simulator');
hold on;

if compareStudies
    % load published study data
    load Haegens2011NFavg
    load Haegens2011NFstd
    load Potes2014
    load Schalk2017
    
    n_bins = length(Haegens2011NF);
    Haegens_xaxis = linspace(0+.1, 1-.1, n_bins);
    
    % Plot published data
    plot(zscore(Haegens_xaxis), zscore(Haegens2011NF), ...
        'LineWidth', linewidth2, 'DisplayName', 'Haegens 2011');
    plot(zscore(PotesX), zscore(PotesY), ...
        'LineWidth', linewidth2, 'DisplayName', 'Potes 2009');
    plot(zscore(SchalkPowerX), zscore(SchalkPowerY), ...
        'LineWidth', linewidth2, 'DisplayName', 'Schalk 2017');
    
    % ----- Compute correlations -----
    simX = zscore(config.alpha_level(:));
    simY = zscore(results.alpha_bin_avg(:));

    % Haegens
    Haegens_xaxis = linspace(0+.1, 1-.1, length(Haegens2011NF));
    [R_haegens, P_haegens] = corr_btw_study(simX, simY, ...
        zscore(Haegens_xaxis), ...
        zscore(Haegens2011NF));
    fprintf('Haegens 2011: r = %.3f, p = %.3g\n', R_haegens, P_haegens);

    % Potes
    [R_potes, P_potes] = corr_btw_study(simX, simY, ...
        zscore(PotesX), ...
        zscore(PotesY));
    fprintf('Potes 2009: r = %.3f, p = %.3g\n', R_potes, P_potes);

    % Schalk
    [R_schalk, P_schalk] = corr_btw_study(simX, simY, ...
        zscore(SchalkPowerX), ...
        zscore(SchalkPowerY));
    fprintf('Schalk 2017: r = %.3f, p = %.3g\n', R_schalk, P_schalk);

end

xlabel('\alpha Power');
ylabel('Cortical Excitability');
title('Alpha Power vs Cortical Excitability');
legend show;
set(gca,'FontSize',20,'LineWidth',linewidth2);
grid off;
box off;

end

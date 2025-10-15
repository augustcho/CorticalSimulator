clear; clc; close all;

config = config_hit_rate_low_alpha();
results = simulate_hit_rate_low_alpha(config);

% Plot with comparison
plot_hit_rate_low_alpha_results(results, 'compareStudies', true);

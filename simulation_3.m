clear; clc;

% Load config
config = config_alpha_behavior();

% Run simulation
results = simulate_alpha_behavior(config);

% Plot results
plot_alpha_behavior_results(results, config, 'compareStudies', true);

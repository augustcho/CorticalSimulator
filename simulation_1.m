clear; clc;

% Load configuration
config = config_alpha_power_and_excitability();

% Run simulation
results = simulate_alpha_power_and_excitability(config);

% Plot results
plot_alpha_power_and_excitability_results(results, config, 'compareStudies', true);

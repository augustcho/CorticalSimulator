clear; clc;

config = config_alpha_phase_and_excitability();
results = simulate_alpha_phase_and_excitability(config);

%  plot
plot_alpha_phase_and_excitability_results(results, config, 'compareStudies', true);

clear; clc;

config = config_alpha_frequency_and_RT();
results = simulate_alpha_frequency_and_RT(config);


% 
plot_alpha_frequency_results_and_RT(results, 'compareStudies', true);

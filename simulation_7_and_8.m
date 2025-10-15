clear; clc; close all;

config = config_intensity();
results = simulate_intensity(config);

% Plot with comparison
plot_intensity_results(results,'compareStudies',true);

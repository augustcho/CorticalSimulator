clear; clc; close all;

config = config_bimodal();
results = simulate_bimodal(config);

plot_bimodal_results(results);

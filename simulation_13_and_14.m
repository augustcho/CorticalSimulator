clear; clc; close all;

config = config_incongruent();
results = simulate_incongruent(config);

plot_incongruent_results(results);

clear; clc; close all;

config = config_duration();
results = simulate_duration(config);

plot_duration_results(results,'compareStudies',true);

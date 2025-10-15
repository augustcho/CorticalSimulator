clear; clc;

config = config_weber();
results = simulate_weber(config);

plot_weber_results(results);

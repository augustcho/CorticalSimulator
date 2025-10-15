Cortical Simulator v1
=====================

A MATLAB-based package for simulating cortical responses under various experimental conditions.  
It generates behavioral metrics such as reaction time and hit rate, as well as neural activity measures, and provides visualization tools.

--------------------------------------------------------------------------------


How to Run
----------
1. Open the package in MATLAB and add it to the path:
   addpath(genpath(pwd));

2. Run any simulation script, for example:
   simulation_1
   simulation_13_and_14

3. Results will be stored in the 'results' structure and automatically plotted.

--------------------------------------------------------------------------------

Key Functions (for example, simulation_13_and_14.m )
-------------
- config_incongruent.m
  Defines configuration for incongruent condition simulations.

- simulate_incongruent.m
  Runs the simulation based on the given configuration.

- plot_incongruent_results.m
  Plots behavioral and neural outcomes from the 'results' structure.

--------------------------------------------------------------------------------

Example Usage
-------------
clear; clc; close all;

config = config_incongruent();         % Configure simulation
results = simulate_incongruent(config); % Run simulation
plot_incongruent_results(results);      % Plot results

--------------------------------------------------------------------------------

Requirements
------------
- MATLAB R2022a or later (recommended)
- Statistics and Machine Learning Toolbox (for some analyses)

--------------------------------------------------------------------------------

Notes
-----
- This package is intended for research and educational purposes in simulating cortical network responses.  
- Suitable for use in publications, class projects, or as teaching material.

--------------------------------------------------------------------------------

Contact
-------
- Maintainer: Hohyun Cho  
- Email: hohyun6160@uabmc.edu / cho@neurotechcenter.org
- Institution: University of Alabama at Birmingham (UAB)

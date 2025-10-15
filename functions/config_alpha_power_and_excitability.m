function config = config_alpha_power_and_excitability()
%CONFIG_ALPHA Return configuration parameters for alpha power simulation.
%
% Example:
%   config = config_alpha();
%   simulate_alpha_power(config);

%% Simulation parameters
config.parameters.srate = 400;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];         % Alpha band
config.end_sec = 800;                % Simulation length in seconds
config.stim_duration = 40;           % Stimulus duration in samples
config.stimulus_intensity = 100;     % Input amplitude
config.background_noise_intensity = 10;

%% Sweep variable
config.alpha_level = 50:5:200;       % Oscillation amplitude sweep

end

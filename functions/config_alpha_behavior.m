function config = config_alpha_behavior()
%CONFIG_ALPHA_BEHAVIOR Return configuration for alpha-behavior simulation.

%% Simulation parameters
config.parameters.srate = 400;
config.parameters.threshold_vol = 0;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];           % alpha band
config.end_sec = 204;                  % simulation length
config.stimulus_intensity = 100;       % input amplitude
config.stim_duration = 40;             % samples
config.background_noise_intensity = 10;

%% Sweep variable
config.alpha_level = 50:5:200;         % oscillation amplitude sweep

%% Network latency
config.lantency_btw_ctx = 10;

end

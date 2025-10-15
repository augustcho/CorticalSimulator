function config = config_hit_rate_high_alpha()
%CONFIG_ALPHA_PHASE_HIGH Configuration for high-alpha phase vs hit rate simulation

%% Parameters
config.parameters.srate = 400;
config.parameters.threshold_vol = 0;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];
config.end_sec = 204;
config.stimulus_intensity = 100;
config.stim_duration = 40; % samples
config.alpha_level = 100:5:200;
config.background_noise_intensity = 10;
config.lantency_btw_ctx = 10;

%% Phase binning
config.n_repeats = 100;
config.bin_steps = pi/10;
config.pbin_idx = -pi:config.bin_steps:pi;

end

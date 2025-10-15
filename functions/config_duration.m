function config = config_duration()
%CONFIG_DURATION Configuration for stimulus duration simulation

%% Parameters
config.parameters.srate = 400;
config.parameters.output_threshold = 0;
config.parameters.bias_r = 1;
config.parameters.bba_magnitude = 100;
config.parameters.osc_amp = 100;
config.parameters.ctx_buffer = 2.5;
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];
config.end_sec = 204;
config.stimulus_intensity = 100;   % fixed
config.background_noise_intensity = 30;
config.stim_durations = [1 4:4:16 19];  % samples
config.n_repeats = 30;
config.lantency_btw_ctx = 10;

end

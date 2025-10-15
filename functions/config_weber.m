function config = config_weber()
%CONFIG_WEBER Configuration for Weber fraction simulation

%% Parameters
config.parameters.srate = 400;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.osc_amp = 100;
config.parameters.ctx_buffer = 2.5;
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];
config.end_sec = 404;
config.stimulus_intensities = 5:100;   % intensity range
config.background_noise_intensity = 10;
config.stim_duration = 40;             % samples
config.lantency_btw_ctx = 10;

end

function config = config_bimodal()
%CONFIG_BIMODAL Configuration for uni- vs bimodal simulation

%% Parameters
config.parameters.srate = 400;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.osc_amp = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];
config.end_sec = 204;
config.stimulus_intensity = 80;
config.stim_duration = 40;              % samples
config.background_noise_intensity = 10;
config.lantency_btw_ctx = 10;
config.n_conditions = 3;                % 1=V, 2=A, 3=V+A

end

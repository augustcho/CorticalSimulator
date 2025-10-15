function config = config_incongruent()
%CONFIG_INCONGRUENT Configuration for congruent vs incongruent simulation

%% Parameters
config.parameters.srate = 400;
config.parameters.threshold_vol = 0;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.osc_amp = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];
config.end_sec = 204;
config.stimulus_intensity = 100;
config.stim_duration = 40;              % samples
config.background_noise_intensity = 10;
config.lantency_btw_ctx = 10;
config.n_repeats = 10;                  % 반복 횟수
config.n_conditions = 2;                % 1=Congruent, 2=Incongruent

end

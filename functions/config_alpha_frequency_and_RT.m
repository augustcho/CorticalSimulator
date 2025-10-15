function config = config_alpha_frequency_and_RT()
%CONFIG_ALPHA_FREQUENCY Return configuration for alpha-frequency simulation.

%% Simulation parameters
config.parameters.srate = 400;
config.parameters.normal_voltage = 100;
config.parameters.threshold_vol = 0;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;
config.parameters.osc_amp = 100;

%% Experiment settings
config.osc_hz_list = 8:13;           % sweep frequencies
config.end_sec = 204;                % simulation length
config.stimulus_intensity = 100;     % input amplitude
config.stim_duration = 40;           % samples
config.background_noise_intensity = 10;

%% Network latency
config.lantency_btw_ctx = 10;

%% Repetitions
config.n_reps = 100;                 % number of simulation repetitions

end

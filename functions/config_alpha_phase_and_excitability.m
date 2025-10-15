function config = config_alpha_phase_and_excitability()
%CONFIG_ALPHA_PHASE Return configuration for alpha phase simulation.

%% Simulation parameters
config.parameters.srate = 400;
config.parameters.bias_r = 1;
config.parameters.output_threshold = 0;
config.parameters.bba_magnitude = 100;
config.parameters.ctx_buffer = 2.5; % ms
config.parameters.c_sigmoid = 1;

%% Experiment settings
config.osc_hz_band = [8 12];         % alpha band
config.end_sec = 800;                % simulation length
config.stim_duration = 40;           % samples
config.stimulus_intensity = 100;     % input amplitude
config.background_noise_intensity = 10;

%% Sweep variable
config.alpha_level = 50:5:200;       % oscillation amplitude sweep

%% Phase binning
config.bin_steps = pi/10;            % phase bin width
config.lantency_btw_ctx = 10;        % ms (not used here but kept)

end

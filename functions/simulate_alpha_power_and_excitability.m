function results = simulate_alpha_power_and_excitability(config)

srate = config.parameters.srate;
times = linspace(0, config.end_sec, srate*config.end_sec);
n_tp = length(times);

% Stimulus design
excitatory_input = zeros(1,n_tp);
data_3D = reformsig(excitatory_input', config.end_sec/2);
clean_data_3D = data_3D;

b = 400; a = 100;
for tr = 2:config.end_sec/2-1
    r = a + (b-a).*rand(1);
    tp = round(srate*(r/1000));
    n_tp_in_a_trial = size(data_3D,1);
    data_3D(:,:,tr) = config.background_noise_intensity * abs(randn(1,n_tp_in_a_trial));
    data_3D(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
    clean_data_3D(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
end

excitatory_input1 = reformsig(data_3D)';
excitatory_input = reformsig(clean_data_3D)';

% Results containers
alpha_bin_avg = [];
alpha_bin_std = [];

bin_steps = 0.1;
pbin_idx = -pi:bin_steps:pi;

CTX_idx = 1;
for alpha_iter = 1:length(config.alpha_level)
    n_CTX = 1;
    config.parameters.osc_amp = config.alpha_level(alpha_iter);
    CTX = [];

    % Create cortex
    for iter = 1:n_CTX
        CTX{iter} = cortex();
        rand_hz = 8 + (config.osc_hz_band(2) - config.osc_hz_band(1)) * rand(1);
        CTX{iter}.osc_hz = rand_hz;
        rand_phase_osc = (-pi+2*pi*rand(1))/CTX{iter}.osc_hz;
        rand_envelope = config.parameters.osc_amp * ones(1,length(times));
        CTX{iter}.osc = rand_envelope.*(cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) + config.parameters.bias_r)/2;
    end

    CTX{1}.excitatory_input = excitatory_input1;
    CTX{n_CTX}.compute(config.parameters);

    stim_idx = find(excitatory_input > 0);
    bba_outputs{alpha_iter} = abs(CTX{n_CTX}.bba(stim_idx));

    alpha_bin_avg(alpha_iter) = mean(bba_outputs{alpha_iter},'omitnan');
    alpha_bin_std(alpha_iter) = std(bba_outputs{alpha_iter},'omitnan');

end


% Store results
results.alpha_level   = config.alpha_level;
results.alpha_bin_avg = alpha_bin_avg;
results.alpha_bin_std = alpha_bin_std;
results.pbin_idx      = pbin_idx;

end


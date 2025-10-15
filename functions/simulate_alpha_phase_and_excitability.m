function results = simulate_alpha_phase_and_excitability(config)

srate = config.parameters.srate;
times = linspace(0, config.end_sec, srate*config.end_sec);

% ---- Trigger / Stimulus ----
excitatory_input = zeros(1, length(times));
data_3D = reformsig(excitatory_input', config.end_sec/2);
clean_data_3D = data_3D;

b = 400; a = 100;
for tr = 2:config.end_sec/2-1
    r = a + (b-a).*rand(1);
    tp = round(srate*(r/1000));
    n_tp_in_a_trial = size(data_3D,1);
    data_3D(:,:,tr) = config.background_noise_intensity * abs(randn(1,n_tp_in_a_trial));
    data_3D(tp:tp+config.stim_duration,:,tr) = ...
        data_3D(tp:tp+config.stim_duration,:,tr) + config.stimulus_intensity;
    clean_data_3D(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
end

excitatory_input1 = reformsig(data_3D)';
excitatory_input = reformsig(clean_data_3D)';

% ---- Containers ----
pbin_idx = -pi:config.bin_steps:pi;
phase_bins = cell(length(pbin_idx),1);
CTX_idx = 1;

for alpha_iter = 1:length(config.alpha_level)
    n_CTX = 1;
    config.parameters.osc_amp = config.alpha_level(alpha_iter);

    % Cortex instance
    CTX = {};
    for iter = 1:n_CTX
        CTX{iter} = cortex();
        rand_hz = 8 + (config.osc_hz_band(2)-config.osc_hz_band(1)) * rand(1);
        CTX{iter}.osc_hz = rand_hz;
        rand_phase_osc = (-pi+2*pi*rand(1))/CTX{iter}.osc_hz;
        rand_envelope = config.parameters.osc_amp * ones(1,length(times));
        CTX{iter}.osc = rand_envelope .* ...
            (cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) + config.parameters.bias_r)/2;
    end

    CTX{1}.excitatory_input = excitatory_input1;
    CTX{1}.compute(config.parameters);

    % ---- Phase extraction ----
    alpha_data = butter_bandpass_filtering(CTX{CTX_idx}.osc - config.parameters.bias_r', ...
                                           config.parameters.srate, config.osc_hz_band, 4);
    alpha_phase = angle(hilbert(alpha_data));
    alpha_phase2 = alpha_phase(srate:end-srate+1);
    bba_power = abs(CTX{CTX_idx}.bba');
    bba_power2 = bba_power(srate:end-srate+1);

    event_idx = find(excitatory_input(srate:end-srate+1) > 0);

    % ---- Phase binning ----
    edges = -pi:config.bin_steps:pi;
    [~,~,bin] = histcounts(alpha_phase2, edges);

    for k = 1:numel(edges)-1
        tmp_idx = find(bin==k);
        act_idxs = intersect(tmp_idx, event_idx);
        vals = bba_power2(act_idxs);
        phase_bins{k} = [phase_bins{k}, vals'];
    end
end

% ---- Compute stats ----
for bin_itr = 1:length(phase_bins)
    phase_bin_avg(bin_itr,CTX_idx) = mean(phase_bins{bin_itr},'omitnan');
    phase_bin_std(bin_itr,CTX_idx) = std(phase_bins{bin_itr},'omitnan');
    phase_bin_num(bin_itr,CTX_idx) = numel(phase_bins{bin_itr});
end

% ---- Return results ----
results.alpha_level   = config.alpha_level;
results.pbin_idx      = pbin_idx;
results.phase_bin_avg = phase_bin_avg;
results.phase_bin_std = phase_bin_std;
results.phase_bin_num = phase_bin_num;

end

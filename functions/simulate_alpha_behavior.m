function results = simulate_alpha_behavior(config)
%SIMULATE_ALPHA_BEHAVIOR Run alpha-behavior simulation (RT & response rate).

srate = config.parameters.srate;
times = linspace(0, config.end_sec, srate*config.end_sec);
n_tp = length(times);

m_rts = nan(1,length(config.alpha_level));
s_rts = nan(1,length(config.alpha_level));
response_rate = nan(1,length(config.alpha_level));

for alpha_iter = 1:length(config.alpha_level)
    config.parameters.osc_amp = config.alpha_level(alpha_iter);

    % ---- Trigger / Stimulus ----
    excitatory_input = zeros(1,n_tp);
    data_3D = reformsig(excitatory_input', config.end_sec/2);
    data_3D_real = data_3D;
    b = 400; a = 200; noise_range = 1:400;

    for tr = 2:config.end_sec/2-1
        r = a + (b-a).*rand(1);
        tp = round(srate*(r/1000));
        data_3D(noise_range,:,tr) = ...
            config.background_noise_intensity * abs(randn(1,length(noise_range)));
        data_3D(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
        data_3D_real(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
    end

    excitatory_input1 = reformsig(data_3D)';
    excitatory_input1_real = reformsig(data_3D_real)';

    % ---- Cortex network ----
    CTX = {};
    for iter = 1:13
        CTX{iter} = cortex();
        rand_hz = 8 + (config.osc_hz_band(2)-config.osc_hz_band(1))*rand(1);
        CTX{iter}.osc_hz = rand_hz;
        rand_phase_osc = (-pi+2*pi*1)/CTX{iter}.osc_hz;
        rand_envelope = config.parameters.osc_amp * ones(1,length(times));
        CTX{iter}.osc = rand_envelope .* ...
            (cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) + config.parameters.bias_r)/2;
    end

    % Visual chain
    CTX{1}.insertAfter(CTX{2}, config.lantency_btw_ctx);
    CTX{2}.insertAfter(CTX{3}, config.lantency_btw_ctx);
    CTX{3}.insertAfter(CTX{7}, config.lantency_btw_ctx);

    % Auditory chain
    CTX{4}.insertAfter(CTX{5}, config.lantency_btw_ctx);
    CTX{5}.insertAfter(CTX{6}, config.lantency_btw_ctx);
    CTX{6}.insertAfter(CTX{7}, config.lantency_btw_ctx);

    % Visuo-audio
    CTX{7}.insertAfter(CTX{8}, config.lantency_btw_ctx);
    CTX{8}.insertAfter(CTX{9}, config.lantency_btw_ctx);
    CTX{9}.insertAfter(CTX{10}, config.lantency_btw_ctx);

    % Motor
    CTX{10}.insertAfter(CTX{11}, config.lantency_btw_ctx);
    CTX{11}.insertAfter(CTX{12}, config.lantency_btw_ctx);
    CTX{12}.insertAfter(CTX{13}, 25);

    % Axonal delays
    CTX{1}.Prev_edge = axonal_edge(); CTX{1}.Prev_edge.axonal_delay = 60;
    CTX{4}.Prev_edge = axonal_edge(); CTX{4}.Prev_edge.axonal_delay = 18;

    % Assign inputs
    CTX{1}.excitatory_input = excitatory_input1;
    CTX{4}.excitatory_input = zeros(1,n_tp);

    n_CTX = length(CTX);
    CTX{n_CTX}.compute(config.parameters);

    % ---- Reaction time ----
    tmp_idx = find(excitatory_input1_real>0);
    event_idx = setdiff(tmp_idx,tmp_idx+1);
    n_trials = numel(event_idx);

    bba_power = abs(CTX{n_CTX}.bba);
    bba_onset_idx = find(bba_power > config.parameters.output_threshold);

    rt = [];
    for iter = 1:n_trials
        event_sp = event_idx(iter);
        rt_set = bba_onset_idx - event_sp;
        pos_rt_set = rt_set(rt_set > 0);
        if ~isempty(pos_rt_set)
            min_rt = min(pos_rt_set);
            if min_rt < 400
                rt(iter) = min_rt/srate;
            else
                rt(iter) = 0;
            end
        end
    end

    true_rt = rt(rt > 0);
    if ~isempty(true_rt)
        m_rts(alpha_iter) = mean(true_rt);
        s_rts(alpha_iter) = std(true_rt)/sqrt(numel(true_rt));
        response_rate(alpha_iter) = numel(true_rt)/n_trials*100;
    end
end

% ---- Results ----
results.alpha_level   = config.alpha_level;
results.m_rts         = m_rts;
results.s_rts         = s_rts;
results.response_rate = response_rate;

end

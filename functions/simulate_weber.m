function results = simulate_weber(config)
%SIMULATE_WEBER Run cortical simulation for Weber fraction analysis

srate = config.parameters.srate;
times = linspace(0,config.end_sec,srate*config.end_sec);
n_tp = length(times);

m_rts = nan(1,length(config.stimulus_intensities));
s_rts = nan(1,length(config.stimulus_intensities));
response_rate = nan(1,length(config.stimulus_intensities));

for inten_iter = 1:length(config.stimulus_intensities)
    stimulus_intensity = config.stimulus_intensities(inten_iter);

    %% Generate trigger
    excitatory_input = zeros(1,n_tp);
    data_3D = reformsig(excitatory_input',config.end_sec/2);
    data_3D_real = data_3D;
    a=200; b=400; noise_range=1:400;

    for tr = 2:config.end_sec/2-1
        r = a + (b-a).*rand(1);
        tp = round(srate*(r/1000));
        data_3D(noise_range,:,tr) = config.background_noise_intensity*abs(randn(1,length(noise_range)));
        data_3D(tp:tp+config.stim_duration,:,tr) = stimulus_intensity;
        data_3D_real(tp:tp+config.stim_duration,:,tr) = stimulus_intensity;
    end

    excitatory_input1 = reformsig(data_3D)';
    excitatory_input1_real = reformsig(data_3D_real)';

    %% Network setup
    CTX={};
    for iter = 1:13
        CTX{iter} = cortex();
        rand_hz = 8 + diff(config.osc_hz_band)*rand(1);
        CTX{iter}.osc_hz = rand_hz;
        rand_phase_osc = (-pi+2*pi*1)/CTX{iter}.osc_hz;
        CTX{iter}.osc = config.parameters.osc_amp .* ...
            (cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) + config.parameters.bias_r)/2;
    end

    % Connections
    dly = config.lantency_btw_ctx;
    CTX{1}.insertAfter(CTX{2},dly); CTX{2}.insertAfter(CTX{3},dly); CTX{3}.insertAfter(CTX{7},10);
    CTX{4}.insertAfter(CTX{5},dly); CTX{5}.insertAfter(CTX{6},dly); CTX{6}.insertAfter(CTX{7},10);
    CTX{7}.insertAfter(CTX{8},dly); CTX{8}.insertAfter(CTX{9},dly); CTX{9}.insertAfter(CTX{10},10);
    CTX{10}.insertAfter(CTX{11},dly); CTX{11}.insertAfter(CTX{12},dly); CTX{12}.insertAfter(CTX{13},25);

    CTX{1}.Prev_edge = axonal_edge(); CTX{1}.Prev_edge.axonal_delay=60;
    CTX{4}.Prev_edge = axonal_edge(); CTX{4}.Prev_edge.axonal_delay=18;

    CTX{1}.excitatory_input = excitatory_input1;
    CTX{4}.excitatory_input = excitatory_input;

    for iter=1:length(CTX), config.parameters.IDs(iter)=CTX{iter}.ID; end
    CTX{end}.compute(config.parameters);

    %% Events
    tmp_idx = find(excitatory_input1_real>0);
    event_idx = setdiff(tmp_idx,tmp_idx+1);
    n_trials = length(event_idx);

    bba_power = abs((CTX{end}.bba));
    bba_onset_idx = find(bba_power>config.parameters.output_threshold);

    %% Reaction times
    rt = nan(1,n_trials);
    for t = 1:n_trials
        event_sp = event_idx(t);
        rt_set = bba_onset_idx - event_sp;
        pos_rt_set = rt_set(rt_set>0);
        if ~isempty(pos_rt_set)
            min_rt = min(pos_rt_set);
            if min_rt < 400
                rt(t) = min_rt/srate;
            end
        end
    end

    true_rt = rt(~isnan(rt));
    m_rts(inten_iter) = mean(true_rt);
    s_rts(inten_iter) = std(true_rt)/sqrt(length(true_rt));
    response_rate(inten_iter) = length(true_rt)/n_trials*100;
end

%% Save
results.m_rts = m_rts;
results.s_rts = s_rts;
results.response_rate = response_rate;
results.stimulus_intensities = config.stimulus_intensities;
results.stim_duration = config.stim_duration;

end

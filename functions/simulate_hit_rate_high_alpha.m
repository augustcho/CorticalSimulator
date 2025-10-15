function results = simulate_hit_rate_high_alpha(config)
%SIMULATE_ALPHA_PHASE_HIGH Run simulation of hit rates across alpha phase

srate = config.parameters.srate;
times = linspace(0, config.end_sec, srate*config.end_sec);
n_tp = length(times);

phase_bins = cell(length(config.pbin_idx),1);
phase_alpha_table = nan(length(config.pbin_idx), length(config.alpha_level));

for alpha_iter = 1:length(config.alpha_level)
    
    config.parameters.osc_amp = config.alpha_level(alpha_iter);
    fprintf('alpha_level = %d\n',config.parameters.osc_amp);

    for trial_iter = 1:config.n_repeats
        
        %% Stimulus
        excitatory_input = zeros(1,n_tp);
        data_3D = reformsig(excitatory_input', config.end_sec/2);
        data_3D_real = data_3D;
        a = 200; b = 400; noise_range = 1:400;

        for tr = 2:config.end_sec/2-1
            r = a + (b-a).*rand(1);
            tp = round(srate*(r/1000));
            data_3D(noise_range,:,tr) = config.background_noise_intensity * abs(randn(1,length(noise_range)));
            data_3D(tp:tp+config.stim_duration,:,tr) = ...
                data_3D(tp:tp+config.stim_duration,:,tr) + config.stimulus_intensity;
            data_3D_real(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
        end

        excitatory_input1 = reformsig(data_3D)';
        excitatory_input1_real = reformsig(data_3D_real)';

        %% Cortices
        CTX = {};
        for iter = 1:3
            CTX{iter} = cortex();
            rand_hz = 8 + diff(config.osc_hz_band)*rand(1);
            CTX{iter}.osc_hz = rand_hz;
            rand_phase_osc = (-pi+2*pi*1)/CTX{iter}.osc_hz;
            rand_envelope = config.parameters.osc_amp*ones(1,length(times));
            CTX{iter}.osc = rand_envelope.*(cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) ...
                                           + config.parameters.bias_r)/2;
        end

        for iter = 4:13
            CTX{iter} = cortex();
            rand_hz = 8 + diff(config.osc_hz_band)*rand(1);
            CTX{iter}.osc_hz = rand_hz;
            rand_phase_osc = (-pi+2*pi*1)/CTX{iter}.osc_hz;
            rand_envelope = 50*ones(1,length(times)); % fixed envelope
            CTX{iter}.osc = rand_envelope.*(cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase_osc)) ...
                                           + config.parameters.bias_r)/2;
        end

        % Chains
        dly = config.lantency_btw_ctx;
        CTX{1}.insertAfter(CTX{2},dly); CTX{2}.insertAfter(CTX{3},dly); CTX{3}.insertAfter(CTX{7},dly);
        CTX{4}.insertAfter(CTX{5},dly); CTX{5}.insertAfter(CTX{6},dly); CTX{6}.insertAfter(CTX{7},dly);
        CTX{7}.insertAfter(CTX{8},dly); CTX{8}.insertAfter(CTX{9},dly); CTX{9}.insertAfter(CTX{10},dly);
        CTX{10}.insertAfter(CTX{11},dly); CTX{11}.insertAfter(CTX{12},dly); CTX{12}.insertAfter(CTX{13},25);

        % Axonal delays
        CTX{1}.Prev_edge = axonal_edge(); CTX{1}.Prev_edge.axonal_delay = 60;
        CTX{4}.Prev_edge = axonal_edge(); CTX{4}.Prev_edge.axonal_delay = 18;

        % Inputs
        CTX{1}.excitatory_input = excitatory_input1;
        CTX{4}.excitatory_input = zeros(1,n_tp);

        n_CTX = length(CTX);
        for iter = 1:n_CTX, config.parameters.IDs(iter) = CTX{iter}.ID; end
        CTX{n_CTX}.compute(config.parameters);

        %% Event indices
        tmp_idx = find(excitatory_input1_real>0);
        event_idx = setdiff(tmp_idx,tmp_idx+1);

        bba_power = abs((CTX{n_CTX}.bba));
        bba_onset_idx = find(bba_power > config.parameters.output_threshold);

        %% Alpha phase extraction
        alpha_data = butter_bandpass_filtering(CTX{1}.osc - config.parameters.bias_r', ...
                                               config.parameters.srate, config.osc_hz_band, 4);
        alpha_phase = angle(hilbert(alpha_data));

        %% Phase binning
        for bin_itr = 1:length(config.pbin_idx)-1
            low_bound = config.pbin_idx(bin_itr);
            upper_bound = config.pbin_idx(bin_itr) + config.bin_steps;
            iter_idx = find(low_bound <= alpha_phase & alpha_phase < upper_bound);
            event_at_phase_idx = intersect(iter_idx, event_idx);

            rt_at_phase = nan(1,length(event_at_phase_idx));
            for e = 1:length(event_at_phase_idx)
                event_sp = event_at_phase_idx(e);
                rt_set = bba_onset_idx - event_sp;
                pos_rt_set = rt_set(rt_set > 0);
                if ~isempty(pos_rt_set)
                    min_rt = min(pos_rt_set);
                    if min_rt < srate
                        rt_at_phase(e) = min_rt/srate;
                    end
                end
            end

            response_rate = mean(~isnan(rt_at_phase))*100;
            phase_bins{bin_itr} = [phase_bins{bin_itr} response_rate];
            phase_alpha_table(bin_itr,alpha_iter) = response_rate;
        end
    end
end

%% Save results
results.phase_bins = phase_bins;
results.pbin_idx = config.pbin_idx;
results.phase_alpha_table = phase_alpha_table;

end

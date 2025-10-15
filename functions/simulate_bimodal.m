function results = simulate_bimodal(config)
%SIMULATE_BIMODAL Run cortical simulation for uni vs bimodal sensory

srate = config.parameters.srate;
times = linspace(0,config.end_sec,srate*config.end_sec);
n_tp = length(times);

%% Stimulus trigger
excitatory_input = zeros(1,n_tp);
data_3D = reformsig(excitatory_input',config.end_sec/2);
data_3D_real = data_3D;
a=200; b=400; noise_range=1:400;

for tr = 2:config.end_sec/2-1
    r = a + (b-a).*rand(1);
    tp = round(srate*(r/1000));
    data_3D(noise_range,:,tr) = config.background_noise_intensity*abs(randn(1,length(noise_range)));
    data_3D(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
    data_3D_real(tp:tp+config.stim_duration,:,tr) = config.stimulus_intensity;
end

excitatory_input1 = reformsig(data_3D)';
excitatory_input1_real = reformsig(data_3D_real)';

%% Loop over 3 conditions (V, A, V+A)
for stim_iter = 1:config.n_conditions
    % Network setup
    CTX={};
    for iter=1:13
        CTX{iter}=cortex();
        rand_hz = 8 + diff(config.osc_hz_band)*rand(1);
        CTX{iter}.osc_hz = rand_hz;
        rand_phase = (-pi+2*pi*rand(1))/CTX{iter}.osc_hz;
        CTX{iter}.osc = config.parameters.osc_amp .* ...
            (cos(2*pi*CTX{iter}.osc_hz*(times+rand_phase))+config.parameters.bias_r)/2;
    end
    
    % Connections
    dly=config.lantency_btw_ctx;
    CTX{1}.insertAfter(CTX{2},dly); CTX{2}.insertAfter(CTX{3},dly); CTX{3}.insertAfter(CTX{7},dly);
    CTX{4}.insertAfter(CTX{5},dly); CTX{5}.insertAfter(CTX{6},dly); CTX{6}.insertAfter(CTX{7},dly);
    CTX{7}.insertAfter(CTX{8},dly); CTX{8}.insertAfter(CTX{9},dly); CTX{9}.insertAfter(CTX{10},dly);
    CTX{10}.insertAfter(CTX{11},dly); CTX{11}.insertAfter(CTX{12},dly); CTX{12}.insertAfter(CTX{13},25);

    CTX{1}.Prev_edge=axonal_edge(); CTX{1}.Prev_edge.axonal_delay=60;
    CTX{4}.Prev_edge=axonal_edge(); CTX{4}.Prev_edge.axonal_delay=18;

    % Assign excitatory inputs
    if stim_iter==1      % V
        CTX{1}.excitatory_input=excitatory_input1;
        CTX{4}.excitatory_input=excitatory_input;
    elseif stim_iter==2  % A
        CTX{1}.excitatory_input=excitatory_input;
        CTX{4}.excitatory_input=excitatory_input1;
    else                 % V+A
        delay_val=(CTX{1}.Prev_edge.axonal_delay-CTX{4}.Prev_edge.axonal_delay)/1000*srate;
        excitatory_input2=[excitatory_input1(delay_val+1:end) excitatory_input1(1:delay_val)];
        CTX{1}.excitatory_input=excitatory_input2;
        CTX{4}.excitatory_input=excitatory_input1;
    end

    for i=1:length(CTX), config.parameters.IDs(i)=CTX{i}.ID; end
    CTX{end}.compute(config.parameters);

    %% Events
    tmp_idx=find(excitatory_input1_real>0);
    event_idx=setdiff(tmp_idx,tmp_idx+1);
    n_trials=length(event_idx);

    bba_power=abs(CTX{end}.bba);
    bba_onset_idx=find(bba_power>config.parameters.output_threshold);

    rt=nan(1,n_trials);
    for t=1:n_trials
        event_sp=event_idx(t);
        rt_set=bba_onset_idx-1-event_sp;
        pos_rt=rt_set(rt_set>0);
        if ~isempty(pos_rt)
            min_rt=min(pos_rt);
            if min_rt<400
                rt(t)=min_rt/srate;
            end
        end
    end

    true_rt=rt(~isnan(rt));
    m_rt(stim_iter)=mean(true_rt);
    s_rt(stim_iter)=std(true_rt)/sqrt(length(true_rt));
    num_trials(stim_iter)=length(true_rt);
    response_rate(stim_iter)=num_trials(stim_iter)/n_trials*100;
end

%% Output
results.m_rt=m_rt;
results.s_rt=s_rt;
results.response_rate=response_rate;

end

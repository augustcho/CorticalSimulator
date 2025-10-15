classdef cortex < handle
    properties
        ID = 0;
        excitatory_input = [];
        osc = [];
        osc_hz = 0;
        %         bias_r = 0;
        bba = [];
        voltage = [];
        cortical_output = [];
        %         threshold_vol = -2;
        last_activataion_flag = 0;
        last_activation_tp = 0;
        cp_time = 0; % 50ms
        %%
        o_ratio = 0;
        r_ratio = 0;
    end
    properties (SetAccess = public)
        Next = cortex.empty;
        Prev = cortex.empty;
        
        Next_edge = axonal_edge.empty;
        Prev_edge = axonal_edge.empty;
    end
    methods
        function obj = cortex()
            c = clock;
            obj.ID = round(c(6)+rand(1)*10000);
        end
        function r = get_n_next(obj)
            r = length(obj.Next);
        end
        function r = get_n_prev(obj)
            r = length(obj.Prev);
        end
        function r = get_n_next_edge(obj)
            r = length(obj.Next_edge);
        end
        function r = get_n_prev_edge(obj)
            r = length(obj.Prev_edge);
        end
        function insertAfter(obj,new_cortex,axonal_delay)
            % existence check
            n_next = length(obj.Next);
            found_flag = 0;
            for idx = 1:n_next
                if new_cortex.ID == obj.Next(idx).ID
                    found_flag = 1;
                    break;
                end
            end
            
            if found_flag == 1
                disp('ERROR: Input node already exists');
                return;
            end
            
            % insert cortex
            new_cortex.Prev(new_cortex.get_n_prev+1) = obj;
            obj.Next(obj.get_n_next+1) = new_cortex;
            
            % edge part
            new_edge = axonal_edge();
            new_edge.axonal_delay = axonal_delay;
            new_edge.from_cortex = obj;
            new_edge.to_cortex = new_cortex;
            
            new_cortex.Prev_edge(new_cortex.get_n_prev_edge+1) = new_edge;
            obj.Next_edge(obj.get_n_next_edge+1) = new_edge;
            
        end
        function insertPrev(obj,new_cortex,axonal_delay)
            % existence check
            n_prev = length(obj.Prev);
            found_flag = 0;
            for idx = 1:n_prev
                if new_cortex.ID == obj.Prev(idx).ID
                    found_flag = 1;
                    break;
                end
            end
            
            if found_flag == 1
                disp('ERROR: Input node already exists');
                return;
            end
            
            % insert cortex
            new_cortex.Next(new_cortex.get_n_next+1) = obj;
            obj.Prev(obj.get_n_prev+1) = new_cortex;
            
            % edge part
            new_edge = axonal_edge(axonal_delay);
            new_edge.from_cortex = new_cortex;
            new_edge.to_cortex = obj;
            
            new_cortex.Next_edge(new_cortex.get_n_next_edge+1) = new_edge;
            obj.Prev_edge(obj.get_n_prev_edge+1) = new_edge;
            
        end
        
        function removeNextNode(obj,a_cortex)
            n_next = length(obj.Next);
            found_flag = 0;
            for idx = 1:n_next
                if a_cortex.ID == obj.Next(idx).ID
                    found_flag = 1;
                    break;
                end
            end
            
            if found_flag == 0
                disp('ERROR: Input node does not exist');
                return;
            end
            
            if n_next == 0
                disp('ERROR: No node to remove');
                return;
            end
            
            % Next's previous
            % find current node
            n_next_prev = length(obj.Next(idx).Prev);
            for prev_idx = 1:n_next_prev
                if obj.ID == obj.Next(idx).Prev(prev_idx).ID
                    break;
                end
            end
            
            % remove the node by the index
            if n_next_prev == 1
                obj.Next(idx).Prev = cortex.empty;
                obj.Next(idx).Prev_edge = axonal_edge.empty;
            elseif prev_idx == n_next_prev
                tmp = cortex.empty;
                tmp = obj.Next(idx).Prev(1:end-1);
                obj.Next(idx).Prev = cortex.empty;
                obj.Next(idx).Prev = tmp;
                
                tmp = edge.empty;
                tmp = obj.Next(idx).Prev_edge(1:end-1);
                obj.Next(idx).Prev_edge = axonal_edge.empty;
                obj.Next(idx).Prev_edge = tmp;
            else
                obj.Next(idx).Prev(prev_idx:end-1) = obj.Next(idx).Prev(prev_idx+1:end);
                tmp = cortex.empty;
                tmp = obj.Next(idx).Prev;
                obj.Next(idx).Prev = cortex.empty;
                obj.Next(idx).Prev = tmp(1:end-1);
                
                obj.Next(idx).Prev_edge(prev_idx:end-1) = obj.Next(idx).Prev_edge(prev_idx+1:end);
                tmp = axonal_edge.empty;
                tmp = obj.Next(idx).Prev_edge;
                obj.Next(idx).Prev_edge = axonal_edge.empty;
                obj.Next(idx).Prev_edge = tmp(1:end-1);
                
            end
            
            % for current node's next
            if n_next == 1
                obj.Next = cortex.empty;
                obj.Next_edge = axonal_edge.empty;
            elseif idx == n_next
                tmp = cortex.empty;
                tmp = obj.Next(1:end-1);
                obj.Next = cortex.empty;
                obj.Next = tmp;
                
                tmp = axonal_edge.empty;
                tmp = obj.Next_edge(1:end-1);
                obj.Next_edge = axonal_edge.empty;
                obj.Next_edge = tmp;
            else
                obj.Next(idx:end-1) = obj.Next(idx+1:end);
                tmp = cortex.empty;
                tmp = obj.Next;
                obj.Next = cortex.empty;
                obj.Next = tmp(1:end-1);
                
                obj.Next_edge(idx:end-1) = obj.Next_edge(idx+1:end);
                tmp = axonal_edge.empty;
                tmp = obj.Next_edge;
                obj.Next_edge = axonal_edge.empty;
                obj.Next_edge = tmp(1:end-1);
            end
        end
        
        
        function removePrevNode(obj,a_cortex)
            n_prev = length(obj.Prev);
            found_flag = 0;
            for idx = 1:n_prev
                if a_cortex.ID == obj.Prev(idx).ID
                    found_flag = 1;
                    break;
                end
            end
            
            if found_flag == 0
                disp('ERROR: Input node does not exist');
                return;
            end
            
            if n_prev == 0
                disp('ERROR: No node to remove');
                return;
            end
            
            % Prev's next
            % find current node
            n_prev_next = length(obj.Prev(idx).Next);
            for next_idx = 1:n_prev_next
                if obj.ID == obj.Prev(idx).Next(next_idx).ID
                    break;
                end
            end
            
            % remove the node by the index
            if n_prev_next == 1
                obj.Prev(idx).Next = cortex.empty;
                obj.Prev(idx).Next_edge = axonal_edge.empty;
            elseif next_idx == n_prev_next
                tmp = cortex.empty;
                tmp = obj.Prev(idx).Next(1:end-1);
                obj.Prev(idx).Next = cortex.empty;
                obj.Prev(idx).Next = tmp;
                
                tmp = axonal_edge.empty;
                tmp = obj.Prev(idx).Next_edge(1:end-1);
                obj.Prev(idx).Next_edge = axonal_edge.empty;
                obj.Prev(idx).Next_edge = tmp;
            else
                obj.Prev(idx).Next(next_idx:end-1) = obj.Prev(idx).Next(next_idx+1:end);
                tmp = cortex.empty;
                tmp = obj.Prev(idx).Next;
                obj.Prev(idx).Next = cortex.empty;
                obj.Prev(idx).Next = tmp(1:end-1);
                
                obj.Prev(idx).Next_edge(next_idx:end-1) = obj.Prev(idx).Next_edge(next_idx+1:end);
                tmp = axonal_edge.empty;
                tmp = obj.Prev(idx).Next_edge;
                obj.Prev(idx).Next_edge = axonal_edge.empty;
                obj.Prev(idx).Next_edge = tmp(1:end-1);
            end
            
            % for current node's next
            if n_prev == 1
                obj.Prev = cortex.empty;
                obj.Perv_edge = axonal_edge.empty;
            elseif idx == n_prev
                tmp = cortex.empty;
                tmp = obj.Prev(1:end-1);
                obj.Prev = cortex.empty;
                obj.Prev = tmp;
                
                tmp = axonal_edge.empty;
                tmp = obj.Prev_edge(1:end-1);
                obj.Prev_edge = axonal_edge.empty;
                obj.Prev_edge = tmp;
            else
                obj.Prev(idx:end-1) = obj.Prev(idx+1:end);
                tmp = cortex.empty;
                tmp = obj.Prev;
                obj.Prev = cortex.empty;
                obj.Prev = tmp(1:end-1);
                
                obj.Prev_edge(idx:end-1) = obj.Prev_edge(idx+1:end);
                tmp = axonal_edge.empty;
                tmp = obj.Prev_edge;
                obj.Prev_edge = axonal_edge.empty;
                obj.Prev_edge = tmp(1:end-1);
            end
        end
        
        %% the most important function
        function [cortex_output] = compute(obj,parameters)
            n_prev = length(obj.Prev);
            n_tp = length(obj.osc);
            cortex_output = [];
            ID_tag = [];
            
            % set excitatory input
            if n_prev == 0
                % This is initial node
                % input already exist.
                if isempty(obj.excitatory_input)
                    disp('ERROR: no input in this cortex');
                    disp(obj);
                    return;
                else
                    n_prev_edge = length(obj.Prev_edge);
                    excitatory_inputs = obj.excitatory_input;
                    for iter = 1:n_prev_edge
                        np_delay = round(parameters.srate*(obj.Prev_edge(iter).axonal_delay/1000));
                        excitatory_inputs(iter,:) = [zeros(1,np_delay) obj.excitatory_input(1:end-np_delay)];
                    end
                    obj.excitatory_input = sum(excitatory_inputs,1);
                end
            else
                % this is intermediate node
                excitatory_inputs = zeros(n_prev,n_tp);
                tmp_outputs = zeros(n_prev,n_tp);
                for iter = 1:n_prev
                    np_delay = round(parameters.srate*(obj.Prev_edge(iter).axonal_delay/1000));
                    tmp_input = obj.Prev(iter).compute(parameters);
                    %                     tmp_input = smooth(tmp_input);
                    excitatory_inputs(iter,:) = [zeros(1,np_delay) tmp_input(1:end-np_delay)];
                    tmp_outputs(iter,:) = tmp_input;
                end
                obj.excitatory_input = sum(excitatory_inputs,1);
            end
            
            %%
            % parameters
            % voltage response
            obj.bba = zeros(1,n_tp)*0.1;
            cortex_output = zeros(1,n_tp);

            
            %%
            BBA = zeros(1,n_tp);
            Voltage = zeros(1,n_tp);
            obj.last_activataion_flag = 0;
            
            new_excitatory_input = obj.excitatory_input;

            tmp_idx = find(new_excitatory_input > 0);
            event_idx = tmp_idx;
            
            % setup cortex buffer
            ctx_buffer = round(parameters.ctx_buffer/1000 * parameters.srate);

            
            
%             %% gamma onset
% %             act_idx_cnt = 1;
%             for iter = 1:length(event_idx)
%                 % duration for modification
%                 start_t = event_idx(iter); %
%                 end_t = start_t+ctx_buffer-1;
% 
%                 %
%                 diff_e_and_i = [];
%                 act_idx = [];
%                 for ibuf = 1:ctx_buffer
%                     if sum(obj.osc(start_t:start_t+ibuf)) < sum(obj.excitatory_input(start_t:start_t+ibuf))
%                         diff_e_and_i = sum(obj.excitatory_input(start_t:start_t+ibuf))-sum(obj.osc(start_t:start_t+ibuf));
%                         act_idx = ibuf;
%                         break;
%                     end
%                 end
% 
%                 % if ex. > in., then fire!!!
%                 if ~isempty(act_idx)
% 
% 
%                     % Voltage(start_t+act_idx:start_t+act_idx+ibuf) = 1*new_excitatory_input(start_t+act_idx-1); % -1 is for 1 time point stimulus
%                     Voltage(start_t+act_idx:start_t+act_idx+ibuf) = 1*new_excitatory_input(start_t+act_idx-1); % -1 is for 1 time point stimulus
% 
%                 end
% 
%             end

            %% gamma onset (no buffer)
            for iter = 1:length(event_idx)
                start_t = event_idx(iter);

                % 조건: 흥분성 입력 > 감마(또는 억제) 활동
                if obj.excitatory_input(start_t) > obj.osc(start_t)
                    % 감마 활성화 (이전 시점의 new_excitatory_input 값 사용)
                    Voltage(start_t) = 1 * new_excitatory_input(start_t);
                end
            end
            
            %% BBA
            bba_idx = find(Voltage > 0);
            
            %% sigmoid function
%             osc_mag = max(obj.osc) - min(obj.osc);
            input_amp1 = abs(Voltage(bba_idx));
%             
%             osc_amp = parameters.osc_amp;
% %             alpha_amp = osc_amp/2;
%             sig_slope = 10/osc_amp;
            C = parameters.c_sigmoid;
%             bba_magnitude =  input_amp1 - obj.osc(bba_idx).*(1-logsig((input_amp1-obj.osc(bba_idx))*sig_slope));
            
            diff_E_I = input_amp1 - obj.osc(bba_idx);
%             bba_magnitude =  input_amp1 - obj.osc(bba_idx).*(1-logsig((diff_E_I)*C));
            %simplyfied new formula - 06/08/2025
            bba_magnitude = input_amp1.*logsig(diff_E_I*C);
%             bba_magnitude = max(0, (diff_E_I )*C);


            neg_idx = find(bba_magnitude <0);
            bba_magnitude(neg_idx) = 0;
            %             bba_magnitude = input_amp;
            
            %%
            %             bba_magnitude = abs(Voltage(bba_idx));
            %             bba_tmp = rand(1,length(Voltage));
            bba_tmp1 = ones(1,length(Voltage)/2);
            bba_tmp2 = -ones(1,length(Voltage)/2);
            bba_tmp = [bba_tmp1 bba_tmp2];
            bba_tmp = bba_tmp(randperm(length(bba_tmp)));
            %             bba_tmp = -1 + 2*rand(1,length(Voltage));
            
            BBA(bba_idx) = bba_tmp(bba_idx).*bba_magnitude;

            
            %%
            obj.bba = obj.bba + BBA;
            obj.voltage = obj.osc;
            
            % calculate cortex output before 12/23/2019
            activated_idx = find(abs(obj.bba)>parameters.output_threshold); %% activation threshold micro volt.
            cortex_output(1,activated_idx) = abs(obj.bba(activated_idx));
           
            
           
            
        end
        
    end
end
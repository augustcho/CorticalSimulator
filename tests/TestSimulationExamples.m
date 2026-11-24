classdef TestSimulationExamples < matlab.unittest.TestCase
    % Full-default public scripts, including documented undefined values.
    properties (TestParameter)
        Script = {'simulation_1', 'simulation_2', 'simulation_3', ...
            'simulation_4', 'simulation_5', 'simulation_6', ...
            'simulation_7_and_8', 'simulation_9', 'simulation_10', ...
            'simulation_11_and_12', 'simulation_13_and_14'};
    end
    methods (Test)
        function publicExample(testCase, Script)
            root = fileparts(fileparts(mfilename('fullpath')));
            testCase.assertEmpty(findall(groot, 'Type', 'figure'), ...
                'Run this suite in a fresh session with no open figures.');
            previous = struct('folder', pwd, 'path', path, 'random', rng, ...
                'visibility', get(groot, 'DefaultFigureVisible'));
            cleanup = onCleanup(@() restoreSession(previous)); %#ok<NASGU>
            cd(root);
            set(groot, 'DefaultFigureVisible', 'off');
            rng(2026, 'twister');
            [result, settings] = executeEntry(Script);
            testCase.verifyEqual(which('cortex'), fullfile(root, 'cortex.m'));
            validateResults(testCase, Script, result, settings);

            names = {'simulation_1', 'simulation_2', 'simulation_3', ...
                'simulation_4', 'simulation_5', 'simulation_6', ...
                'simulation_7_and_8', 'simulation_9', 'simulation_10', ...
                'simulation_11_and_12', 'simulation_13_and_14'};
            counts = [1 1 1 1 1 1 3 1 1 2 2];
            figures = findall(groot, 'Type', 'figure');
            testCase.assertNumElements(figures, counts(strcmp(names, Script)));
            if strcmp(Script, 'simulation_4')
                axesHandle = findall(figures, 'Type', 'axes');
                testCase.verifyEqual(axesHandle.YLabel.String, ...
                    'Normalized Reaction Time (z-score)');
            end
            if strcmp(Script, 'simulation_9')
                trace = findobj(figures, 'DisplayName', 'Cortical Simulator');
                testCase.assertNumElements(trace, 1);
                testCase.verifyEqual(trace.XData, [2.5 10 20 30 40 47.5]);
            end
            destination = fullfile(root, 'artifacts');
            if ~isfolder(destination), mkdir(destination); end
            for k = 1:numel(figures)
                testCase.verifyNumElements(findall(figures(k), 'Type', 'axes'), 1);
                filename = fullfile(destination, sprintf('%s_%d.png', Script, k));
                exportgraphics(figures(k), filename, 'Resolution', 140);
                info = dir(filename);
                testCase.assertNumElements(info, 1);
                testCase.verifyGreaterThan(info.bytes, 0);
            end
            save(fullfile(destination, [Script '.mat']), 'result', 'settings');
            fprintf('%s: output contract verified, %d figures exported.\n', ...
                Script, numel(figures));
        end
    end
end

function [result, settings] = executeEntry(name)
add_path
eval(name);
result = results;
settings = config;
end

function validateResults(testCase, name, r, c)
testCase.assertClass(r, 'struct');
testCase.assertSize(r, [1 1]);
testCase.assertNotEmpty(fieldnames(r));
fields = fieldnames(r);
for k = 1:numel(fields)
    value = r.(fields{k});
    if isnumeric(value)
        testCase.verifyFalse(any(isinf(value(:))), fields{k});
    end
end
switch name
    case 'simulation_1'
        testCase.verifyEqual(r.alpha_level, 50:5:200);
        testCase.verifySize(r.alpha_bin_avg, [1 31]);
        testCase.verifySize(r.alpha_bin_std, [1 31]);
        testCase.verifyTrue(all(isfinite(r.alpha_bin_avg)));
        testCase.verifyTrue(all(isfinite(r.alpha_bin_std)));
        testCase.verifyTrue(all(r.alpha_bin_avg >= 0 & r.alpha_bin_avg <= 100));
        testCase.verifyGreaterThan(r.alpha_bin_avg(1), r.alpha_bin_avg(end));
    case 'simulation_2'
        testCase.verifySize(r.phase_bin_avg, [numel(r.pbin_idx) 1]);
        sampled = r.phase_bin_num > 0;
        testCase.verifyTrue(all(isfinite(r.phase_bin_avg(sampled))));
        testCase.verifyTrue(all(isfinite(r.phase_bin_std(sampled))));
        testCase.verifyTrue(all(isnan(r.phase_bin_avg(~sampled))));
        testCase.verifyEqual(r.phase_bin_num(end), 0); % Legacy unused edge.
    case {'simulation_5', 'simulation_6'}
        testCase.verifySize(r.phase_alpha_table, ...
            [numel(c.pbin_idx) numel(c.alpha_level)]);
        testCase.verifyTrue(all(isnan(r.phase_alpha_table(end,:))));
        testCase.verifyEmpty(r.phase_bins{end}); % Last edge is not a bin.
        for k = 1:numel(c.pbin_idx)-1
            samples = r.phase_bins{k};
            testCase.verifyNumElements(samples, c.n_repeats * numel(c.alpha_level));
            finite = samples(isfinite(samples));
            testCase.verifyNotEmpty(finite);
            testCase.verifyTrue(all(finite >= 0 & finite <= 100));
            % Preserve the existing last-repeat summary, by explicit policy.
            testCase.verifyTrue(isequaln(r.phase_alpha_table(k,:), ...
                samples(c.n_repeats:c.n_repeats:end)));
        end
    otherwise
        switch name
            case 'simulation_3'
                dimensions = [1 numel(c.alpha_level)];
            case 'simulation_4'
                dimensions = [numel(c.osc_hz_list) c.n_reps];
            case {'simulation_7_and_8', 'simulation_10'}
                dimensions = [1 numel(c.stimulus_intensities)];
            case 'simulation_9'
                dimensions = [c.n_repeats numel(c.stim_durations)];
            case 'simulation_11_and_12'
                dimensions = [1 c.n_conditions];
            case 'simulation_13_and_14'
                dimensions = [c.n_repeats c.n_conditions];
        end
        if isfield(r, 'm_rts')
            means = r.m_rts; deviations = r.s_rts;
        else
            means = r.m_rt; deviations = r.s_rt;
        end
        if isfield(r, 'response_rate'), rates = r.response_rate; else, rates = r.RR; end
        testCase.verifySize(means, dimensions);
        testCase.verifySize(deviations, dimensions);
        testCase.verifySize(rates, dimensions);
        finiteRates = rates(isfinite(rates));
        testCase.verifyTrue(all(finiteRates >= 0 & finiteRates <= 100));
        if strcmp(name, 'simulation_7_and_8')
            % Zero intensity produces no stimulus events, so its rate is undefined.
            testCase.verifyTrue(all(isnan(rates(c.stimulus_intensities == 0))));
            testCase.verifyTrue(all(isfinite(rates(c.stimulus_intensities > 0))));
        else
            testCase.verifyTrue(all(isfinite(rates(:))));
        end
        responsive = rates > 0;
        testCase.verifyTrue(any(responsive(:)));
        testCase.verifyTrue(all(isfinite(means(responsive))));
        testCase.verifyTrue(all(means(responsive) > 0 & means(responsive) < 1));
        testCase.verifyTrue(all(isfinite(deviations(responsive))));
        testCase.verifyTrue(all(deviations(responsive) >= 0));
        testCase.verifyTrue(all(isnan(means(~responsive))));
end
end

function restoreSession(previous)
close all force
set(groot, 'DefaultFigureVisible', previous.visibility);
rng(previous.random);
path(previous.path);
cd(previous.folder);
end

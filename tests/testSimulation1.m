function tests = testSimulation1
% Integration check for the public, full-default Simulation 1 entry point.
tests = functiontests(localfunctions);
end

function testDefaultSimulation1(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
oldFolder = pwd;
oldPath = path;
oldRandomState = rng;
oldVisibility = get(groot, 'DefaultFigureVisible');
oldFigures = findall(groot, 'Type', 'figure');
cleanup = onCleanup(@() restoreSession(oldFolder, oldPath, ...
    oldRandomState, oldVisibility, oldFigures)); %#ok<NASGU>
cd(root);
set(groot, 'DefaultFigureVisible', 'off');
rng(2026, 'twister');
testCase.assertNotEmpty(which('logsig'), 'Deep Learning Toolbox is required.');
testCase.assertNotEmpty(which('corr'), ...
    'Statistics and Machine Learning Toolbox is required for study comparisons.');

[result, settings] = runExample();
testCase.verifyEqual(which('cortex'), fullfile(root, 'cortex.m'));
testCase.verifyEqual(which('config_alpha_power_and_excitability'), ...
    fullfile(root, 'functions', 'config_alpha_power_and_excitability.m'));
testCase.verifyEqual(settings.parameters.srate, 400);
testCase.verifyEqual(settings.end_sec, 800);
testCase.verifyEqual(settings.alpha_level, 50:5:200);
testCase.assertClass(result, 'struct');
testCase.assertTrue(all(isfield(result, ...
    {'alpha_level', 'alpha_bin_avg', 'alpha_bin_std', 'pbin_idx'})));
testCase.verifyEqual(result.alpha_level, 50:5:200);
testCase.verifySize(result.alpha_bin_avg, [1 31]);
testCase.verifySize(result.alpha_bin_std, [1 31]);
testCase.verifyTrue(all(isfinite(result.alpha_bin_avg)));
testCase.verifyTrue(all(isfinite(result.alpha_bin_std)));
testCase.verifyTrue(all(result.alpha_bin_avg >= 0));
testCase.verifyTrue(all(result.alpha_bin_avg <= settings.stimulus_intensity));
testCase.verifyTrue(all(result.alpha_bin_std >= 0));
testCase.verifyGreaterThan(result.alpha_bin_avg(1), result.alpha_bin_avg(end));
figures = setdiff(findall(groot, 'Type', 'figure'), oldFigures);
testCase.assertNumElements(figures, 1);
testCase.verifyNumElements(findall(figures, 'Type', 'axes'), 1);
testCase.verifyNumElements(findall(figures, 'Type', 'line'), 4);
artifactFolder = fullfile(root, 'artifacts');
if ~isfolder(artifactFolder)
    mkdir(artifactFolder);
end
pngPath = fullfile(artifactFolder, 'simulation-1.png');
exportgraphics(figures, pngPath, 'Resolution', 150);
info = dir(pngPath);
testCase.assertNumElements(info, 1);
testCase.verifyGreaterThan(info.bytes, 0);
save(fullfile(artifactFolder, 'simulation-1-output.mat'), 'result', 'settings');
fprintf('Simulation 1: 31 conditions, all finite, mean %.6f to %.6f, 1 figure.\n', ...
    result.alpha_bin_avg(1), result.alpha_bin_avg(end));
end

function [result, settings] = runExample
add_path
simulation_1
result = results;
settings = config;
end

function restoreSession(folder, searchPath, randomState, visibility, figures)
delete(setdiff(findall(groot, 'Type', 'figure'), figures));
set(groot, 'DefaultFigureVisible', visibility);
rng(randomState);
path(searchPath);
cd(folder);
end

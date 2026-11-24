# Cortical Simulator

A MATLAB package for exploring how cortical excitation, oscillatory inhibition, and propagation delays affect simulated neural responses and behavioral measures. The package includes configurable simulations of excitability, response rate, reaction time, and multisensory conditions.

This is the NCAN-hosted fork of [`augustcho/CorticalSimulator`](https://github.com/augustcho/CorticalSimulator). The original source history and MIT License are preserved.

## Requirements

| Dependency | Used for |
| --- | --- |
| MATLAB | Running the model, simulations, and plots |
| Deep Learning Toolbox | `logsig` in the cortical-response model |
| Statistics and Machine Learning Toolbox | `corr` for comparisons with the included study data |
| Signal Processing Toolbox | `butter`, `filtfilt`, and `hilbert` in the alpha-phase/hit-rate simulations |

All 11 public scripts (numbered simulations 1–14) were executed with their full default configurations using MATLAB R2026a Update 3 on macOS (Apple silicon). Compatibility with other MATLAB releases has not been established by this check. MathWorks marks [`logsig`](https://www.mathworks.com/help/deeplearning/ref/logsig.html) for removal in a future release; the current model retains that function.

## Run Simulation 1

Download or clone this repository and open its root as the current folder in a fresh MATLAB session:

```matlab
add_path
rng(2026, 'twister')
simulation_1
```

The seed makes the random input reproducible. The simulation scripts call `clear` and `clc`; use a fresh session to preserve an existing workspace.

Simulation 1 uses the unmodified default configuration: a 400 Hz sampling rate, an 800-second simulated signal per condition, and 31 oscillation-amplitude conditions (`50:5:200`). It creates an alpha-power/excitability figure with the model and the included study comparisons, and leaves these workspace variables:

| Variable | Contents |
| --- | --- |
| `config` | Model parameters and experimental settings |
| `results.alpha_level` | `1-by-31` amplitude sweep |
| `results.alpha_bin_avg` | `1-by-31` mean model-response magnitudes |
| `results.alpha_bin_std` | `1-by-31` response standard deviations |
| `results.pbin_idx` | Phase-bin axis included by this simulation |

Inspect or save the raw results:

```matlab
results.alpha_bin_avg
save('simulation_1_output.mat', 'config', 'results')
exportgraphics(gcf, 'simulation_1.png', 'Resolution', 150)
```

The comparison plot uses standardized values (`zscore`); negative plotted values indicate values below the mean, rather than negative response magnitudes.

## Available simulations

| Script | Model condition |
| --- | --- |
| [`simulation_1.m`](simulation_1.m) | Alpha power and excitability |
| [`simulation_2.m`](simulation_2.m) | Alpha phase and excitability |
| [`simulation_3.m`](simulation_3.m) | Alpha amplitude and behavioral responses |
| [`simulation_4.m`](simulation_4.m) | Alpha frequency and reaction time |
| [`simulation_5.m`](simulation_5.m) | Hit rate at high alpha amplitude |
| [`simulation_6.m`](simulation_6.m) | Hit rate at low alpha amplitude |
| [`simulation_7_and_8.m`](simulation_7_and_8.m) | Stimulus intensity |
| [`simulation_9.m`](simulation_9.m) | Stimulus duration |
| [`simulation_10.m`](simulation_10.m) | Weber-type conditions |
| [`simulation_11_and_12.m`](simulation_11_and_12.m) | Bimodal stimulation |
| [`simulation_13_and_14.m`](simulation_13_and_14.m) | Incongruent conditions |

Each script calls a `config_*`, `simulate_*`, and `plot_*` function in [`functions/`](functions/). Model classes are supplied in [`classes/`](classes/) and as legacy root-level copies. The existing comparison datasets are in [`data/`](data/).

## Tests and validation

From the repository root in a fresh session with no open figures:

```matlab
results = runtests('tests');
assertSuccess(results);
```

The parameterized integration suite runs all 11 scripts with their full default configurations and seed 2026. It checks output dimensions, response-rate and reaction-time values, documented undefined values, the preserved phase aggregation, and the expected 15 figures. Simulation 9 also checks the duration coordinates against the configured sampling rate. PNG/MAT files are exported to `artifacts/`. The suite isolates each script's workspace clearing and restores the caller's random state, path, current folder, and figure-visibility setting. Scripts close figures; the suite refuses to start with existing figures open.

GitHub Actions runs the suite with MATLAB R2026a and the declared toolboxes. Test reports and result files are retained as workflow artifacts. Full-default testing takes several minutes; Simulations 5–6 each use 100 repetitions per amplitude. Successful execution and regression checks do not establish physiological accuracy or convergence of the model.

### Interpretation and current limitations

- Simulations 2, 5, and 6 retain a legacy extra phase-edge row that has no samples. Its summary is `NaN`; it is not an additional populated phase bin.
- Simulations 5–6 preserve all 100 repetitions per amplitude in `results.phase_bins`, but `results.phase_alpha_table` and the plotted summary retain **only the last repetition** for each amplitude. This existing aggregation is intentionally preserved; the plotted table must not be interpreted as a repetition average. A phase bin without a trial in that final repetition can also be `NaN`.
- Reaction-time summaries are `NaN` when no response occurs. In Simulations 7–8, zero stimulus intensity produces no stimulus events, so its response rate is also undefined (`NaN`). These values are preserved rather than replaced with zeros.
- Simulation 9 plots nominal configured stimulus durations in milliseconds using the sampling rate (at 400 Hz: 2.5, 10, 20, 30, 40, and 47.5 ms). This labels the configured durations; it does not independently validate pulse timing in the model.
- Simulations 11–12 currently emit `Integer operands are required for colon operator when used as index` in `simulate_bimodal` when the relative input delay is 16.8 samples (42 ms at 400 Hz). The current MATLAB release completes the run, but this fractional indexing is unresolved: the legacy slicing can shorten the shifted input by one sample. The existing calculation is intentionally preserved; passing the regression suite does not validate this timing.

## Citation and contributions

Use [`CITATION.cff`](CITATION.cff) for the software citation and record the commit SHA used in your analysis. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for testing and change-review guidance.

Maintainer: Hohyun Cho ([cho@neurotechcenter.org](mailto:cho@neurotechcenter.org)).

## License

[MIT License](LICENSE), copyright 2025 Hohyun Cho. The original [`README.txt`](README.txt) is retained for provenance.

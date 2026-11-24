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

Simulation 1 was verified with MATLAB R2026a Update 3 on macOS (Apple silicon). Compatibility with other MATLAB releases has not been established by this check. MathWorks marks [`logsig`](https://www.mathworks.com/help/deeplearning/ref/logsig.html) for removal in a future release; the current model retains that function.

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

From the repository root:

```matlab
results = runtests('tests');
assertSuccess(results);
```

The integration test runs the full default Simulation 1 with a fixed seed, checks the output dimensions and finite response values, verifies the expected figure and comparison traces, and exports PNG/MAT artifacts to `artifacts/`. It isolates the script's workspace clearing and restores the caller's random state, path, current folder, and figure-visibility setting.

GitHub Actions runs this check with MATLAB R2026a and the declared toolboxes. Test reports and result files are retained as workflow artifacts. This is a reproducibility check of Simulation 1; the remaining simulations and the model's scientific predictions require their own validation.

## Citation and contributions

Use [`CITATION.cff`](CITATION.cff) for the software citation and record the commit SHA used in your analysis. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for testing and change-review guidance.

Maintainer: Hohyun Cho ([cho@neurotechcenter.org](mailto:cho@neurotechcenter.org)).

## License

[MIT License](LICENSE), copyright 2025 Hohyun Cho. The original [`README.txt`](README.txt) is retained for provenance.

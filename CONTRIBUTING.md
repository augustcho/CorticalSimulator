# Contributing

Use a separate branch and submit a pull request to `neurotechcenter/CorticalSimulator:main`. Keep changes focused, and distinguish model changes from packaging, dependency, and documentation fixes.

Install the toolboxes listed in the README. Run `results = runtests('tests'); assertSuccess(results);` from the repository root in a fresh MATLAB session. The current integration check covers full-default Simulation 1 and writes diagnostic artifacts to `artifacts/`. It does not validate every simulation or establish physiological accuracy.

When reporting a problem, include the commit SHA, operating system, MATLAB/toolbox versions, exact commands, and complete error text. For model changes, explain the scientific rationale, record the random seed, and provide before/after results. Update test expectations only when the behavior change is intentional and justified.

Preserve original comparison data, historical scripts, and source attribution. Do not include generated results or machine-specific paths in a code change. Source-code contributions use the repository's existing MIT License.

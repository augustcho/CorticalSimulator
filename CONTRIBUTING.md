# Contributing

Use a separate branch and submit a pull request to `neurotechcenter/CorticalSimulator:main`. Keep changes focused, and distinguish model changes from packaging, dependency, and documentation fixes.

Install the toolboxes listed in the README. Run `results = runtests('tests'); assertSuccess(results);` from the repository root in a fresh MATLAB session with no open figures. The integration suite covers all 11 public scripts (numbered simulations 1–14) at their full defaults and writes 15 figures and raw results to `artifacts/`. It verifies documented undefined values and the existing last-repetition aggregation in Simulations 5–6. This does not establish physiological accuracy or convergence.

When reporting a problem, include the commit SHA, operating system, MATLAB/toolbox versions, exact commands, and complete error text. For model changes, explain the scientific rationale, record the random seed, and provide before/after results. Update test expectations only when the behavior change is intentional and justified.

Preserve original comparison data, historical scripts, and source attribution. Do not include generated results or machine-specific paths in a code change. Source-code contributions use the repository's existing MIT License.

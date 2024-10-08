# Changelog

## [1.2.5] - 2024-09-19

### Changed

- Sets fixed versions for phipack (1.0.0) and omegamap (tag `2019.06.08`).

## [1.2.4] - 2023-06-22

### Fixed

- Add `score_ascii` to `-output` in `t_coffee` invocation of task `align-protein-sequences`.

## [1.2.3] - 2022-08-02

### Fixed

- Fix `run-mrbayes` task to avoid failing when very long paths are used to locate the input files.

## [1.2.2] - 2022-08-02

### Fixed

- Fix `run-mrbayes` task to avoid failing when very long paths are used to locate the input files.

## [1.2.1] - 2021-07-13

### Fixed

- Fix `run-mrbayes` task so that it fails when the corresponding `*.nex.con.tre` file is not created.

## [1.2.0] - 2021-04-28

### Changed

- Update Compi version to 1.4.0.

## [1.1.0] - 2021-03-26

### Changed

- Fix `check-input-files` task to remove ambiguous sequences and exclude files.
- Fix `tabulate-results` task to remove the correct results file at the beginning.
- Update Compi version to 1.3.8.

## [1.0.2] - 2020-12-22

### Fixed

- Fix regex in find error tasks script to avoid errors running `ls`.

## [1.0.1] - 2020-11-11

### Fixed

- Fix OmegaMap results processing.

## [1.0.0] - 2020-11-09

### Added

- First public release of the pipeline.

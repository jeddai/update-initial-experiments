# Update initial experiments docker action

This action downloads a list of experiments from experimenter and writes them to the repository. If changes are made, it will open a new pull request or update an existing pull request.

## Inputs

### `repo-path`

**Required** The relative or absolute path to the checked out repository. Example: `main`

### `output-path`

**Requried** The relative file path (from the repo path) to which the downloaded experiments should be written. Example: `app/src/main/res/raw/initial_experiments.json`

### `experimenter-url`

URL from which to fetch Nimbus experiments. Default: `https://experimenter.services.mozilla.com/api/v6/experiments/?is_first_run=True`

## Outputs

### `changed`

The number of files that were modified as part of the script.

## Example usage

```yaml
uses: jeddai/update-initial-experiments@v1
with:
  repo-path: main
  output-path: app/src/main/res/raw/initial_experiments.json
  experimenter-url: https://experimenter.services.mozilla.com/api/v6/experiments/
```

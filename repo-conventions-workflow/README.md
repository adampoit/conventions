# repo-conventions-workflow

GitHub Actions workflow that runs [RepoConventions](https://github.com/Faithlife/RepoConventions) on a schedule.

## What it does

Creates `.github/workflows/repo-conventions.yml` with:

- A cron schedule (randomized minute, 9 AM UTC, weekdays) to keep repos from all hitting GitHub at the same time.
- `workflow_dispatch` trigger with an optional `conventions` input to add new conventions on demand.
- Runs RepoConventions directly with `dnx repo-conventions apply --open-pr`.
- Uses a repository secret named `ACTIONS_PAT` for checkout and GitHub CLI authentication, so convention PRs can trigger other workflows.

## Required secrets

- `ACTIONS_PAT`: a GitHub personal access token with `contents: write` and `pull-requests: write` access to the repository.

## Preserving existing schedule

If the workflow already exists, the convention preserves its cron minute so the schedule doesn't jump around on every run.

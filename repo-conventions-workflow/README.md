# repo-conventions-workflow

GitHub Actions workflow that runs [RepoConventions](https://github.com/Faithlife/RepoConventions) on a schedule.

## What it does

Creates `.github/workflows/repo-conventions.yml` with:

- A cron schedule (randomized minute, 9 AM UTC, weekdays) to keep repos from all hitting GitHub at the same time.
- `workflow_dispatch` trigger with an optional `conventions` input to add new conventions on demand.
- Runs RepoConventions directly with `dnx repo-conventions apply --open-pr`.
- Uses the [`not-adam`](https://github.com/adampoit/not-adam) GitHub App for checkout and GitHub CLI authentication, so convention PRs can trigger other workflows.

## Required configuration

- Repository variable `NOT_ADAM_APP_ID`: the `not-adam` GitHub App ID.
- Repository secret `NOT_ADAM_APP_PRIVATE_KEY`: the `not-adam` GitHub App private key.

## Preserving existing schedule and action versions

If the workflow already exists, the convention preserves its cron minute so the schedule doesn't jump around on every run. It also preserves the existing `actions/checkout` and `actions/setup-dotnet` versions so dependency updater PRs are not reverted by the next convention run.

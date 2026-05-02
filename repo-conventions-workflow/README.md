# repo-conventions-workflow

GitHub Actions workflow that runs [RepoConventions](https://github.com/Faithlife/RepoConventions) on a schedule.

## What it does

Creates `.github/workflows/repo-conventions.yml` with:

- A cron schedule (randomized minute, 9 AM UTC, weekdays) to keep repos from all hitting GitHub at the same time.
- `workflow_dispatch` trigger with an optional `conventions` input to add new conventions on demand.
- Uses the `Faithlife/CodingGuidelines` reusable workflow to do the actual work.

## Settings

None.

## Preserving existing schedule

If the workflow already exists, the convention preserves its cron minute so the schedule doesn't jump around on every run.

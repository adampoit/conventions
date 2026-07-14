# github-settings

Installs declarative GitHub repository settings for the [Repository Settings app](https://github.com/repository-settings/app).

## What it does

Creates `.github/settings.yml` that configures GitHub to:

- Enable issues and disable projects, the wiki, and discussions.
- Allow squash and rebase merges and disable merge commits.
- Use the pull request title and body for squashed commits.
- Enable auto-merge and the pull request “update branch” option.
- Delete head branches automatically after pull requests are merged.
- Enable vulnerability alerts; dependency remediation is left to Renovate.
- Protect the default branch from deletion and force pushes.
- Require a linear commit history.
- Require all changes to reach the default branch through a pull request.
- Require review conversations to be resolved before merging.

The ruleset targets GitHub's `~DEFAULT_BRANCH`, so it continues to work if the default branch is renamed. Status checks are not standardized because they vary by project.

## Required configuration

Install the hosted [Settings GitHub App](https://github.com/apps/settings) on the repository. The app applies `.github/settings.yml` after changes reach the default branch; applying this convention only edits configuration files.

Repository ruleset support in the app is currently marked as under development, so its YAML format may change.

## Usage

```yaml
conventions:
    - path: adampoit/conventions/github-settings
```

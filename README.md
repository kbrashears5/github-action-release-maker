<h1 align="center">github-action-release-creator</h1>


<div align="center">

<b>Github Action to create a release when triggered</b>

[![version](https://img.shields.io/github/v/release/kbrashears5/github-action-release-creator)](https://img.shields.io/github/v/release/kbrashears5/github-action-release-creator)
[![Build Status](https://dev.azure.com/kbrashears5/github/_apis/build/status/kbrashears5.github-action-release-creator?branchName=master)](https://dev.azure.com/kbrashears5/github/_build/latest?definitionId=30&branchName=master)

</div>


# Use Cases
Have releases be created automatically as part of your CI/CD, using your last commit message

# Setup
Create a new file called `/.github/workflows/release-creator.yml` that looks like so:
```yaml
name: Release Creator

on:
  repository_dispatch:
    types:
      - release

jobs:
  release_creator:
    runs-on: ubuntu-latest
    steps:
      - name: Release Creator
        uses: kbrashears5/github-action-release-creator@v1.0.0
        with:
          VERSION: ${{ github.event.client_payload.version }}
          TOKEN: ${{ secrets.ACTIONS }}
```
## Parameters
| Parameter | Required | Description |
| --- | --- | --- |
| VERSION | true | Version name to give the release |
| TOKEN | true | Personal Access Token with Repo scope |

## Invoking
### cURL
```bash
curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{"event_type":"release","client_payload":{"version":"v1.0.0"}}' \
  https://api.github.com/repos/{username}/{repo-name}/dispatches
```

### Azure DevOps Pipeline
See my yaml [templates](https://github.com/kbrashears5/yaml/blob/master/templates/create-github-release.yml) on how to use.

This template will use the build number as the version of the package.
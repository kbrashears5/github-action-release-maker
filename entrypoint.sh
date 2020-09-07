#!/bin/bash

echo "Repository: [$GITHUB_REPOSITORY]"

# log inputs
echo "Inputs"
echo "---------------------------------------------"
GITHUB_TOKEN="$INPUT_TOKEN"
VERSION=${{ github.event.client_payload.version }}
echo "Version: [$VERSION]"

echo " "

# determine repo name
REPO_INFO=($(echo $repository | tr "/" "\n"))
USERNAME=${REPO_INFO[0]}
echo "Repository name: [$USERNAME]"

# get the last commit message
echo "Getting default branch name"
DEFAULT_BRANCH_NAME=$(curl -X GET -H "Accept: application/vnd.github.v3+json" -u ${USERNAME}:${GITHUB_TOKEN} --silent ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY} | jq '.default_branch')
echo "Default branch name: [$DEFAULT_BRANCH_NAME]"

# get the last commit message
echo "Getting last commit message"
LAST_COMMIT_MESSAGE=$(curl -X GET -H "Accept: application/vnd.github.v3+json" -u ${USERNAME}:${GITHUB_TOKEN} --silent ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/branches/${DEFAULT_BRANCH_NAME} | jq '.commit.commit.message')
echo "Last commit message: [$LAST_COMMIT_MESSAGE]"

echo "Creating release"
jq -n \
    --arg lastCommitMessage "$LAST_COMMIT_MESSAGE" \
    --arg version "$version" \
    '{
        tag_name:$version,
        name:$version,
        body:$lastCommitMessage
    }' \
    | curl -d @- \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -u ${USERNAME}:${GITHUB_TOKEN} \
        --silent \
        ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/releases
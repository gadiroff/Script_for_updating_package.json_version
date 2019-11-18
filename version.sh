#!/bin/bash

VERSION_UPDATE=$1
RELEASE_BRANCH="release"
FULL_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

arr=($(echo "$FULL_BRANCH" | tr '/' '\n'))

BRANCH="${arr[0]}"
MASK="${arr[1]}"

set_version() {
    npm version ${VERSION_UPDATE}
    git push origin ${FULL_BRANCH} --no-verify
}

if [[ ! ${VERSION_UPDATE} =~ major|minor|patch ]]; then
    echo "Use the 2nd parameter : major|minor|patch"
    exit 1
fi


if [[ "${BRANCH}" == "${RELEASE_BRANCH}" && "${MASK}" =~ v[0-9]+\.[0-9]+ ]];
    then
        set_version
    else
        echo "Release branch is: ${RELEASE_BRANCH}/v[num].[num] e.g. v10.10 Yours: ${FULL_BRANCH}"
        exit 1
fi
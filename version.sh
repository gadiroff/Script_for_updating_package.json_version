#!/bin/bash

RELEASE_BRANCH="release"
FULL_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

arr=($(echo "$FULL_BRANCH" | tr '/' '\n'))

BRANCH="${arr[0]}"
MASK="${arr[1]}"

set_version() {
	AUTHOR=$(git log -1 --pretty=format:'%an')
	echo "Last commit author: $AUTHOR"
	#if [ "${AUTHOR}" == "teamcity-agent" ]; then
	#	echo "Don't rebuild after teamcity commit"
	#	exit 1;
	#fi
    PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')

	echo "v:$PACKAGE_VERSION"

	NEW_VERSION=$(echo $PACKAGE_VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')

	echo "v:$NEW_VERSION"
	echo "-------"
	echo "\"version\": \"$PACKAGE_VERSION\""
	echo "\"version\": \"$NEW_VERSION\""

	sed -i "s/\"version\": \"$PACKAGE_VERSION\"/\"version\": \"$NEW_VERSION\"/g" package.json
	echo 'Updated package.json'
	cat package.json
	
	branch=$(git status | grep "On branch" | cut -d' ' -f3)
	REMOTE_REPO=$(git remote -v | head -n 1 | cut -f1)
	
	
    echo $REMOTE_REPO
    echo "Host *" > ~/.ssh/config
    echo "    StrictHostKeyChecking no" >> ~/.ssh/config
    echo "IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
    echo "yes" | git push $REMOTE_REPO $branch

}


if [[ ${BRANCH} == ${RELEASE_BRANCH} && "${MASK}" =~ v[0-9]+\.[0-9]+ ]];
    then
        set_version
    else
        echo "Current branch not release. Yours branch: ${FULL_BRANCH}"
fi

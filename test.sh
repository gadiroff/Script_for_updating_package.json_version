#!/bin/bash

AUTHOR=$(git log -1 --pretty=format:'%an')
	echo "Last commit author: $AUTHOR"

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


git commit -m "Bump version to $NEW_VERSION"
	git tag "v$NEW_VERSION"
	branch=$(git status | grep "On branch" | cut -d' ' -f3)
	REMOTE_REPO=$(git remote -v | head -n 1 | cut -f1)
	

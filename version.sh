#!/bin/bash

RELEASE_BRANCH="release"
FULL_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

arr=($(echo "$FULL_BRANCH" | tr '/' '\n'))

BRANCH="${arr[0]}"
MASK="${arr[1]}"

set_version() {
        AUTHOR=$(git log -1 --pretty=format:'%an')
        echo "Last commit author: $AUTHOR"
    PACKAGE_VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[\",]//g' | tr -d '[[:space:]]')

        echo "v:$PACKAGE_VERSION"

        current_count=$(echo " ${PACKAGE_VERSION[@]: -1} ")
    new_count=$(( $current_count + 1 ))
    if [ ${#PACKAGE_VERSION} -eq 5 ];
    then
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/5`
    else
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/6`
    fi;




    if [ $current_count -ne 0 -a  ${#PACKAGE_VERSION} = 5  ]
    then
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/5`

    elif [ $current_count -eq 0 -a  ${#PACKAGE_VERSION} = 5  ]
    then
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/5`


    elif [  $current_count -eq 0 -a  ${#PACKAGE_VERSION} = 6 ]
    then
    new_count=1
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/6`


    elif [ $current_count -ne 0 -a  ${#PACKAGE_VERSION} = 6 -a $current_count -ne 9  ]
    then
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$new_count/6`


    elif [ $current_count -eq 9 -a  ${#PACKAGE_VERSION} = 6  ]
    then
    count5="${PACKAGE_VERSION[@]:4:1}"
    NEW_VERSION=`echo $PACKAGE_VERSION  | sed s/./$(( $count5 + 1 ))/5 | sed s/./0/6`
    fi




        echo "v:$NEW_VERSION"
        echo "-------"
        echo "\"version\": \"$PACKAGE_VERSION\""
        echo "\"version\": \"$NEW_VERSION\""

        sed -i "s/\"version\": \"$PACKAGE_VERSION\"/\"version\": \"$NEW_VERSION\"/g" package.json
        echo 'Updated package.json'
        cat package.json
        


	git config --global user.email "jeyhun.gadirov@gmail.com"
	git config --global user.name "jeyhun gadirov"
	git add package.json
	git commit -m "Bump version to $NEW_VERSION"
    git fetch --tags
	git tag "v$NEW_VERSION"
	branch=$(git status | grep "On branch" | cut -d' ' -f3)
	REMOTE_REPO=$(git remote -v | head -n 1 | cut -f1)
	
	
    echo $REMOTE_REPO
    echo "Host *" > ~/.ssh/config
    echo "    StrictHostKeyChecking no" >> ~/.ssh/config
    echo "IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
    echo "yes" | git push $REMOTE_REPO $branch
    git push $REMOTE_REPO "v$NEW_VERSION"
}



branch_=${BRANCH[@]::7}
if [ $branch_ == $RELEASE_BRANCH ]
then
set_version
else
echo "Current branch not release. Yours branch: ${FULL_BRANCH}"
fi

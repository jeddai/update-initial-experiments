#!/bin/bash

git config --global --add safe.directory "/github/workspace/$1"

cd $1
curl $3 | jq --arg APP_NAME "$4" '{"data":map(select(.appName == $APP_NAME))}' > $2

git status
export CHANGED=$(git status -s | wc -l)
export CHANGED_BRANCH=0

if test $CHANGED -eq 1
then
    git add $2
    echo "$CHANGED file(s) have been modified"

    export REMOTE_BRANCH=$(git ls-remote --head origin $5)
    if [[ -z $REMOTE_BRANCH ]];
    then
    export CHANGED_BRANCH=1
    else
    export CHANGED_BRANCH=$(git --no-pager diff origin/$5 | grep $2 | wc -l)
    fi
else
    echo "No changes to make, exiting job"
fi

echo "::set-output name=changed::$CHANGED"
echo "::set-output name=changed-branch::$CHANGED_BRANCH"

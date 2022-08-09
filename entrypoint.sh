#!/bin/sh -l

git config --global --add safe.directory "/github/workspace/$1"

cd $1
git fetch origin $2
git checkout -B $2
curl $4 | jq '{"data":map(select(.appName == "fenix"))}' > $3

git status
export CHANGED=$(git status | grep '$3' | wc -l)

if test $CHANGED -eq 1
then
git add $3
echo "$CHANGED file(s) have been modified"
else
echo "No changes to make, exiting job"
fi
echo "::set-output name=changed::$CHANGED"

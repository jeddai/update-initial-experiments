#!/bin/sh -l

git config --global --add safe.directory "/github/workspace/$1"

cd $1
curl $3 | jq '{"data":map(select(.appName == "$4"))}' >  $2

git status
export CHANGED=$(git status -s | wc -l)

if test $CHANGED -eq 1
then
git add $2
echo "$CHANGED file(s) have been modified"
else
echo "No changes to make, exiting job"
fi
echo "::set-output name=changed::$CHANGED"

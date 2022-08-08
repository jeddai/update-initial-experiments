#!/bin/sh -l

cd $1
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git fetch
git checkout -B automation/update-experiments-json
curl https://experimenter.services.mozilla.com/api/v6/experiments/?is_first_run=True | jq '{"data":map(select(.appName == "fenix"))}' > $2
export CHANGED=$(git status | grep '$2' | wc -l)

if test $CHANGED -eq 1
then
git add $2
echo "$CHANGED file(s) have been modified"
else
echo "No changes to make, exiting job"
fi
echo "::set-output name=changed::$CHANGED"

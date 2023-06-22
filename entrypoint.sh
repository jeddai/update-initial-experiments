#!/bin/bash
DIR="$1"
FILENAME="$2"
URL="$3"
APP_NAME="$4"
BRANCH="$5"

if [[ ! $FILENAME =~ .*\.json ]]; then
    echo "Language of output file is not supported. Please set the output to a JSON file."
    exit 1
fi

git config --global --add safe.directory "/github/workspace/$DIR"
pushd "$DIR" || exit 1

curl "$URL" | jq --arg APP_NAME "$APP_NAME" '{"data":map(select(.appName == $APP_NAME))}' > "$FILENAME"

git status
export CHANGED=$(git status -s | wc -l)
export CHANGED_BRANCH=0

git add $FILENAME
echo "$CHANGED file(s) have been modified"

export REMOTE_BRANCH=$(git ls-remote --head origin $BRANCH)
if [[ -z $REMOTE_BRANCH ]];
then
    export CHANGED_BRANCH=1
    echo "Remote branch currently does not exist; outputting that there are changes."
else
    export CHANGED_BRANCH=$(git --no-pager diff origin/$BRANCH | grep "$FILENAME" | wc -l)
    if test $CHANGED_BRANCH -ge 1
    then
        export CHANGED=1
        echo "Remote branch differs from current changes, it should be updated."
    else
        echo "Remote branch and current changes are equivalent."
    fi
fi

echo "changed=$CHANGED" >> "$GITHUB_OUTPUT"
echo "changed-branch=$CHANGED_BRANCH" >> "$GITHUB_OUTPUT"

popd 2>/dev/null || exit 0

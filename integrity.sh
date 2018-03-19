#!/bin/bash

function updateVersion {
    version=$1

    sed -i "s/VERSION = '.*'/VERSION = '$version'/" ./src/App.vue
    sed -i "s/\"version\": \".*\"/\"version\": \"$version\"/" ./package.json
}

function revert {
    git commit -am 'auto revert commit for rollbacking release changes from memory' && git push
}

currentVersion=$(grep version gradle.properties | sed s/.*=//)

if [ "$1" == "release" ]; then
    updateVersion $currentVersion
elif [ "$1" == "rollback"]; then
    updateVersion $currentVersion
    revert
fi;
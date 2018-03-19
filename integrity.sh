#!/bin/bash

function updateVersion {
    version=$1

    sed -i "s/VERSION = '.*'/VERSION = '$version'/" ./src/App.vue
    sed -i "s/\"version\": \".*\"/\"version\": \"$version\"/" ./package.json
}

function revert {
    git commit -am 'Gradle Release: Automatic revert commit for rollbacking release changes from memory' && git push
}

currentVersion=$(grep version gradle.properties | sed s/.*=//)

if [ "$1" == "release" ]; then
    updateVersion $(echo $currentVersion | sed "s/-SNAPSHOT//")
    rm -rf out/make
    rm -rf build
    yarn electron-forge make
    zip -r out/distributions.zip out/make
    git commit -am 'Gradle Release: Automatic version upgrade' && git push
elif [ "$1" == "rollback" ]; then
    updateVersion $currentVersion
    revert
elif [ "$1" == "update-version" ]; then
    updateVersion $currentVersion
fi;
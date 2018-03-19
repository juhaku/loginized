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
    v=$(echo $currentVersion | sed "s/-SNAPSHOT//")
    updateVersion $v
    rm -rf out/make
    rm -rf build
    yarn electron-forge make
    mv out/make/*.deb out/make/Loginized_$v_x64.deb    
    mv out/make/*.rpm out/make/Loginized_$v_x64.rpm
    mv out/make/*.zip out/make/Loginized_$v_x64.zip
    git commit -am 'Gradle Release: Automatic version upgrade' && git push
elif [ "$1" == "rollback" ]; then
    updateVersion $currentVersion
    revert
elif [ "$1" == "update-version" ]; then
    updateVersion $currentVersion
fi;
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
    RUNTIME=DEB NODE_ENV=production yarn electron-forge make --targets=deb
    RUNTIME=RPM NODE_ENV=production yarn electron-forge make --targets=rpm
    RUNTIME=ALL NODE_ENV=production yarn electron-forge make --targets=zip
    mv out/make/*.deb out/make/Loginized_"$v"_x64.deb    
    mv out/make/*.rpm out/make/Loginized_"$v"_x64.rpm
    mv out/make/*.zip out/make/Loginized_"$v"_x64_all.zip
    # git commit -am 'Gradle Release: Automatic version upgrade' && git push
elif [ "$1" == "release-build" ]; then
    docker build --tag loginized-maker:latest .
    docker run -v "$(pwd)":/build -w "/build" loginized-maker:latest
elif [ "$1" == "rollback" ]; then
    updateVersion $currentVersion
    revert
elif [ "$1" == "update-version" ]; then
    updateVersion $currentVersion
fi;
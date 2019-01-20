#!/bin/bash

function setVersion {
    echo $1 > ./VERSION
    sed -i "s/VERSION = '.*'/VERSION = '$1'/" ./src/constants.ts
    sed -i "s/\"version\": \".*\"/\"version\": \"$1\"/" ./package.json
}

version=`cat VERSION`
releaseVersion=`echo $version | sed "s|-SNAPSHOT||"`

setVersion $releaseVersion

git commit -am '[Automated release commit] release version: '$releaseVersion'' && git push

yarn electron:build
git tag $releaseVersion && git push origin $releaseVersion
# gradle -Pversion=$releaseVersion uploadArchives

nextVersion=`echo $releaseVersion | awk -F . '{print $1"."$2"."$3+1"-SNAPSHOT"}'`

setVersion $nextVersion

git commit -am '[Automated release commit] next version: '$nextVersion'' && git push

echo "DONE!"
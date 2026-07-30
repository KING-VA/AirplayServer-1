#!/usr/bin/env bash

#!/usr/bin/env bash

# GitHub Actions provides JAVA_HOME via actions/setup-java.
echo "Using JAVA_HOME=$JAVA_HOME"
java -version

# Preserve NDK if available.
if [ -n "$ANDROIDNDK_LINUX_R16" ]; then
    export ANDROID_NDK_HOME="$ANDROIDNDK_LINUX_R16"
fi


mkdir -p bin
pushd $(pwd)
cd platforms/android/aps-sdk
echo ++++++++++++++++++++++++++ Building airplay module ++++++++++++++++++++++++++
if [[ "$CI" = "True" ]]; then
    echo Current build environment is CI system, build and upload the artifacts to maven repository.
    export repo=http://maven.oa.com/nexus/content/repositories/thirdparty
    export snapshot_repo=http://maven.oa.com/nexus/content/repositories/thirdparty-snapshots
    export performUploadArchives=true
    ./gradlew clean :airplay:build :airplay:uploadArchives
else
    echo Current build environment is not CI system.
    ./gradlew clean :airplay:build
fi

echo Build done with error code $?
exit $?

#!/bin/sh

#  ci_post_xcodebuild.sh
#  KnockKnock-iOS
#
#  Created by Daye on 2023/01/08.
#  

if
then
    echo "Uploading Firebase Debug Build"
    unzip firebase-tools-macos.zip
    chmod +x ./firebase-tools-macos
    ./firebase-tools-macos appdistribution:distribute $CI_AD_HOC_SIGNED_APP_PATH/KnockKnock-iOS.ipa --app 1:736464449250:ios:6301f64e56d289a66438bb --token $FIREBASE_TOKEN --groups $TESET_GROUP
fi

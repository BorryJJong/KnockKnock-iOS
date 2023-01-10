#!/bin/sh

#  ci_post_clone.sh
#  KnockKnock-iOS
#
#  Created by Daye on 2023/01/08.
#

# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install

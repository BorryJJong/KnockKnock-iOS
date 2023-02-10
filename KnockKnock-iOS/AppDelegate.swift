//
//  AppDelegate.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit

import KakaoSDKCommon
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    self.checkTokenIsValidated()
    KakaoSDK.initSDK(appKey: API.KAKAO_APP_KEY)
    FirebaseApp.configure()

    return true
  }

  private func checkTokenIsValidated() {
    let userDataManager = UserDataManager()

    userDataManager.checkTokenIsValidated(
      completionHandler: { isSuccess in

        if isSuccess {
          NotificationCenter.default.post(
            name: .signInCompleted,
            object: nil
          )
        } else {
          NotificationCenter.default.post(
            name: .signOutCompleted,
            object: nil
          )
        }
      }
    )
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {

    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) { }
}

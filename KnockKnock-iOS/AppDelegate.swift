//
//  AppDelegate.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit

import KakaoSDKCommon
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    KakaoSDK.initSDK(appKey: API.KAKAO_APP_KEY)
    FirebaseApp.configure()
    self.registerRemoteNotification()

    return true
  }

  private func registerRemoteNotification() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    center.requestAuthorization(options: options) { granted, _ in

      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    
    // token check
    //    Messaging.messaging().token { token, error in
    //      if let error = error {
    //        print("Error fetching FCM registration token: \(error)")
    //      } else if let token = token {
    //        print("FCM registration token: \(token)")
    //      }ㅏ
    //    }
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

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    DispatchQueue.main.async {
      DeeplinkNavigator.shared.setNotificationUrl(response: response)
    }
    completionHandler()
  }
}

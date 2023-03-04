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

    self.checkTokenIsValidated()
    KakaoSDK.initSDK(appKey: API.KAKAO_APP_KEY)
    FirebaseApp.configure()
    self.registerRemoteNotification()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(checkNotificationSetting),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )

    return true
  }
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
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

  // MARK: - Push Notification

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {

    let userInfo = response.notification.request.content.userInfo

    guard let deepLinkUrl = userInfo["url"] as? String,
          let url = URL(string: deepLinkUrl) else { return }
    
    DispatchQueue.main.async {
      guard url.host == "navigation" else { return }
      
      DeeplinkNavigator.shared.setUrl(url: url)
    }
    completionHandler()
  }
}

extension AppDelegate {

  @objc
  private func checkNotificationSetting() {
    NotificationCenter.default.post(
      name: .pushSettingUpdated,
      object: nil
    )
  }

  private func registerRemoteNotification() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self

    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    center.requestAuthorization(options: options) { granted, _ in

      DispatchQueue.main.async {
        if granted {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
  }

  private func checkTokenIsValidated() {
    let userDataManager = UserDataManager()

    Task {

      let isValidated = await userDataManager.checkTokenIsValidated()

      await MainActor.run {
        if isValidated {
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
    }
  }
}

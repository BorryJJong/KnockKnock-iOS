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

    NotificationCenter.default.addObserver(
          self,
          selector: #selector(checkNotificationSetting),
          name: UIApplication.willEnterForegroundNotification,
          object: nil
        )

    return true
  }

  @objc private func checkNotificationSetting() {
    UNUserNotificationCenter.current()
      .getNotificationSettings { permission in
        switch permission.authorizationStatus  {
        case .authorized:
          NotificationCenter.default.post(
            name: .pushSettingUpdated,
            object: nil
          )
        case .denied:
          NotificationCenter.default.post(
            name: .pushSettingUpdated,
            object: nil
          )
          // 처리할 것
//        case .notDetermined:
//          print("한 번 허용 누른 경우")
//        case .provisional:
//          print("푸시 수신 임시 중단")
//        case .ephemeral:
//          // @available(iOS 14.0, *)
//          print("푸시 설정이 App Clip에 대해서만 부분적으로 동의한 경우")
        @unknown default:
          print("Unknow Status")
        }
      }
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

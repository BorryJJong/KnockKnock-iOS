//
//  SceneDelegate.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(frame: UIScreen.main.bounds)

    self.window?.windowScene = scene

    self.window?.rootViewController = UIStoryboard(
      name: "LaunchScreen",
      bundle: nil
    ).instantiateInitialViewController()
    self.window?.makeKeyAndVisible()

    let main = MainTabBarController()

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
      self.window?.rootViewController = main
      self.window?.makeKeyAndVisible()
    }

    self.scene(
      scene,
      openURLContexts: connectionOptions.urlContexts
    )
  }

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {

    guard let url = URLContexts.first?.url else { return }

    if AuthApi.isKakaoTalkLoginUrl(url) {
      _ = AuthController.handleOpenUrl(url: url)

    } else {

      guard url.scheme == ShareURL.kakaoScheme,
            url.host == ShareURL.kakaoHost else { return }
      
      DeeplinkNavigator.shared.setUrl(url: url)

    }
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }
}

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

    let main = MainTabBarController()

    self.window?.rootViewController = main
    self.window?.makeKeyAndVisible()

    self.scene(scene, openURLContexts: connectionOptions.urlContexts)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if AuthApi.isKakaoTalkLoginUrl(url) {
        _ = AuthController.handleOpenUrl(url: url)
      } else {
        guard url.scheme == "kakaob9a1e7f94579107a50b5e58c9ce13adc", url.host == "kakaolink" else { return }

        let urlString = url.absoluteString
        guard urlString.contains("feedDetail") else { return }

        let components = URLComponents(string: urlString)
        let urlQueryItems = components?.queryItems ?? []

        var dictionaryData = [String: String]()
        
        urlQueryItems.forEach {
          dictionaryData[$0.name] = $0.value
        }

        guard let feedId = Int(dictionaryData["feedDetail"]?.filter{ $0.isNumber } ?? "") else { return }

        guard let tabBarController = self.window?.rootViewController as? MainTabBarController else { return }

        tabBarController.selectedIndex = Tab.feed.rawValue

        tabBarController.feed.navigationController?.pushViewController(
          FeedDetailRouter.createFeedDetail(feedId: feedId),
          animated: true
        )
      }
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }
}

//
//  SceneDelegate.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let main = MainTabBarController()
    self.window?.rootViewController = main
    self.window?.windowScene = scene
    self.window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) { }
  
  func sceneDidBecomeActive(_ scene: UIScene) { }
  
  func sceneWillResignActive(_ scene: UIScene) { }
  
  func sceneWillEnterForeground(_ scene: UIScene) { }
  
  func sceneDidEnterBackground(_ scene: UIScene) { }
}


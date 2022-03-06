//
//  ViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit

import Then

final class MainTabbarController: UITabBarController {
  
  // MARK: - Tab
  
  enum Tab: Int {
    case home
    case challenge
    case store
    case my
  }
  
  // MARK: - Properties
  
  lazy var tabBarItems: [Tab: UITabBarItem] = [
    .home: UITabBarItem(
      title: "홈",
      image: UIImage(named: "ic_home"),
      selectedImage: UIImage(named: "ic_home")
    ),
    .challenge: UITabBarItem(
      title: "챌린지",
      image: UIImage(named: "ic_challenge"),
      selectedImage: UIImage(named: "ic_challenge")
    ),
    .store: UITabBarItem(
      title: "스토어",
      image: UIImage(named: "ic_store"),
      selectedImage: UIImage(named: "ic_store")
    ),
    .my: UITabBarItem(
      title: "마이",
      image: UIImage(named: "ic_my"),
      selectedImage: UIImage(named: "ic_my")
    )
  ]
  
  let home = HomeViewController()
  let challenge = ChallengeViewController()
  let store = StoreViewController()
  let my = MyViewController()
  
  // MARK: - Initialize
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.attribute()
  }
  
  private func attribute() {
    UITabBar.appearance().tintColor = UIColor.purple
    self.delegate = self
    self.tabBar.do {
      $0.backgroundColor = .white
      $0.tintColor = .black
      $0.barTintColor = .white
      $0.isTranslucent = false
      $0.unselectedItemTintColor = .systemGray2
      $0.standardAppearance.backgroundColor = .white
    }
    
    self.home.tabBarItem = self.tabBarItems[.home]
    self.challenge.tabBarItem = self.tabBarItems[.challenge]
    self.store.tabBarItem = self.tabBarItems[.store]
    self.my.tabBarItem = self.tabBarItems[.my]
    
    let homeNVC = UINavigationController(rootViewController: self.home)
    let challengeNVC = UINavigationController(rootViewController: self.challenge)
    let storeNVC = UINavigationController(rootViewController: self.store)
    let myNVC = UINavigationController(rootViewController: self.my)
    
    self.viewControllers = [
      homeNVC,
      challengeNVC,
      storeNVC,
      myNVC
    ]
  }
}

extension MainTabbarController: UITabBarControllerDelegate {
  
}

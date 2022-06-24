//
//  ViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit
import KKDSKit

import Then

final class MainTabBarController: UITabBarController {
  
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
      image: KKDS.Image.ic_bottom_challenge_27_off,
      selectedImage: KKDS.Image.ic_bottom_home_27_on
    ),
    .challenge: UITabBarItem(
      title: "챌린지",
      image: KKDS.Image.ic_bottom_challenge_27_off,
      selectedImage: KKDS.Image.ic_bottom_challenge_27_on
    ),
    .store: UITabBarItem(
      title: "피드",
      image: KKDS.Image.ic_bottom_store_27_off,
      selectedImage: KKDS.Image.ic_bottom_store_27_on
    ),
    .my: UITabBarItem(
      title: "마이",
      image: KKDS.Image.ic_bottom_my_27_off,
      selectedImage: KKDS.Image.ic_bottom_my_27_on
    )
  ]
  
  let home = HomeViewController()
  let challenge = ChallengeRouter.createChallenge()
  let feed = FeedViewController()
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
    self.feed.tabBarItem = self.tabBarItems[.store]
    self.my.tabBarItem = self.tabBarItems[.my]
    
    let homeNVC = UINavigationController(rootViewController: self.home)
    let challengeNVC = UINavigationController(rootViewController: self.challenge)
    let feedNVC = UINavigationController(rootViewController: self.feed)
    let myNVC = UINavigationController(rootViewController: self.my)
    
    self.viewControllers = [
      homeNVC,
      challengeNVC,
      feedNVC,
      myNVC
    ]
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  
}

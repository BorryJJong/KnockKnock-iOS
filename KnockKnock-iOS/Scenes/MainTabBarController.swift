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
    case feed
    case post
    case challenge
    case my
  }
  
  // MARK: - Properties
  
  lazy var tabBarItems: [Tab: UITabBarItem] = [
    .home: UITabBarItem(
      title: "홈",
      image: KKDS.Image.ic_bottom_home_27_off,
      selectedImage: KKDS.Image.ic_bottom_home_27_on
    ),
    .feed: UITabBarItem(
      title: "검색",
      image: KKDS.Image.ic_bottom_store_27_off,
      selectedImage: KKDS.Image.ic_bottom_store_27_on
    ),
    .post: UITabBarItem(
      title: nil,
      image: KKDS.Image.ic_bottom_more_40.withRenderingMode(.alwaysOriginal),
      selectedImage: KKDS.Image.ic_bottom_more_40.withRenderingMode(.alwaysOriginal)
    ),
    .challenge: UITabBarItem(
      title: "챌린지",
      image: KKDS.Image.ic_bottom_challenge_27_off,
      selectedImage: KKDS.Image.ic_bottom_challenge_27_on
    ),
    .my: UITabBarItem(
      title: "MY",
      image: KKDS.Image.ic_bottom_my_27_off,
      selectedImage: KKDS.Image.ic_bottom_my_27_on
    )
  ]
  
  let home = HomeRouter.createHome()
  let feed = FeedRouter.createFeed()
  let post = FeedWriteViewController()
  let challenge = ChallengeRouter.createChallenge()
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
    self.delegate = self
    self.tabBar.do {
      $0.backgroundColor = .white
      $0.tintColor = .green50
      $0.barTintColor = .white
      $0.isTranslucent = false
      $0.unselectedItemTintColor = .gray60
      $0.standardAppearance.backgroundColor = .white
    }
    
    self.home.tabBarItem = self.tabBarItems[.home]
    self.feed.tabBarItem = self.tabBarItems[.feed]
    self.post.tabBarItem = self.tabBarItems[.post]
    self.post.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -8, right: 0)
    self.challenge.tabBarItem = self.tabBarItems[.challenge]
    self.my.tabBarItem = self.tabBarItems[.my]
    
    let homeNVC = UINavigationController(rootViewController: self.home)
    let feedNVC = UINavigationController(rootViewController: self.feed)
    let postNVC = UINavigationController(rootViewController: self.post)
    let challengeNVC = UINavigationController(rootViewController: self.challenge)
    let myNVC = UINavigationController(rootViewController: self.my)
    
    self.viewControllers = [
      homeNVC,
      feedNVC,
      postNVC,
      challengeNVC,
      myNVC
    ]
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  
}

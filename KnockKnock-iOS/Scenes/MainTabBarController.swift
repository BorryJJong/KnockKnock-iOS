//
//  ViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/02/13.
//

import UIKit

import SnapKit
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
      title: "피드",
      image: KKDS.Image.ic_bottom_store_27_off,
      selectedImage: KKDS.Image.ic_bottom_store_27_on
    ),
    .post: UITabBarItem(
      title: nil,
      image: nil,
      selectedImage: nil
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
  let feed = FeedMainRouter.createFeed()
  let post = FeedWriteRouter.createFeedWrite()
  let challenge = ChallengeRouter.createChallenge()
  let my = MyRouter.createMy()

  lazy var middleButton = UIButton().then {
    $0.frame.size = CGSize(width: 40, height: 40)
    $0.setImage(KKDS.Image.ic_bottom_more_40, for: .normal)
    $0.addTarget(
      self,
      action: #selector(self.middleButtonDidTap),
      for: .touchUpInside
    )
  }

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
    self.setMiddleButton()
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
    self.challenge.tabBarItem = self.tabBarItems[.challenge]
    self.my.tabBarItem = self.tabBarItems[.my]
    
    let homeNVC = UINavigationController(rootViewController: self.home)
    let feedNVC = UINavigationController(rootViewController: self.feed)
    let challengeNVC = UINavigationController(rootViewController: self.challenge)
    let myNVC = UINavigationController(rootViewController: self.my)
    
    self.viewControllers = [
      homeNVC,
      feedNVC,
      UIViewController(),
      challengeNVC,
      myNVC
    ]
  }

  @objc func middleButtonDidTap(_ sender: UIButton) {
    let postNVC = UINavigationController(rootViewController: self.post)
    postNVC.modalPresentationStyle = .fullScreen

    self.present(postNVC, animated: true)
  }

  private func setMiddleButton() {
    self.tabBar.addSubview(middleButton)
    self.middleButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-15)
    }

    self.middleButton.addTarget(
      self,
      action: #selector(self.middleButtonDidTap(_:)),
      for: .touchUpInside
    )
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
      if Tab(rawValue: selectedIndex) == .post {
        return false
      }
    }
    return true
  }
}

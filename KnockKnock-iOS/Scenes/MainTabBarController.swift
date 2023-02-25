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
  
  // MARK: - Properties
  
  lazy var tabBarItems: [Tab: UITabBarItem] = [
    .home: UITabBarItem(
      title: "홈",
      image: KKDS.Image.ic_bottom_home_27_off,
      selectedImage: KKDS.Image.ic_bottom_home_27_on
    ),
    .feed: UITabBarItem(
      title: "피드",
      image: KKDS.Image.ic_bottom_search_27_off,
      selectedImage: KKDS.Image.ic_bottom_search_27_on
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
  let challenge = ChallengeRouter.createChallenge()
  let my = MyRouter.createMy()
  let blankView = UIViewController()

  let postButton = UIButton().then {
    $0.frame.size = CGSize(width: 40, height: 40)
    $0.setImage(KKDS.Image.ic_bottom_more_40, for: .normal)
  }

  private let userDataManager = UserDataManager()

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

  // MARK: - Configure

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
    self.blankView.tabBarItem = self.tabBarItems[.post]
    self.challenge.tabBarItem = self.tabBarItems[.challenge]
    self.my.tabBarItem = self.tabBarItems[.my]
    
    let homeNVC = UINavigationController(rootViewController: self.home)
    let feedNVC = UINavigationController(rootViewController: self.feed)
    let challengeNVC = UINavigationController(rootViewController: self.challenge)
    let myNVC = UINavigationController(rootViewController: self.my)
    
    self.viewControllers = [
      homeNVC,
      feedNVC,
      blankView,
      challengeNVC,
      myNVC
    ]
  }

  private func setMiddleButton() {
    self.tabBar.addSubview(postButton)
    self.postButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-15)
    }

    self.postButton.addTarget(
      self,
      action: #selector(self.postButtonDidTap(_:)),
      for: .touchUpInside
    )
  }

  // MARK: - Button Actions

  @objc func postButtonDidTap(_ sender: UIButton) {

    Task {

        if await self.userDataManager.checkTokenIsValidated() {

          await MainActor.run {
            self.presentFeedWriteView()
          }
        } else {

          await MainActor.run {
            self.navigateToLoginView()
          }
        }

    }
  }

  // MARK: - Routing

  /// 피드 작성 화면 present
  private func presentFeedWriteView() {
    guard let navigationController = self.selectedViewController as? UINavigationController else { return }

    let feedWrite = FeedWriteRouter.createFeedWrite(
      rootView: navigationController
    )
    let feedWriteNVC = UINavigationController(rootViewController: feedWrite)
    feedWriteNVC.modalPresentationStyle = .overFullScreen

    navigationController.present(feedWriteNVC, animated: true)
  }

  /// 비로그인 시 로그인 화면 진입
  private func navigateToLoginView() {
    guard let navigationController = self.selectedViewController as? UINavigationController else { return }

    let loginViewController = LoginRouter.createLoginView()

    loginViewController.hidesBottomBarWhenPushed = true

    navigationController.pushViewController(
      loginViewController,
      animated: true
    )
  }
}

// MARK: - UITabBarController Delegate

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

//
//  DeeplinkNavigator.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/24.
//

import UIKit

final class DeeplinkNavigator {

  static let shared = DeeplinkNavigator()

  private init() { }

  var window: UIWindow?

  func setUrl(url: URL) {

    self.window = UIApplication.shared.windows.first

    guard url.scheme == ShareURL.kakaoScheme,
          url.host == ShareURL.kakaoHost else { return }

    let urlString = url.absoluteString
    let components = URLComponents(string: urlString)
    let urlQueryItems = components?.queryItems ?? []

    var dictionaryData: [String: String] = [:]

    urlQueryItems.forEach {
      dictionaryData[$0.name] = $0.value
    }

    // 첫 번째 urlQueryItem을 이용하여 어떤 화면으로 가야 할지 분기
    guard let queryItem = urlQueryItems.first?.name,
          let queryItemType = ShareQueryItemType(rawValue: queryItem),
          let stringId = dictionaryData[queryItemType.rawValue]?.filter({ $0.isNumber }),
          let id = Int(stringId) else { return }

    switch queryItemType {

    case .feedDetail:
      self.navigateFeedDetail(feedId: id)

    case .challenge:
      self.navigateChallengeDetail(challengeId: id)

    case .feedMain:
      NotificationCenter.default.post(
        name: .pushFeedMain,
        object: Tab.feed.rawValue
      )
    }
  }

  func setNotificationUrl(response: UNNotificationResponse) {

    let userInfo = response.notification.request.content.userInfo

    guard let deepLinkUrl = userInfo["url"] as? String,
          let url = URL(string: deepLinkUrl) else { return }

    guard url.host == "navigation" else { return }

    let urlString = url.absoluteString
    guard urlString.contains("name") else { return }

    let components = URLComponents(string: urlString)

    let urlQueryItems = components?.queryItems ?? []
    var dictionaryData = [String: String]()
    urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }
    guard let name = dictionaryData["name"] else { return }

    let queryItemType = ShareQueryItemType(rawValue: name)

    switch queryItemType {
    default:
      self.navigateFeedMain()
    }
  }

  func navigateFeedDetail(feedId: Int) {

    guard let tabBarController = window?.rootViewController as? MainTabBarController else { return }

    tabBarController.selectedIndex = Tab.feed.rawValue

    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)

    feedDetailViewController.hidesBottomBarWhenPushed = true

    tabBarController.feed.navigationController?.pushViewController(
      feedDetailViewController,
      animated: true
    )
  }

  func navigateChallengeDetail(challengeId: Int) {

    guard let tabBarController = window?.rootViewController as? MainTabBarController else { return }

    tabBarController.selectedIndex = Tab.challenge.rawValue

    let challengeDetailViewController = ChallengeDetailRouter.createChallengeDetail(challengeId: challengeId)

    challengeDetailViewController.hidesBottomBarWhenPushed = true

    tabBarController.challenge.navigationController?.pushViewController(
      challengeDetailViewController,
      animated: true
    )
  }

  func navigateFeedMain() {
    NotificationCenter.default.post(
      name: .pushFeedMain,
      object: Tab.feed.rawValue
    )
  }
}

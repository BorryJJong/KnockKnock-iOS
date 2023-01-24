//
//  DeeplinkNavigator.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/24.
//

import UIKit

final class DeeplinkNavigator {
  
  var window: UIWindow?
  
  func setUrl(window: UIWindow?, url: URL) {
    
    self.window = window
    
    guard url.scheme == ShareURL.kakaoScheme, url.host == ShareURL.kakaoHost else { return }
    
    let urlString = url.absoluteString
    let components = URLComponents(string: urlString)
    let urlQueryItems = components?.queryItems ?? []
    
    var dictionaryData = [String: String]()
    
    urlQueryItems.forEach {
      dictionaryData[$0.name] = $0.value
    }
    
    if urlString.contains(ShareURL.feed) {
      
      guard let stringId = dictionaryData[ShareURL.feed]?.filter({ $0.isNumber }),
            let feedId = Int(stringId) else { return }
      
      self.navigateFeedDetail(feedId: feedId)
      
    } else if urlString.contains(ShareURL.challenge) {
      
      guard let stringId = dictionaryData[ShareURL.challenge]?.filter({ $0.isNumber }),
            let challengeId = Int(stringId) else { return }
      
      self.navigateChallengeDetail(challengeId: challengeId)
    }
  }
  
  func navigateFeedDetail(feedId: Int) {
    
    guard let tabBarController = self.window?.rootViewController as? MainTabBarController else { return }
    
    tabBarController.selectedIndex = Tab.feed.rawValue
    
    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)
    
    feedDetailViewController.hidesBottomBarWhenPushed = true
    
    tabBarController.feed.navigationController?.pushViewController(
      feedDetailViewController,
      animated: true
    )
  }
  
  func navigateChallengeDetail(challengeId: Int) {
    guard let tabBarController = self.window?.rootViewController as? MainTabBarController else { return }
    
    tabBarController.selectedIndex = Tab.challenge.rawValue
    
    let challengeDetailViewController = ChallengeDetailRouter.createChallengeDetail(challengeId: challengeId)
    
    challengeDetailViewController.hidesBottomBarWhenPushed = true
    
    tabBarController.challenge.navigationController?.pushViewController(
      challengeDetailViewController,
      animated: true
    )
  }
}

//
//  FeedSearchWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchWorkerProtocol {
  func getSearchKeywords(completionHandler: @escaping ([SearchKeyword]) -> Void)
}

final class FeedSearchWorker: FeedSearchWorkerProtocol {
  private let userDefaults = UserDefaults.standard
  
  func getSearchKeywords(completionHandler: @escaping ([SearchKeyword]) -> Void) {
    var searchKeywords: [SearchKeyword] = []

    guard let log = userDefaults.object(forKey: "searchLog") as? [[String: Any]] else { return }

    searchKeywords = log.compactMap {
      guard let keyword = $0["keyword"] as? String else { return nil }
      guard let category = $0["category"] as? String else { return nil }
      
      return SearchKeyword(category: category, keyword: keyword)
    }
    completionHandler(searchKeywords)
  }
}

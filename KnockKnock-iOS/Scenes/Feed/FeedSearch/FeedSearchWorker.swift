//
//  FeedSearchWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchWorkerProtocol {
  func getSearchLog(completionHandler: @escaping ([SearchKeyword]) -> Void)
}

final class FeedSearchWorker: FeedSearchWorkerProtocol {
  private let userDefaults = UserDefaults.standard
  
  func getSearchLog(completionHandler: @escaping ([SearchKeyword]) -> Void) {
    var searchKeyword: [SearchKeyword] = []

    guard let log = userDefaults.object(forKey: "searchLog") as? [[String: Any]] else { return }

    searchKeyword = log.compactMap {
      guard let keyword = $0["keyword"] as? String else { return nil }
      guard let category = $0["category"] as? String else { return nil }
      
      return SearchKeyword(category: category, keyword: keyword)
    }
    completionHandler(searchKeyword)
  }
}

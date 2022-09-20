//
//  FeedSearchWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/09/14.
//

import UIKit

protocol FeedSearchWorkerProtocol {
  func getSearchLog(completionHandler: @escaping ([SearchLog]) -> Void)
}

final class FeedSearchWorker: FeedSearchWorkerProtocol {
  private let userDefaults = UserDefaults.standard
  
  func getSearchLog(completionHandler: @escaping ([SearchLog]) -> Void) {
    var searchLog: [SearchLog] = []

    guard let log = userDefaults.object(forKey: "searchLog") as? [[String: Any]] else { return }

    searchLog = log.compactMap {
      guard let regDate = $0["regDate"] as? Date else { return nil }
      guard let keyword = $0["keyword"] as? String else { return nil }
      guard let category = $0["category"] as? String else { return nil }
      return SearchLog(regDate: regDate, category: category, keyword: keyword)
    }
    completionHandler(searchLog)
  }
}

//
//  FeedWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedMainWorkerProtocol: AnyObject {
  func fetchFeedMain(currentPage: Int, pageSize: Int, challengeId: Int, completionHandler: @escaping (FeedMain) -> Void)
  func fetchChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void)
  
  func saveSearchLog(searchLog: SearchLog)
  func getSearchLog(completionHandler: @escaping ([SearchLog]) -> Void)
}

final class FeedMainWorker: FeedMainWorkerProtocol {

  private let repository: FeedRepositoryProtocol
  private let userDefaults = UserDefaults.standard

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func saveSearchLog(searchLog: SearchLog) {
    let log: [String: Any] = [
      "regDate": searchLog.regDate,
      "keyword": searchLog.keyword,
      "category": searchLog.category
    ]
    userDefaults.set(log, forKey: "searchLog")
  }

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

  func fetchFeedMain(
    currentPage: Int,
    pageSize: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedMain) -> Void) {

    repository.requestFeedMain(
      currentPage: currentPage,
      totalCount: pageSize,
      challengeId: challengeId,
      completionHandler: { result in
      completionHandler(result)
    })
  }

  func fetchChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    repository.requestChallengeTitles(completionHandler: { result in
      completionHandler(result)
    })
  }
}

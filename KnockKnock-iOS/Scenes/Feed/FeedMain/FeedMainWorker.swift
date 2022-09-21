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
  
  func saveSearchLog(searchKeyword: [SearchKeyword])
}

final class FeedMainWorker: FeedMainWorkerProtocol {

  private let repository: FeedRepositoryProtocol
  private let userDefaults = UserDefaults.standard

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func saveSearchLog(searchKeyword: [SearchKeyword]) {
    let log = searchKeyword.map {
      [
//        "regDate": $0.regDate,
        "keyword": $0.keyword,
        "category": $0.category
      ]
    }
    userDefaults.set(log, forKey: "searchLog")
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

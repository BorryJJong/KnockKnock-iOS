//
//  FeedWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import Foundation

protocol FeedWorkerProtocol: AnyObject {
  func getFeedMain(currentPage: Int, pageSize: Int, challengeId: Int, completionHandler: @escaping (FeedMain) -> Void)
  func getChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void)
}

final class FeedWorker: FeedWorkerProtocol {

  private let repository: FeedRepositoryProtocol

  init(repository: FeedRepositoryProtocol) {
    self.repository = repository
  }

  func getFeedMain(
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

  func getChallengeTitles(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    repository.requestChallengeTitles(completionHandler: { result in
      completionHandler(result)
    })
  }
}

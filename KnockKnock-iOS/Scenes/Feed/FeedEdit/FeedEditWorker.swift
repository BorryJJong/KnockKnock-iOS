//
//  FeedEditWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditWorkerProtocol {
  func fetchOriginPost(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)
  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void)
  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void)
}

final class FeedEditWorker: FeedEditWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let feedWriterepository: FeedWriteRepositoryProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    feedWriterepository: FeedWriteRepositoryProtocol
  ) {
    self.feedRepository = feedRepository
    self.feedWriterepository = feedWriterepository
  }

  func fetchOriginPost(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      }
    )
  }

  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    self.feedWriterepository.requestPromotionList(completionHandler: { response in
      completionHandler(response)
    })
  }

  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    self.feedWriterepository.requestChallengeTitles(completionHandler: { response in
      completionHandler(response)
    })
  }
}

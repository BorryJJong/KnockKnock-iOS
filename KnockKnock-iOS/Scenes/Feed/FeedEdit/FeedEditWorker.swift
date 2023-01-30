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
  func requestFeedEdit(id: Int, postData: FeedEdit, completionHandler: @escaping (Bool) -> Void)
}

final class FeedEditWorker: FeedEditWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let feedWriteRepository: FeedWriteRepositoryProtocol
  private let feedEditRepository: FeedEditRepositoryProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    feedWriteRepository: FeedWriteRepositoryProtocol,
    feedEditRepository: FeedEditRepositoryProtocol
  ) {
    self.feedRepository = feedRepository
    self.feedWriteRepository = feedWriteRepository
    self.feedEditRepository = feedEditRepository
  }

  func fetchOriginPost(
    feedId: Int,
    completionHandler: @escaping (FeedDetail) -> Void
  ) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      }
    )
  }

  func requestPromotionList(completionHandler: @escaping ([Promotion]) -> Void) {
    self.feedWriteRepository.requestPromotionList(completionHandler: { response in
      completionHandler(response)
    })
  }

  func requestTagList(completionHandler: @escaping ([ChallengeTitle]) -> Void) {
    self.feedWriteRepository.requestChallengeTitles(completionHandler: { response in
      completionHandler(response)
    })
  }

  /// 피드 수정
  ///
  /// - Parameters:
  /// - id: 피드 아이디
  /// - postData: 수정 된 데이터
  func requestFeedEdit(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.feedEditRepository.requestEditFeed(
      id: id,
      postData: postData,
      completionHandler: { isSuccess in
        completionHandler(isSuccess)
      }
    )
  }
}

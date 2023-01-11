//
//  FeedListWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListWorkerProtocol {
  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  )
  func requestDeleteFeed(feedId: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLike(feedId: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLikeCancel(feedId: Int, completionHandler: @escaping (Bool) -> Void)
  func checkTokenExisted(completionHandler: @escaping (Bool) -> Void)
}

final class FeedListWorker: FeedListWorkerProtocol {
  
  private let feedRepository: FeedRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol
  private let localDataManager: UserDataManagerProtocol
  
  init(
    feedRepository: FeedRepositoryProtocol,
    likeRepository: LikeRepositoryProtocol,
    localDataManager: UserDataManagerProtocol
  ) {
    self.feedRepository = feedRepository
    self.likeRepository = likeRepository
    self.localDataManager = localDataManager
  }
  
  func requestDeleteFeed(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.feedRepository.requestDeleteFeed(
      feedId: feedId,
      completionHandler: { isSuccess in
        completionHandler(isSuccess)
      }
    )
  }
  
  func checkTokenExisted(completionHandler: @escaping (Bool) -> Void) {
    let isExisted = self.localDataManager.checkTokenIsExisted()
    completionHandler(isExisted)
  }
  
  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  ) {
    LoadingIndicator.showLoading()
    feedRepository.requestFeedList(
      currentPage: currentPage,
      pageSize: count,
      feedId: feedId,
      challengeId: challengeId,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }
  
  func requestLike(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.likeRepository.requestLike(
      id: feedId,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }
  
  func requestLikeCancel(
    feedId: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.likeRepository.requestLikeCancel(
      id: feedId,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }
}

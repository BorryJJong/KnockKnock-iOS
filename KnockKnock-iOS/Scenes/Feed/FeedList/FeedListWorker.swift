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
  func requestLike(id: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLikeCancel(id: Int, completionHandler: @escaping (Bool) -> Void)
}

final class FeedListWorker: FeedListWorkerProtocol {

  private let repository: FeedRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol

  init(repository: FeedRepositoryProtocol, likeRepository: LikeRepositoryProtocol) {
    self.repository = repository
    self.likeRepository = likeRepository
  }

  func fetchFeedList(
    currentPage: Int,
    count: Int,
    feedId: Int,
    challengeId: Int,
    completionHandler: @escaping (FeedList) -> Void
  ) {
    LoadingIndicator.showLoading()
    repository.requestFeedList(
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
    id: Int,
    completionHandler: @escaping (Bool) -> Void) {
    self.likeRepository.requestLike(
      id: id,
      completionHandler: { result in
      completionHandler(result)
    })
  }

  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping (Bool) -> Void) {
    self.likeRepository.requestLikeCancel(
      id: id,
      completionHandler: { result in
      completionHandler(result)
    })
  }
}

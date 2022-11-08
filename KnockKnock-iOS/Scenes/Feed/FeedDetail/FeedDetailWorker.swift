//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)
  func getAllComments(completionHandler: @escaping ([Comment]) -> Void)
  func getLike(completionHandler: @escaping ([Like]) -> Void)
}

final class FeedDetailWorker: FeedDetailWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let commentRepository: CommentRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    commentRepository: CommentRepositoryProtocol,
    likeRepository: LikeRepositoryProtocol
  ) {
    self.feedRepository = feedRepository
    self.commentRepository = commentRepository
    self.likeRepository = likeRepository
  }

  func getFeedDetail(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        completionHandler(feed)
      })
  }

  func getAllComments(completionHandler: @escaping (([Comment]) -> Void)) {
    self.commentRepository.getComments(completionHandler: { comment in
      completionHandler(comment)
    })
  }

  func getLike(completionHandler: @escaping ([Like]) -> Void) {
    self.likeRepository.getlike(completionHandler: { like in
      completionHandler(like)
    })
  }
}

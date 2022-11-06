//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, complitionHandler: @escaping (FeedDetail) -> Void)
  func getAllComments(complitionHandler: @escaping ([Comment]) -> Void)
  func getLike(complitionHandler: @escaping ([Like]) -> Void)
 

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

  func getFeedDetail(feedId: Int, complitionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        complitionHandler(feed)
      })
  }

  func getAllComments(complitionHandler: @escaping (([Comment]) -> Void)) {
    self.commentRepository.getComments(completionHandler: { comment in
      complitionHandler(comment)
    })
  }

  func getLike(complitionHandler: @escaping ([Like]) -> Void) {
    self.likeRepository.requestLikeList(completionHandler: { like in
      complitionHandler(like)
    })
  }
}

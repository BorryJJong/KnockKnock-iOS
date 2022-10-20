//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, complitionHandler: @escaping (FeedDetail) -> Void)
  func getAllComments(feedId: Int, complitionHandler: @escaping ([Comment]) -> Void)
  func requestAddComment(comment: AddCommentRequest, completionHandler: @escaping (String) -> Void)
  func getLike(complitionHandler: @escaping ([Like]) -> Void)
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

  func getFeedDetail(feedId: Int, complitionHandler: @escaping (FeedDetail) -> Void) {
    self.feedRepository.requestFeedDetail(
      feedId: feedId,
      completionHandler: { feed in
        complitionHandler(feed)
      })
  }

  func getAllComments(feedId: Int, complitionHandler: @escaping (([Comment]) -> Void)) {
    var data: [Comment] = []
    self.commentRepository.requestComments(
      feedId: feedId,
      completionHandler: { comment in
        comment.forEach {
          data.append(Comment(commentData: $0))
        }
        complitionHandler(data)
      }
    )
  }

  func getLike(complitionHandler: @escaping ([Like]) -> Void) {
    self.likeRepository.getlike(completionHandler: { like in
      complitionHandler(like)
    })
  }

  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping ((String) -> Void)
  ) {
    self.commentRepository.requestAddComment(
      comment: comment,
      completionHandler: { response in
        completionHandler(response.message)
      }
    )
  }
}

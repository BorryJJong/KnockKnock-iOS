//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)
  func getLike(completionHandler: @escaping ([Like]) -> Void)
  func getAllComments(feedId: Int, completionHandler: @escaping ([Comment]) -> Void)
  func requestAddComment(comment: AddCommentRequest, completionHandler: @escaping (String) -> Void)
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

  func getFeedDetail(
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

  func getAllComments(
    feedId: Int,
    completionHandler: @escaping ([Comment]) -> Void
  ) {
    var data: [Comment] = []
    self.commentRepository.requestComments(
      feedId: feedId,
      completionHandler: { comment in
        let commentData = comment.map { Comment(commentData: $0) }
        data += commentData

        completionHandler(data)
      }
    )
  }

  func getLike(completionHandler: @escaping ([Like]) -> Void) {
    self.likeRepository.getlike(completionHandler: { like in
      completionHandler(like)
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

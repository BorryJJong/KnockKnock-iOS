//
//  FeedDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/30.
//

import UIKit

protocol FeedDetailWorkerProtocol {
  func getFeedDetail(feedId: Int, completionHandler: @escaping (FeedDetail) -> Void)

  func checkTokenExisted(completionHandler: @escaping (Bool) -> Void)
  
  func requestLike(id: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLikeCancel(id: Int, completionHandler: @escaping (Bool) -> Void)
  func fetchLikeList(feedId: Int, completionHandler: @escaping ([Like.Info]) -> Void)
  func getAllComments(feedId: Int, completionHandler: @escaping ([Comment]) -> Void)
  func requestAddComment(comment: AddCommentDTO, completionHandler: @escaping (Bool) -> Void)
  func requestDeleteComment(commentId: Int, completionHandler: @escaping () -> Void)
}

final class FeedDetailWorker: FeedDetailWorkerProtocol {

  private let feedRepository: FeedRepositoryProtocol
  private let commentRepository: CommentRepositoryProtocol
  private let likeRepository: LikeRepositoryProtocol
  private let userDataManager: UserDataManagerProtocol

  init(
    feedRepository: FeedRepositoryProtocol,
    commentRepository: CommentRepositoryProtocol,
    likeRepository: LikeRepositoryProtocol,
    userDataManager: UserDataManagerProtocol
  ) {
    self.feedRepository = feedRepository
    self.commentRepository = commentRepository
    self.likeRepository = likeRepository
    self.userDataManager = userDataManager
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
        let commentData = comment.map { Comment(data: $0) }
        data += commentData

        completionHandler(data)
      }
    )
  }

  func checkTokenExisted(completionHandler: @escaping (Bool) -> Void) {
    let isExisted = self.userDataManager.checkTokenIsExisted()
    completionHandler(isExisted)
  }

  func requestLike(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.likeRepository.requestLike(
      id: id,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }

  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
      self.likeRepository.requestLikeCancel(
        id: id,
        completionHandler: { result in
          completionHandler(result)
        }
      )
    }


  func fetchLikeList(
    feedId: Int,
    completionHandler: @escaping ([Like.Info]) -> Void
  ) {
    self.likeRepository.requestLikeList(
      feedId: feedId,
      completionHandler: { likeList in
        completionHandler(likeList)
      }
    )
  }

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping ((Bool) -> Void)
  ) {
    self.commentRepository.requestAddComment(
      comment: comment,
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping () -> Void
  ) {
    self.commentRepository.requestDeleteComment(
      commentId: commentId,
      completionHandler: { _ in
        completionHandler()
      }
    )
  }
}

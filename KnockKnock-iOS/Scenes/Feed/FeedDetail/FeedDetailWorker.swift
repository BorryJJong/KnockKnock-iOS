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
  func fetchVisibleComments(comments: [Comment]?) -> [Comment]

  func requestAddComment(comment: AddCommentDTO, completionHandler: @escaping (Bool) -> Void)
  func requestDeleteComment(commentId: Int, completionHandler: @escaping () -> Void)

  func requestDeleteFeed(feedId: Int, completionHandler: @escaping (Bool) -> Void)
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

  /// 전체 댓글에서 삭제된 댓글, 숨김(접힘) 상태 댓글을 제외하고 보여질 댓글만 필터링
  func fetchVisibleComments(comments: [Comment]?) -> [Comment] {
    var visibleComments: [Comment] = []

    guard let comments = comments else { return [] }

    comments.filter({
      !$0.data.isDeleted
    }).forEach { comment in

      if comment.isOpen {
        visibleComments.append(comment)

        let reply = comment.data.reply.map {
          $0.filter { !$0.isDeleted }
        } ?? []

        visibleComments += reply.map {
          Comment(
            data: CommentResponse(
              id: $0.id,
              userId: $0.userId,
              nickname: $0.nickname,
              image: $0.image,
              content: $0.content,
              regDate: $0.regDate,
              isDeleted: $0.isDeleted,
              replyCnt: 0,
              reply: []
            ), isReply: true
          )
        }
      } else {
        if !comment.isReply {
          visibleComments.append(comment)
        }
      }
    }
    return visibleComments
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

//
//  CommentWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentWorkerProtocol {
  func getAllComments(feedId: Int, completionHandler: @escaping ([Comment]) -> Void)
  func requestAddComment(comment: AddCommentDTO, completionHandler: @escaping (Bool) -> Void)
  func fetchVisibleComments(comments: [Comment]?) -> [Comment]
  func requestDeleteComment(commentId: Int, completionHandler: @escaping (Bool) -> Void)
}

final class CommentWorker: CommentWorkerProtocol {

  typealias OnCompletionHandler = (Bool) -> Void

  // MARK: - Properties

  private let repository: CommentRepositoryProtocol?

  // MARK: - Initialize

  init(repository: CommentRepositoryProtocol){
    self.repository = repository
  }

  func getAllComments(
    feedId: Int,
    completionHandler: @escaping ([Comment]) -> Void
  ) {
    var data: [Comment] = []
    self.repository?.requestComments(
      feedId: feedId,
      completionHandler: { comment in
        let commentData = comment.map { Comment(data: $0) }
        data += commentData

        completionHandler(data)
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

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.repository?.requestAddComment(
      comment: comment,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postAddNotificationEvent(feedId: comment.postId)
        }
        completionHandler(isSuccess)
      }
    )
  }

  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    self.repository?.requestDeleteComment(
      commentId: commentId,
      completionHandler: { isSuccess in
        if isSuccess {
          self.postDeleteNotificationEvent(feedId: commentId)
        }
        completionHandler(isSuccess)
      }
    )
  }
}

extension CommentWorker {
  private func postAddNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedListCommentRefreshAfterAdd,
      object: feedId
    )
    NotificationCenter.default.post(
      name: .feedDetailCommentRefreshAfterAdd,
      object: feedId
    )

  }

  private func postDeleteNotificationEvent(feedId: Int) {
    NotificationCenter.default.post(
      name: .feedListCommentRefreshAfterDelete,
      object: feedId
    )
    NotificationCenter.default.post(
      name: .feedDetailCommentRefreshAfterDelete,
      object: feedId
    )
  }
}

//
//  CommentWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentWorkerProtocol {
  func getAllComments(
    feedId: Int,
    completionHandler: @escaping ([Comment]) -> Void
  )
  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping (String) -> Void
  )
  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping () -> Void
  )
}

final class CommentWorker: CommentWorkerProtocol {
  private let repository: CommentRepositoryProtocol

  init(repository: CommentRepositoryProtocol){
    self.repository = repository
  }

  func getAllComments(
    feedId: Int,
    completionHandler: @escaping ([Comment]) -> Void
  ) {
    var data: [Comment] = []
    self.repository.requestComments(
      feedId: feedId,
      completionHandler: { comment in
        let commentData = comment.map { Comment(data: $0) }
        data += commentData

        completionHandler(data)
      }
    )
  }

  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping ((String) -> Void)
  ) {
    self.repository.requestAddComment(
      comment: comment,
      completionHandler: { response in
        completionHandler(response.message)
      }
    )
  }

  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping () -> Void
  ) {
    self.repository.requestDeleteComment(
      commentId: commentId,
      completionHandler: { result in
        completionHandler()
      }
    )
  }
}

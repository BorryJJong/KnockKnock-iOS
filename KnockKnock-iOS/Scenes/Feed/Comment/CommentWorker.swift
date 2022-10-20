//
//  CommentWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/13.
//

import Foundation

protocol CommentWorkerProtocol {
  func getComments(feedId: Int, completionHandler: @escaping ([Comment]) -> Void)
  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping ((String) -> Void)
  )
}

final class CommentWorker: CommentWorkerProtocol {
  private let repository: CommentRepositoryProtocol

  init(repository: CommentRepositoryProtocol){
    self.repository = repository
  }

  func getComments(feedId: Int, completionHandler: @escaping ([Comment]) -> Void) {
    var data: [Comment] = []
    self.repository.requestComments(
      feedId: feedId,
      completionHandler: { result in
        result.forEach {
          data.append(Comment(commentData: $0))
        }
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
}

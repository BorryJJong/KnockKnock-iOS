//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

protocol CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentData]) -> Void)
  func requestAddComment(comment: AddCommentRequest, completionHandler: @escaping (AddCommentResponse) -> Void)
}

final class CommentRepository: CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentData]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: CommentResponse.self,
        router: KKRouter.getComment(id: feedId),
        success: { response in
          if let data = response.data {
            completionHandler(data)
          }
        },
        failure: { error in
          print(error)
        }
      )
  }

  func requestAddComment(
    comment: AddCommentRequest,
    completionHandler: @escaping (AddCommentResponse) -> Void
  ) {
    let parameters = [
      "postId": comment.feedId,
      "userId": comment.userId,
      "content": comment.content,
      "commentId": comment.commentId
    ] as [String: Any]

    KKNetworkManager
      .shared
      .request(
        object: AddCommentResponse.self,
        router: KKRouter.postAddComment(comment: parameters),
        success: { response in
          completionHandler(response)
        },
        failure: { error in
          print(error)
        }
      )
  }
}

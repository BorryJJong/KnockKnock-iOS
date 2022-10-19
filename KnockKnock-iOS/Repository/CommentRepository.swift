//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

protocol CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentData]) -> Void)
  func requestAddComment(feedId: Int, userId: Int, content: String, commentId: Int?)
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

  func requestAddComment(feedId: Int, userId: Int, content: String, commentId: Int?) {
    let parameters = [
      "postId": feedId,
      "userId": userId,
      "content": content,
      "commentId": commentId
    ] as [String: Any]

    KKNetworkManager
      .shared
      .request(
        object: AddCommentResponse.self,
        router: KKRouter.postAddComment(comment: parameters),
        success: { response in
          print("\(response.message)(\(response.code))")
        },
        failure: { error in
          print(error)
        }
      )
  }
}

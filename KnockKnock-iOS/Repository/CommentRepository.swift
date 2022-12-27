//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

protocol CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentResponse.Data]) -> Void)
  func requestAddComment(comment: AddCommentRequest, completionHandler: @escaping (AddCommentResponse) -> Void)
  func requestDeleteComment(commentId: Int, completionHandler: @escaping (DeleteCommentResponse) -> Void)
}

final class CommentRepository: CommentRepositoryProtocol {
  func requestComments(
    feedId: Int,
    completionHandler: @escaping ([CommentResponse.Data]) -> Void
  ) {
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

    do {
      let parameters = try comment.encode()

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

    } catch {
      print(error)
    }
  }

  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping (DeleteCommentResponse) -> Void
  ) {
    let parameters = [
      "id": commentId
    ] as [String: Any]

    KKNetworkManager
      .shared
      .request(
        object: DeleteCommentResponse.self,
        router: KKRouter.deleteComment(id: parameters),
        success: { response in
          completionHandler(response)
        }, failure: { error in
          print(error)
        }
      )
  }
}

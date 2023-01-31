//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

protocol CommentRepositoryProtocol {
  func requestComments(feedId: Int, completionHandler: @escaping ([CommentResponse]) -> Void)
  func requestAddComment(comment: AddCommentDTO, completionHandler: @escaping (Bool) -> Void)
  func requestDeleteComment(commentId: Int, completionHandler: @escaping (Bool) -> Void)
}

final class CommentRepository: CommentRepositoryProtocol {
  func requestComments(
    feedId: Int,
    completionHandler: @escaping ([CommentResponse]) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[CommentResponse]>.self,
        router: KKRouter.getComment(id: feedId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { error in
          print(error)
        }
      )
  }

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping (Bool) -> Void
  ) {

    do {
      let parameters = try comment.encode()

      KKNetworkManager
        .shared
        .request(
          object: ApiResponseDTO<Bool>.self,
          router: KKRouter.postAddComment(comment: parameters),
          success: { response in
            completionHandler(response.code == 200)
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
    completionHandler: @escaping (Bool) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.deleteComment(id: commentId),
        success: { response in
          completionHandler(response.code == 200)
        }, failure: { error in
          print(error)
        }
      )
  }
}

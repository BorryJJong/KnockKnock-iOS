//
//  CommentRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/20.
//

import Foundation

protocol CommentRepositoryProtocol {
  func requestComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  )
  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
}

final class CommentRepository: CommentRepositoryProtocol {

  typealias OnCompletionHandler = (ApiResponse<Bool>?) -> Void

  func requestComments(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Comment]>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[CommentDTO]>.self,
        router: KKRouter.getComment(id: feedId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  func requestAddComment(
    comment: AddCommentDTO,
    completionHandler: @escaping OnCompletionHandler
  ) {

    do {
      let parameters = try comment.encode()

      KKNetworkManager
        .shared
        .request(
          object: ApiResponse<Bool>.self,
          router: KKRouter.postAddComment(comment: parameters),
          success: { response in

            let result = ApiResponse(
              code: response.code,
              message: response.message,
              data: true
            )
            completionHandler(result)

          }, failure: { response, error in

            guard let response = response else {
              completionHandler(nil)
              return
            }

            let result = ApiResponse(
              code: response.code,
              message: response.message,
              data: false
            )
            completionHandler(result)
            print(error.localizedDescription)
          }
        )

    } catch {
      print(error)
    }
  }

  func requestDeleteComment(
    commentId: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.deleteComment(id: commentId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)

        }, failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.code == 200
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}

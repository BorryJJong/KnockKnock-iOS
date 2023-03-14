//
//  LikeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

protocol LikeRepositoryProtocol {
  func requestLike(
    id: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestLikeList(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Like.Info]>?) -> Void
  )
}

final class LikeRepository: LikeRepositoryProtocol {

  typealias OnCompletionHandler = (ApiResponse<Bool>?) -> Void

  func requestLike(
    id: Int,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.postFeedLike(
          id: id
        ), success: { response in

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

  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping OnCompletionHandler
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: KKRouter.deleteFeedLike(
          id: id
        ), success: { response in

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

  func requestLikeList(
    feedId: Int,
    completionHandler: @escaping (ApiResponse<[Like.Info]>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Like>.self,
        router: KKRouter.getLikeList(id: feedId),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.likes
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
            data: response.data?.likes
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}

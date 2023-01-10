//
//  LikeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

protocol LikeRepositoryProtocol {
  func requestLike(id: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLikeCancel(id: Int, completionHandler: @escaping (Bool) -> Void)
  func requestLikeList(feedId: Int, completionHandler: @escaping ([Like.Info]) -> Void)
}

final class LikeRepository: LikeRepositoryProtocol {

  func requestLike(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.postFeedLike(
          id: id
        ), success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        }, failure: { error in
          print(error)
        }
      )
  }

  func requestLikeCancel(
    id: Int,
    completionHandler: @escaping (Bool) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: KKRouter.deleteFeedLike(
          id: id
        ), success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        }, failure: { error in
          print(error)
        }
      )
  }

  func requestLikeList(
    feedId: Int,
    completionHandler: @escaping ([Like.Info]) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Like>.self,
        router: KKRouter.getLikeList(id: feedId),
        success: { response in
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data.likes)
        },
        failure: { error in
          print(error)
        }
      )
  }
}

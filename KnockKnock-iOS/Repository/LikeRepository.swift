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
  func requestLikeList(feedId: Int, completionHandler: @escaping ([LikeInfo]) -> Void)
}

final class LikeRepository: LikeRepositoryProtocol {

  func requestLike(id: Int, completionHandler: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.postFeedLike(
          id: id
        ), success: { result in
          completionHandler(result)
        }, failure: { error in
          print(error)
        }
      )
  }

  func requestLikeCancel(id: Int, completionHandler: @escaping (Bool) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: Bool.self,
        router: KKRouter.postFeedLikeCancel(
          id: id
        ), success: { result in
          completionHandler(result)
        }, failure: { error in
          print(error)
        }
      )
  }
  func requestLikeList(feedId: Int, completionHandler: @escaping ([LikeInfo]) -> Void) {
    KKNetworkManager
      .shared
      .request(
        object: LikeResponse.self,
        router: KKRouter.getLikeList(id: feedId),
        success: { response in
          completionHandler(response.data.likes)
        },
        failure: { error in
          print(error)
        }
      )
  }
}

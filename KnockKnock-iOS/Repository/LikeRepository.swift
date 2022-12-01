//
//  LikeRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/02.
//

import Foundation

protocol LikeRepositoryProtocol {
  func getLikeList(feedId: Int, completionHandler: @escaping ([LikeInfo]) -> Void)
}

final class LikeRepository: LikeRepositoryProtocol {
  func getLikeList(feedId: Int, completionHandler: @escaping ([LikeInfo]) -> Void) {
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

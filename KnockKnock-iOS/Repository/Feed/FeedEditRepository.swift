//
//  FeedEditRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/01/18.
//

import Foundation

protocol FeedEditRepositoryProtocol {
  func requestEditFeed(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (Bool) -> Void
  )
}

final class FeedEditRepository: FeedEditRepositoryProtocol {
  func requestEditFeed(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (Bool) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<Bool>.self,
        router: .putFeed(
          id: id,
          post: postData
        ),
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { response, error in
          print(error)
        }
      )
  }
}

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
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
}

final class FeedEditRepository: FeedEditRepositoryProtocol {

  func requestEditFeed(
    id: Int,
    postData: FeedEdit,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
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

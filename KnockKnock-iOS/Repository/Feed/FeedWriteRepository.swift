//
//  FeedWriteRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/05.
//

import Foundation

protocol FeedWriteRepositoryProtocol {
  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  )
  func requestPromotionList(
    completionHandler: @escaping (ApiResponse<[Promotion]>?) -> Void
  )
  func requestFeedPost(
    postData: FeedWrite,
    completionHandler: @escaping (ApiResponse<Int>?) -> Void
  )
}

final class FeedWriteRepository: FeedWriteRepositoryProtocol {

  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[ChallengeTitleDTO]>.self,
        router: KKRouter.getChallengeTitles,
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

  func requestPromotionList(
    completionHandler: @escaping (ApiResponse<[Promotion]>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[PromotionDTO]>.self,
        router: KKRouter.getPromotions,
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

  func requestFeedPost(
    postData: FeedWrite,
    completionHandler: @escaping (ApiResponse<Int>?) -> Void
  ) {
    KKNetworkManager
      .shared
      .upload(
        object: ApiResponse<FeedWriteDTO>.self,
        router: KKRouter.postFeed(postData: postData),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.id
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
            data: response.data?.id
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}

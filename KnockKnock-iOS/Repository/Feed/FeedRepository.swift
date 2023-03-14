//
//  FeedRepository.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/23.
//

import Foundation

import Alamofire

protocol FeedRepositoryProtocol {

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<FeedMain>?) -> Void
  )

  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  )
}

final class FeedRepository: FeedRepositoryProtocol {

  // MARK: - Feed main APIs

  func requestChallengeTitles(
    completionHandler: @escaping (ApiResponse<[ChallengeTitle]>?) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<[ChallengeTitleDTO]>.self,
        router: .getChallengeTitles,
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

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<FeedMain>?) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponse<FeedMainDTO>.self,
        router: .getFeedMain(
          page: currentPage,
          take: totalCount,
          challengeId: challengeId
        ),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          
          completionHandler(result)
        },

        failure: { response, error in

          guard let response = response else {
            completionHandler(nil)
            return
          }

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )

          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }
}

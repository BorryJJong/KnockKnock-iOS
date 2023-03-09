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
    completionHandler: @escaping (Result<ApiResponseDTO<FeedMain>, NetworkErrorType>) -> Void
  )

  func requestChallengeTitles(
    completionHandler: @escaping (Result<ApiResponseDTO<[ChallengeTitle]>, NetworkErrorType>) -> Void
  )
}

final class FeedRepository: FeedRepositoryProtocol {

  typealias OnCompletionHandler = (Bool) -> Void

  // MARK: - Feed main APIs

  func requestChallengeTitles(
    completionHandler: @escaping (Result<ApiResponseDTO<[ChallengeTitle]>, NetworkErrorType>) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<[ChallengeTitleDTO]>.self,
        router: .getChallengeTitles,
        success: { response in

          let result = ApiResponseDTO(
            code: response.code,
            message: response.message,
            data: response.data?.map { $0.toDomain() }
          )
          completionHandler(.success(result))

        }, failure: { error in
          print(error.localizedDescription)
          completionHandler(.failure(NetworkErrorType.networkFail))
        }
      )
  }

  func requestFeedMain(
    currentPage: Int,
    totalCount: Int,
    challengeId: Int,
    completionHandler: @escaping (Result<ApiResponseDTO<FeedMain>, NetworkErrorType>) -> Void
  ) {

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<FeedMainDTO>.self,
        router: .getFeedMain(
          page: currentPage,
          take: totalCount,
          challengeId: challengeId
        ),
        success: { response in

          let result = ApiResponseDTO(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
          )
          
          completionHandler(.success(result))
        },

        failure: { error in
          print(error.localizedDescription)
          completionHandler(.failure(NetworkErrorType.networkFail))
        }
      )
  }
}

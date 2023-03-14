//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge(
    sortType: String,
    completionHandler: @escaping (ApiResponse<Challenge>?) -> Void
  )
  func requestChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<ChallengeDetail>?) -> Void
  )
}

final class ChallengeRepository: ChallengeRepositoryProtocol {

  func fetchChellenge(
    sortType: String,
    completionHandler: @escaping (ApiResponse<Challenge>?) -> Void
  ) {

    KKNetworkManager.shared
      .request(
        object: ApiResponse<ChallengeDTO>.self,
        router: KKRouter.getChallenges(sort: sortType),
        success: { response in

          let result = ApiResponse(
            code: response.code,
            message: response.message,
            data: response.data?.toDomain()
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
            data: response.data?.toDomain()
          )
          completionHandler(result)
          print(error.localizedDescription)
        }
      )
  }

  func requestChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<ChallengeDetail>?) -> Void) {

      KKNetworkManager.shared
        .request(
          object: ApiResponse<ChallengeDetailDTO>.self,
          router: KKRouter.getChallengeDetail(id: challengeId),
          success: { response in

            let result = ApiResponse(
              code: response.code,
              message: response.message,
              data: response.data?.toDomain()
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
              data: response.data?.toDomain()
            )
            completionHandler(result)
            print(error.localizedDescription)
          }
        )
    }
}

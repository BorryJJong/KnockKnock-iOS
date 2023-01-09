//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void)
  func requestChallengeDetail(challengeId: Int, completionHandler: @escaping (ChallengeDetail) -> Void)
}

final class ChallengeRepository: ChallengeRepositoryProtocol {
  func fetchChellenge(completionHandler: @escaping ([Challenges]) -> Void) {

    KKNetworkManager.shared
      .request(
        object: ApiResponseDTO<[Challenges]>.self,
        router: KKRouter.getChallengeResponse,
        success: { response in
          
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { response in
          print(response)
        }
      )
  }

  func requestChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ChallengeDetail) -> Void) {

      KKNetworkManager.shared
        .request(
          object: ApiResponseDTO<ChallengeDetail>.self,
          router: KKRouter.getChallengeDetail(id: challengeId),
          success: { response in

            guard let data = response.data else {
              // no data error
              return
            }
            completionHandler(data)
          },
          failure: { response in
            print(response)
          }
        )
    }
}

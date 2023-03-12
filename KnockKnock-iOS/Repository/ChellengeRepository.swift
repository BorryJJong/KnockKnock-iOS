//
//  ChellengeRepository.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/04/23.
//

import Foundation

import Alamofire

protocol ChallengeRepositoryProtocol {
  func fetchChellenge(sortType: String, completionHandler: @escaping (Challenge) -> Void)
  func requestChallengeDetail(challengeId: Int, completionHandler: @escaping (ChallengeDetail) -> Void)
}

final class ChallengeRepository: ChallengeRepositoryProtocol {
  func fetchChellenge(sortType: String, completionHandler: @escaping (Challenge) -> Void) {

    KKNetworkManager.shared
      .request(
        object: ApiResponse<Challenge>.self,
        router: KKRouter.getChallenges(sort: sortType),
        success: { response in
          
          guard let data = response.data else {
            // no data error
            return
          }
          completionHandler(data)
        },
        failure: { response, error in
          print(error)
        }
      )
  }

  func requestChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ChallengeDetail) -> Void) {

      KKNetworkManager.shared
        .request(
          object: ApiResponse<ChallengeDetail>.self,
          router: KKRouter.getChallengeDetail(id: challengeId),
          success: { response in

            guard let data = response.data else {
              // no data error
              return
            }
            completionHandler(data)
          },
          failure: { response, error in
            print(error)
          }
        )
    }
}

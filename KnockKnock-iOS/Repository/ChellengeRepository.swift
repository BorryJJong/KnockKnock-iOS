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
        object: [Challenges].self,
        router: KKRouter.getChallengeResponse,
        success: { response in
          completionHandler(response)
        },
        failure: { response in
          print(response)
        })
  }

  func requestChallengeDetail(challengeId: Int, completionHandler: @escaping (ChallengeDetail) -> Void) {
    KKNetworkManager.shared
      .request(
        object: ChallengeDetail.self,
        router: KKRouter.getChallengeDetail(id: challengeId),
        success: { response in
          completionHandler(response)
        },
        failure: { response in
          print(response)
        })
  }
}

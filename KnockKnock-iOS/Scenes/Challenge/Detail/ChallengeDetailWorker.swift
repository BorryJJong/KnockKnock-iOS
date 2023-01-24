//
//  ChallengeDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailWorkerProtocol {
  func getChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ChallengeDetail) -> Void
  )

  func shareChallenge(challengeData: ChallengeDetail?, completionHandler: @escaping (Bool) -> Void)
}

final class ChallengeDetailWorker: ChallengeDetailWorkerProtocol {
  private let repository: ChallengeRepositoryProtocol
  private let kakaoShareManager: KakaoShareManagerProtocol
  
  init(
    repository: ChallengeRepositoryProtocol,
    kakaoShareManager: KakaoShareManagerProtocol
  ) {
    self.repository = repository
    self.kakaoShareManager = kakaoShareManager
  }
  
  func getChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ChallengeDetail) -> Void
  ) {
    repository.requestChallengeDetail(
      challengeId: challengeId,
      completionHandler: { result in
        completionHandler(result)
      }
    )
  }

  func shareChallenge(
    challengeData: ChallengeDetail?,
    completionHandler: @escaping (Bool) -> Void
  ) {

    let result = self.kakaoShareManager.shareChallenge(challengeData: challengeData)
    completionHandler(result)

  }
}

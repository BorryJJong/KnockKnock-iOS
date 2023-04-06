//
//  ChallengeDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import Foundation

protocol ChallengeDetailWorkerProtocol {
  func getChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<ChallengeDetail>?) -> Void
  )

  func shareChallenge(
    challengeData: ChallengeDetail?,
    completionHandler: @escaping (Bool, KakaoShareErrorType?) -> Void
  )
}

final class ChallengeDetailWorker: ChallengeDetailWorkerProtocol {

  // MARK: - Properties

  private let repository: ChallengeRepositoryProtocol
  private let kakaoShareManager: KakaoShareManagerProtocol

  // MARK: - Initialize
  
  init(
    repository: ChallengeRepositoryProtocol,
    kakaoShareManager: KakaoShareManagerProtocol
  ) {
    self.repository = repository
    self.kakaoShareManager = kakaoShareManager
  }
  
  func getChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ApiResponse<ChallengeDetail>?) -> Void
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
    completionHandler: @escaping (Bool, KakaoShareErrorType?) -> Void
  ) {

    guard let challengeData = challengeData else { return }

    let result = self.kakaoShareManager.shareChallenge(challengeData: challengeData)
    completionHandler(result.0, result.1)

  }
}

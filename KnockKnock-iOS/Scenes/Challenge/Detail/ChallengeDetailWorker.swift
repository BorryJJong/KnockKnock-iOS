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
}

final class ChallengeDetailWorker: ChallengeDetailWorkerProtocol {
  private let repository: ChallengeRepositoryProtocol
  
  init(repository: ChallengeRepositoryProtocol) {
    self.repository = repository
  }
  
  func getChallengeDetail(
    challengeId: Int,
    completionHandler: @escaping (ChallengeDetail) -> Void
  ) {
    repository.requestChallengeDetail(
      challengeId: challengeId,
      completionHandler: { result in
        completionHandler(result)
      })
  }
}

//
//  ChallengeWorker.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengeWorkerProtocol: AnyObject {
  func fetchChallenge(completionHandler: @escaping ([Challenges]) -> Void)
}

final class ChallengeWorker: ChallengeWorkerProtocol {
  
  private let repository: ChallengeRepositoryProtocol
  
  init(repository: ChallengeRepositoryProtocol) {
    self.repository = repository
  }
  
  func fetchChallenge(completionHandler: @escaping ([Challenges]) -> Void) {
    repository.fetchChellenge(completionHandler: { result in
      completionHandler(result)
    })
  }
}

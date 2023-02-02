//
//  ChallengeWorker.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengeWorkerProtocol: AnyObject {
  func fetchChallenge(sortType: String, completionHandler: @escaping ([Challenge]) -> Void)
}

final class ChallengeWorker: ChallengeWorkerProtocol {
  
  private let repository: ChallengeRepositoryProtocol
  
  init(repository: ChallengeRepositoryProtocol) {
    self.repository = repository
  }
  
  func fetchChallenge(
    sortType: String,
    completionHandler: @escaping ([Challenge]) -> Void
  ) {
    repository.fetchChellenge(
      sortType: sortType,
      completionHandler: { result in
      completionHandler(result)
    })
  }
}

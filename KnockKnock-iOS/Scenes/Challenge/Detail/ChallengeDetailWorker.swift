//
//  ChallengeDetailWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailWorkerProtocol {
  func getChallengeDetail(completionHandler: @escaping (ChallengeDetail) -> Void)
}

final class ChallengeDetailWorker: ChallengeDetailWorkerProtocol {
  private let repository: ChallengeRepositoryProtocol

  init(repository: ChallengeRepositoryProtocol) {
    self.repository = repository
  }

  func getChallengeDetail(completionHandler: @escaping (ChallengeDetail) -> Void) {
    repository.getChallengeDetail(completionHandler: { result in
      completionHandler(result)
    })
  }
}

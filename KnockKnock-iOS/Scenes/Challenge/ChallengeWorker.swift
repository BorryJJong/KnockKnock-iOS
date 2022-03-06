//
//  ChallengeWorker.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengeWorkerProtocol: AnyObject {
  func fetchChallenge(completionHandler: @escaping () -> Void)
}

final class ChallengeWorker: ChallengeWorkerProtocol {
  
  func fetchChallenge(completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

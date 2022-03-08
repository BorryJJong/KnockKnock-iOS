//
//  ChallengeInteractor.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengeInteractorProtocol: AnyObject {
  var presenter: ChallengePresenterProtocol? { get set }
  var worker: ChallengeWorkerProtocol? { get set }
  
  func fetchChallenge()
}

final class ChallengeInteractor: ChallengeInteractorProtocol {
  
  // MARK: - Properties
  
  var presenter: ChallengePresenterProtocol?
  var worker: ChallengeWorkerProtocol?
  
  func fetchChallenge() {
    self.worker?.fetchChallenge {
      /// do somethings
    }
  }
}

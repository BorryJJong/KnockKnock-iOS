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
  
  func fetchChallenge(sortType: String)
  func presentBottomSheet()
  func navigateToChallengeDetail(challengeId: Int)
}

final class ChallengeInteractor: ChallengeInteractorProtocol {
  
  // MARK: - Properties
  
  var presenter: ChallengePresenterProtocol?
  var worker: ChallengeWorkerProtocol?
  var router: ChallengeRouterProtocol?
  
  func fetchChallenge(sortType: String) {
    self.worker?.fetchChallenge(
      sortType: sortType,
      completionHandler: { [weak self] challenges in
        self?.presenter?.presentFetchChallenge(
          challenges: challenges,
          sortType: sortType
        )
      }
    )
  }

  func presentBottomSheet() {
    self.router?.presentBottomSheet()
  }

  func navigateToChallengeDetail(challengeId: Int) {
    self.router?.navigateToChallengeDetail(challengeId: challengeId)
  }
}

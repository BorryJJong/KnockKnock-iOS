//
//  ChallengeDetailInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailInteractorProtocol {
  var presenter: ChallengeDetailPresenterProtocol? { get set }
  var worker: ChallengeDetailWorkerProtocol? { get set }

  func getChallengeDetail(challengeId: Int)
  func shareChallenge(challengeData: ChallengeDetail?)
}

final class ChallengeDetailInteractor: ChallengeDetailInteractorProtocol {
  var presenter: ChallengeDetailPresenterProtocol?
  var worker: ChallengeDetailWorkerProtocol?
  var router: ChallengeDetailRouter?
  
  func getChallengeDetail(challengeId: Int) {
    self.worker?.getChallengeDetail(
      challengeId: challengeId,
      completionHandler: { challengeDetail in
        self.presenter?.presentChallengeDetail(challengeDetail: challengeDetail)
      })
  }
  
  func shareChallenge(challengeData: ChallengeDetail?) {
    LoadingIndicator.showLoading()
    self.worker?.shareChallenge(
      challengeData: challengeData,
      completionHandler: { isSuccess, error in
      if !isSuccess {
        guard let error = error else { return }

        self.router?.presentErrorAlertView(message: error.message)
      }
    })
  }
}

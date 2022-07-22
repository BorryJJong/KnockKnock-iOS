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

  func getChallengeDetail()
}

final class ChallengeDetailInteractor: ChallengeDetailInteractorProtocol {
  var presenter: ChallengeDetailPresenterProtocol?
  var worker: ChallengeDetailWorkerProtocol?

  func getChallengeDetail() {
    self.worker?.getChallengeDetail { [weak self] challengeDetail in
      self?.presenter?.presentChallengeDetail(challengeDetail: challengeDetail)
    }
  }
}

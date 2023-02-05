//
//  ChallengeDetailPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailPresenterProtocol {
  var view: ChallengeDetailViewProtocol? { get set }

  func presentChallengeDetail(challengeDetail: ChallengeDetail)
}

final class ChallengeDetailPresenter: ChallengeDetailPresenterProtocol {
  var view: ChallengeDetailViewProtocol?

  func presentChallengeDetail(challengeDetail: ChallengeDetail) {
    self.view?.getChallengeDetail(challengeDetail: challengeDetail)
    LoadingIndicator.hideLoading()
  }
}

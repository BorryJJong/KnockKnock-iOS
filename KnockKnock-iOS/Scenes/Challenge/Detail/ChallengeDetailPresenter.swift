//
//  ChallengeDetailPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import Foundation

protocol ChallengeDetailPresenterProtocol {
  var view: ChallengeDetailViewProtocol? { get set }

  func presentChallengeDetail(challengeDetail: ChallengeDetail)

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ChallengeDetailPresenter: ChallengeDetailPresenterProtocol {
  var view: ChallengeDetailViewProtocol?

  func presentChallengeDetail(challengeDetail: ChallengeDetail) {
    self.view?.getChallengeDetail(challengeDetail: challengeDetail)
    LoadingIndicator.hideLoading()
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}

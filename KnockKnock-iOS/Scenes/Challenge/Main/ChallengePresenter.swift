//
//  ChallengePresenter.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengePresenterProtocol: AnyObject {
  var view: ChallengeViewProtocol? { get set }
  
  func presentFetchChallenge(
    challenges: Challenge,
    sortType: ChallengeSortType
  )
  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ChallengePresenter: ChallengePresenterProtocol {
  weak var view: ChallengeViewProtocol?
  
  func presentFetchChallenge(
    challenges: Challenge,
    sortType: ChallengeSortType
  ) {
    self.view?.fetchChallenges(
      challenges: challenges,
      sortType: sortType
    )
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

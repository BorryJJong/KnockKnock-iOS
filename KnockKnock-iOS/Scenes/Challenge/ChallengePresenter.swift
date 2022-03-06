//
//  ChallengePresenter.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import Foundation

protocol ChallengePresenterProtocol: AnyObject {
  var view: ChallengeViewProtocol? { get set }
  
  func presentFetchChallenge()
}

final class ChallengePresenter: ChallengePresenterProtocol {
  weak var view: ChallengeViewProtocol?
  
  func presentFetchChallenge() {
    self.view?.fetchChallenges()
  }
}

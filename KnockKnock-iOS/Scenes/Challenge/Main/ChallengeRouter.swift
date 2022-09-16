//
//  ChallengeRouter.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/03.
//

import UIKit

protocol ChallengeRouterProtocol: AnyObject {
  static func createChallenge() -> UIViewController
  func navigateToChallengeDetail(source: ChallengeViewProtocol, challengeId: Int)
}

final class ChallengeRouter: ChallengeRouterProtocol {
  
  static func createChallenge() -> UIViewController {
    let view = ChallengeViewController()
    let interactor = ChallengeInteractor()
    let presenter = ChallengePresenter()
    let worker = ChallengeWorker(repository: ChallengeRepository())
    let router = ChallengeRouter()
    
    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    
    return view
  }

  func navigateToChallengeDetail(
    source: ChallengeViewProtocol,
    challengeId: Int
  ) {
    let challengeDetailViewController = ChallengeDetailRouter.createChallengeDetail(
      challengeId: challengeId
    )
    challengeDetailViewController.hidesBottomBarWhenPushed = true
    
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        challengeDetailViewController,
        animated: true
      )
    }
  }
}

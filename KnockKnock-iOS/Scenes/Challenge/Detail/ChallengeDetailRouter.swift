//
//  ChallengeDetailRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/22.
//

import UIKit

protocol ChallengeDetailRouterProtocol {
  static func createChallengeDetail() -> UIViewController
}

final class ChallengeDetailRouter: ChallengeDetailRouterProtocol {
  static func createChallengeDetail() -> UIViewController {
    let view = ChallengeDetailViewController()
    let interactor = ChallengeDetailInteractor()
    let presenter = ChallengeDetailPresenter()
    let worker = ChallengeDetailWorker(repository: ChallengeRepository())
    let router = ChallengeDetailRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}

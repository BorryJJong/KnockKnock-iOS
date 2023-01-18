//
//  FeedEditRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditRouterProtocol {
  static func createFeedEdit(feedId: Int) -> UIViewController
}

final class FeedEditRouter: FeedEditRouterProtocol {

  static func createFeedEdit(feedId: Int) -> UIViewController {
    let view = FeedEditViewController()
    let interactor = FeedEditInteractor()
    let presenter = FeedEditPresenter()
    let worker = FeedEditWorker()
    let router = FeedEditRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view

    view.feedId = feedId

    return view
  }
}

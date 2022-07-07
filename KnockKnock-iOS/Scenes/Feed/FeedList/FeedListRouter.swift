//
//  FeedListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListRouterProtocol {
  static func createFeedList() -> UIViewController
}

final class FeedListRouter: FeedListRouterProtocol {
  static func createFeedList() -> UIViewController {
    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(repository: FeedRepository())

    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}

//
//  FeedRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

protocol FeedRouterProtocol {
  static func createFeed() -> UIViewController
  func navigateToFeedList(source: FeedViewProtocol)
}

final class FeedRouter {

  static func createFeed() -> UIViewController {
    let view = FeedViewController()
    let interactor = FeedInteractor()
    let presenter = FeedPresenter()
    let worker = FeedWorker(repository: FeedRepository())
    let router = FeedRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}

extension FeedRouter: FeedRouterProtocol {
  func navigateToFeedList(source: FeedViewProtocol) {
    let feedListViewController = FeedListRouter.createFeedList()
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(feedListViewController, animated: true)
    }
  }
}

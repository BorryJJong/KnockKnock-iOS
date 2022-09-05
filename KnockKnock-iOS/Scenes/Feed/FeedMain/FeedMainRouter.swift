//
//  FeedRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

protocol FeedMainRouterProtocol {
  static func createFeed() -> UIViewController
  func navigateToFeedList(source: FeedMainViewProtocol, index: Int)
}

final class FeedMainRouter {

  static func createFeed() -> UIViewController {
    let view = FeedMainViewController()
    let interactor = FeedMainInteractor()
    let presenter = FeedMainPresenter()
    let worker = FeedMainWorker(repository: FeedRepository())
    let router = FeedMainRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}

extension FeedMainRouter: FeedMainRouterProtocol {
  func navigateToFeedList(source: FeedMainViewProtocol, index: Int) {
    let feedListViewController = FeedListRouter.createFeedList(index: index)
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(feedListViewController, animated: true)
    }
  }
}

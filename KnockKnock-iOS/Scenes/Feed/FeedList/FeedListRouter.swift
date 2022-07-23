//
//  FeedListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/26.
//

import UIKit

protocol FeedListRouterProtocol {
  static func createFeedList() -> UIViewController
  func navigateToFeedDetail(source: FeedListViewProtocol)
}

final class FeedListRouter: FeedListRouterProtocol {
  static func createFeedList() -> UIViewController {
    let view = FeedListViewController()
    let interactor = FeedListInteractor()
    let presenter = FeedListPresenter()
    let worker = FeedListWorker(repository: FeedRepository())
    let router = FeedListRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }

  func navigateToFeedDetail(source: FeedListViewProtocol) {
    let feedDetailViewController = FeedDetailViewController()
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(feedDetailViewController, animated: true)
    }
  }
}

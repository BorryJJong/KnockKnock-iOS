//
//  FeedRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

protocol FeedRouterProtocol {
  static func createFeed() -> UIViewController
  func navigateToFeedList(source: FeedViewController, destination: FeedListViewController)
}

final class FeedRouter {

  static func createFeed() -> UIViewController {
    let view = FeedViewController()
    let interactor = FeedInteractor()
    let presenter = FeedPresenter()
    let worker = FeedWorker()

    view.interactor = interactor
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }
}

extension FeedRouter: FeedRouterProtocol {
  func navigateToFeedList(source: FeedViewController, destination: FeedListViewController) {
    source.show(destination, sender: nil)
  }
}

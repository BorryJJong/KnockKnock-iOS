//
//  FeedWriteRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import UIKit

protocol FeedWriteRouterProtocol: AnyObject {
  static func createFeedWrite() -> UIViewController

  func navigateToShopSearch(source: FeedWriteViewProtocol)
}

final class FeedWriteRouter: FeedWriteRouterProtocol {
  static func createFeedWrite() -> UIViewController {
    let view = FeedWriteViewController()
    let interactor = FeedWriteInteractor()
    let presenter = FeedWritePresenter()
    let worker = FeedWriteWorker()
    let router = FeedWriteRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }

  func navigateToShopSearch(source: FeedWriteViewProtocol) {
    let shopSearchViewController = ShopSearchRouter.createShopSearch()

    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(shopSearchViewController, animated: true)
    }
  }
}

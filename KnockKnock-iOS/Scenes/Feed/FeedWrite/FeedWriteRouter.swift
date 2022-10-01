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
  func navigateToProperty(source: FeedWriteViewProtocol, propertyType: PropertyType)
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
    let shopSearchRouter = ShopSearchRouter()
    let shopSearchViewController = shopSearchRouter.createShopSearch()

    if let sourceView = source as? UIViewController {
      shopSearchRouter.shopSearchDelegate = sourceView as! ShopSearchDelegate
      sourceView.navigationController?.pushViewController(shopSearchViewController, animated: true)
    }
  }

  func navigateToProperty(source: FeedWriteViewProtocol, propertyType: PropertyType) {
    let propertyViewController = PropertySelectViewController()

    if let sourceView = source as? UIViewController {
      propertyViewController.propertyType = propertyType
      sourceView.navigationController?.pushViewController(propertyViewController, animated: true)
    }
  }
}

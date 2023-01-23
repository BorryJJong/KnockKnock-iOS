//
//  FeedWriteRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import UIKit

protocol FeedWriteRouterProtocol: AnyObject {
  static func createFeedWrite() -> UIViewController

  func dismissFeedWriteView(source: FeedWriteViewProtocol)
  func navigateToShopSearch(source: FeedWriteViewProtocol)
  func navigateToProperty(
    source: FeedWriteViewProtocol,
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  )
}

final class FeedWriteRouter: FeedWriteRouterProtocol {

  var shopSearchDelegate: ShopSearchDelegate?
  var propertyDelegate: PropertyDelegate?

  static func createFeedWrite() -> UIViewController {
    let view = FeedWriteViewController()
    let interactor = FeedWriteInteractor()
    let presenter = FeedWritePresenter()
    let worker = FeedWriteWorker(feedWriteRepository: FeedWriteRepository())
    let router = FeedWriteRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.shopSearchDelegate = interactor
    router.propertyDelegate = interactor

    return view
  }

  func navigateToShopSearch(source: FeedWriteViewProtocol) {
    if let delegate = self.shopSearchDelegate {
      let shopSearchViewController = ShopSearchRouter.createShopSearch(delegate: delegate)

      if let sourceView = source as? UIViewController {
        sourceView.navigationController?.pushViewController(shopSearchViewController, animated: true)
      }
    }
  }

  func navigateToProperty(
    source: FeedWriteViewProtocol,
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  ) {
    if let delegate = self.propertyDelegate {
      let propertyViewController = PropertySelectRouter.createPropertySelectView(
        delegate: delegate,
        propertyType: propertyType.self,
        promotionList: promotionList,
        tagList: tagList
      )

      if let sourceView = source as? UIViewController {
        sourceView.navigationController?.pushViewController(propertyViewController, animated: true)
      }
    }
  }

  func dismissFeedWriteView(source: FeedWriteViewProtocol) {
    if let sourceView = source as? UIViewController {
      sourceView.dismiss(animated: true)
      DoneAlerter.hideLoading()
    }
  }
}

//
//  FeedWriteRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import UIKit

protocol FeedWriteRouterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }

  static func createFeedWrite() -> UIViewController

  func dismissFeedWriteView()
  func presenetFeedWriteCompletedView()
  func navigateToShopSearch()
  func navigateToProperty(
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  )
}

final class FeedWriteRouter: FeedWriteRouterProtocol {

  var shopSearchDelegate: ShopSearchDelegate?
  var propertyDelegate: PropertyDelegate?

  weak var view: FeedWriteViewProtocol?

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
    router.view = view

    router.shopSearchDelegate = interactor
    router.propertyDelegate = interactor

    return view
  }

  func navigateToShopSearch() {
    if let delegate = self.shopSearchDelegate {
      let shopSearchViewController = ShopSearchRouter.createShopSearch(delegate: delegate)

      if let sourceView = self.view as? UIViewController {
        sourceView.navigationController?.pushViewController(shopSearchViewController, animated: true)
      }
    }
  }

  func navigateToProperty(
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

      if let sourceView = self.view as? UIViewController {
        sourceView.navigationController?.pushViewController(propertyViewController, animated: true)
      }
    }
  }

  func presenetFeedWriteCompletedView() {
    guard let sourceView = self.view as? UIViewController else { return }

    let feedWriteCompetedViewController = FeedWriteCompletedViewController()

    feedWriteCompetedViewController.modalPresentationStyle = .overFullScreen

    sourceView.navigationController?.present(
      feedWriteCompetedViewController,
      animated: true,
      completion: {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
          feedWriteCompetedViewController.dismiss(
            animated: true,
            completion: self.dismissFeedWriteView
          )
        }
      }
    )
  }

  func dismissFeedWriteView() {
    if let sourceView = self.view as? UIViewController {
      sourceView.dismiss(animated: true)
    }
  }
}

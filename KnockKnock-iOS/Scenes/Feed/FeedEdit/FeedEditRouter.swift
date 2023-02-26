//
//  FeedEditRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/12/18.
//

import UIKit

protocol FeedEditRouterProtocol {
  var view: FeedEditViewProtocol? { get set }

  static func createFeedEdit(feedId: Int) -> UIViewController

  func popFeedEditView()
  func navigateToShopSearch()
  func navigateToProperty(
    propertyType: PropertyType,
    promotionList: [Promotion]?,
    tagList: [ChallengeTitle]?
  )
  func showAlertView(message: String, confirmAction: (() -> Void)?) 
}

final class FeedEditRouter: FeedEditRouterProtocol {

  weak var view: FeedEditViewProtocol?

  var shopSearchDelegate: ShopSearchDelegate?
  var propertyDelegate: PropertyDelegate?

  static func createFeedEdit(feedId: Int) -> UIViewController {
    let view = FeedEditViewController()
    let interactor = FeedEditInteractor()
    let presenter = FeedEditPresenter()
    let worker = FeedEditWorker(
      feedDetailRepository: FeedDetailRepository(),
      feedWriteRepository: FeedWriteRepository(),
      feedEditRepository: FeedEditRepository()
    )
    let router = FeedEditRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view
    router.view = view

    view.feedId = feedId
    router.shopSearchDelegate = interactor
    router.propertyDelegate = interactor

    return view
  }

  func showAlertView(message: String, confirmAction: (() -> Void)?) {
    if let sourceView = self.view as? UIViewController {
      sourceView.showAlert(
        content: message,
        isCancelActive: false,
        confirmActionCompletion: confirmAction
      )
    }
  }

  func popFeedEditView() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
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
}

//
//  FeedWriteRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/18.
//

import UIKit

protocol FeedWriteRouterProtocol: AnyObject {
  var view: FeedWriteViewProtocol? { get set }

  static func createFeedWrite(
    challengeId: Int?,
    rootView: UINavigationController?
  ) -> UIViewController

  func dismissFeedWriteView(feedId: Int?)
  func presenetFeedWriteCompletedView(feedId: Int)
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
  private var rootView: UINavigationController?

  static func createFeedWrite(
    challengeId: Int? = nil,
    rootView: UINavigationController?
  ) -> UIViewController {

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
    interactor.challengeId = challengeId

    router.rootView = rootView

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

  func presenetFeedWriteCompletedView(feedId: Int) {
    guard let sourceView = self.view as? UIViewController else { return }

    let feedWriteCompletedViewController = FeedWriteCompletedViewController()

    feedWriteCompletedViewController.modalPresentationStyle = .overFullScreen

    sourceView.navigationController?.present(
      feedWriteCompletedViewController,
      animated: true,
      completion: {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {

          feedWriteCompletedViewController.dismiss(
            animated: true,
            completion: {
              
              self.dismissFeedWriteView(feedId: feedId)
            }
          )
        }
      }
    )
  }

  func dismissFeedWriteView(feedId: Int? = nil) {
    guard let sourceView = self.view as? UIViewController else { return }

    guard let feedId = feedId else {
      sourceView.dismiss(animated: true)
      return
    }

    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)
    feedDetailViewController.hidesBottomBarWhenPushed = true
    
    sourceView.dismiss(
      animated: true,
      completion: {
        
        self.rootView?.pushViewController(
          feedDetailViewController,
          animated: true
        )
      }
    )
  }
}

//
//  FeedRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/22.
//

import UIKit

protocol FeedMainRouterProtocol {
  var view: FeedMainViewProtocol? { get set }
  
  static func createFeed() -> UIViewController

  func navigateToFeedList(
    feedId: Int,
    challengeId: Int
  )

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) 
}

final class FeedMainRouter: FeedMainRouterProtocol {

  weak var view: FeedMainViewProtocol?

  static func createFeed() -> UIViewController {
    let view = FeedMainViewController()
    let interactor = FeedMainInteractor()
    let presenter = FeedMainPresenter()
    let worker = FeedMainWorker(repository: FeedRepository())
    let router = FeedMainRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view

    return view
  }

  func navigateToFeedList(
    feedId: Int,
    challengeId: Int
  ) {
    let feedListViewController = FeedListRouter.createFeedList(
      feedId: feedId,
      challengeId: challengeId
    )
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        feedListViewController,
        animated: true
      )
    }
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    if let sourceView = self.view as? UIViewController {
      sourceView.showAlert(
        content: message,
        isCancelActive: false,
        confirmActionCompletion: confirmAction
      )
    }
  }
}

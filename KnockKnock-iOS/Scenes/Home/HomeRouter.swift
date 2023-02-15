//
//  HomeRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomeRouterProtocol {
  var view: HomeViewProtocol? { get set }

  static func createHome() -> UIViewController
  
  func navigateToStoreListView()
  func navigateToEventPageView()
  func navigateToFeedDetail(feedId: Int)
}

final class HomeRouter: HomeRouterProtocol {
  weak var view: HomeViewProtocol?

  static func createHome() -> UIViewController {
    let view = HomeViewController()
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let worker = HomeWorker(homeRepository: HomeRepository())
    let router = HomeRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view
    router.view = view

    return view
  }

  func navigateToStoreListView() {
    let storeListViewController = StoreListViewController()

    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        storeListViewController, animated: true)
    }
  }

  func navigateToEventPageView() {
    let eventPageViewController = EventDetailRouter.createEventDetail()

    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.navigationController?.pushViewController(
      eventPageViewController,
      animated: true
    )
  }

  func navigateToFeedDetail(feedId: Int) {
    let feedDetailViewController = FeedDetailRouter.createFeedDetail(feedId: feedId)

    feedDetailViewController.hidesBottomBarWhenPushed = true

    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        feedDetailViewController,
        animated: true
      )
    }
  }
}

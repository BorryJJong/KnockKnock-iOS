//
//  HomeRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/23.
//

import UIKit

protocol HomeRouterProtocol {
  static func createHome() -> UIViewController
  
  func navigateToStoreListView(source: HomeViewProtocol)
  func navigateToEventPageView(source: HomeViewProtocol)
}

final class HomeRouter: HomeRouterProtocol {
  static func createHome() -> UIViewController {
    let view = HomeViewController()
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let worker = HomeWorker()
    let router = HomeRouter()

    view.interactor = interactor
    view.router = router
    interactor.worker = worker
    interactor.presenter = presenter
    presenter.view = view

    return view
  }

  func navigateToStoreListView(source: HomeViewProtocol) {
    let storeListViewController = StoreListViewController()
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        storeListViewController, animated: true)
    }
  }

  func navigateToEventPageView(source: HomeViewProtocol) {
    let eventPageViewController = EventPageViewController()
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        eventPageViewController,
        animated: true
      )
    }
  }
}

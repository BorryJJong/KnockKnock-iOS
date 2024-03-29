//
//  StoreListRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/02/25.
//

import UIKit

final class StoreListRouter: StoreListRouterProtocol {

  // MARK: - Properties

  weak var view: StoreListViewProtocol?

  // MARK: - Routing

  static func createStoreListView() -> UIViewController {
    let view = StoreListViewController()
    let interactor = StoreListInteractor(
      repository: VerifiedStoreRepository()
    )
    let presenter = StoreListPresenter()
    let router = StoreListRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    presenter.view = view
    router.view = view    

    return view
  }

  func navigateToFeedWrite() {

    guard let sourceView = self.view as? UIViewController else { return }

    let feedWriteViewController = UINavigationController(
      rootViewController: FeedWriteRouter.createFeedWrite(
        rootView: sourceView.navigationController
      )
    )

    feedWriteViewController.modalPresentationStyle = .fullScreen

    sourceView.navigationController?.present(feedWriteViewController, animated: true)
    
  }
}

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
    let router = StoreListRouter()

    view.interactor = interactor
    interactor.router = router
    router.view = view    

    return view
  }
}

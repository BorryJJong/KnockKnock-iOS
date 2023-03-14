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

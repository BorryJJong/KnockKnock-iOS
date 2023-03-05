//
//  PolicyRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/05.
//

import UIKit

final class PolicyRouter: PolicyRouterProtocol {

  // MARK: - Properties

  weak var view: PolicyViewProtocol?

  static func createPolicyView(policyType: MyMenuType) -> UIViewController {
    let view = PolicyViewController()
    let interactor = PolicyInteractor()
    let presenter = PolicyPresenter()
    let router = PolicyRouter()

    view.interactor = interactor
    interactor.presenter = presenter
    interactor.router = router
    presenter.view = view
    router.view = view

    interactor.policyType = policyType

    return view
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.showAlert(
      content: message,
      isCancelActive: false,
      confirmActionCompletion: confirmAction
    )
  }

  func popToMyView() {
    guard let sourceView = self.view as? UIViewController else { return }

    sourceView.navigationController?.popViewController(animated: true)
  }
}

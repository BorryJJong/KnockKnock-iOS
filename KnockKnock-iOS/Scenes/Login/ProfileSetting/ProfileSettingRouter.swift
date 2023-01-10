//
//  ProfileSettingRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingRouterProtocol {
  var view: ProfileSettingViewProtocol? { get set }

  static func createProfileSettingView(signInInfo: SignInInfo?) -> UIViewController
  
  func navigateToMyView()
}

final class ProfileSettingRouter: ProfileSettingRouterProtocol {

  weak var view: ProfileSettingViewProtocol?

  static func createProfileSettingView(signInInfo: SignInInfo?) -> UIViewController {
    let view = ProfileSettingViewController()
    let interactor = ProfileSettingInteractor()
    let presenter = ProfileSettingPresenter()
    let worker = ProfileSettingWorker(
      accountManager: AccountManager(),
      localDataManager: UserDataManager()
    )
    let router = ProfileSettingRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view
    router.view = view

    if let signInInfo = signInInfo {
      interactor.signInInfo = signInInfo
    }

    return view
  }

  func navigateToMyView() {
    guard let sourceView = self.view as? UIViewController else { return }
    sourceView.navigationController?.popToRootViewController(animated: true)
  }
}

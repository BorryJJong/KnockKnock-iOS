//
//  ProfileSettingRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingRouterProtocol {
  var view: ProfileSettingViewProtocol? { get set }

  static func createProfileSettingView(
    profileSettingViewType: ProfileSettingViewType,
    signInInfo: SignInInfo?
  ) -> UIViewController
  
  func navigateToMyView()
  func popProfileView()
  func showAlertView(message: String, completion: (() -> Void)?) 
}

final class ProfileSettingRouter: ProfileSettingRouterProtocol {

  weak var view: ProfileSettingViewProtocol?

  static func createProfileSettingView(
    profileSettingViewType: ProfileSettingViewType,
    signInInfo: SignInInfo?
  ) -> UIViewController {
    
    let view = ProfileSettingViewController()
    let interactor = ProfileSettingInteractor()
    let presenter = ProfileSettingPresenter()
    let worker = ProfileSettingWorker(
      accountManager: AccountManager(),
      userDataManager: UserDataManager(),
      profileRepository: ProfileRepository()
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
    view.profileSettingViewType = profileSettingViewType

    return view
  }

  func navigateToMyView() {
    guard let sourceView = self.view as? UIViewController else { return }
    sourceView.navigationController?.popToRootViewController(animated: true)
  }
  
  func popProfileView() {
    guard let sourceView = self.view as? UIViewController else { return }
    sourceView.navigationController?.popViewController(animated: true)
  }

  func showAlertView(message: String, completion: (() -> Void)?) {
    guard let sourceView = self.view as? UIViewController else { return }
    sourceView.showAlert(
      content: message,
      isCancelActive: false,
      confirmActionCompletion: completion
    )
  }
}

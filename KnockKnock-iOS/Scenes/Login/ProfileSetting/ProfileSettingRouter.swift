//
//  ProfileSettingRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingRouterProtocol {
  static func createProfileSettingView(loginInfo: LoginInfo) -> UIViewController
  
  func navigateToMyView(source: ProfileSettingViewProtocol)
}

final class ProfileSettingRouter: ProfileSettingRouterProtocol {
  static func createProfileSettingView(loginInfo: LoginInfo) -> UIViewController {
    let view = ProfileSettingViewController()
    let interactor = ProfileSettingInteractor()
    let presenter = ProfileSettingPresenter()
    let worker = ProfileSettingWorker(
      kakaoAccountManager: KakaoAccountManager(),
      localDataManager: LocalDataManager()
    )
    let router = ProfileSettingRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.loginInfo = loginInfo
    presenter.view = view

    return view
  }

  func navigateToMyView(source: ProfileSettingViewProtocol) {
    guard let sourceView = source as? UIViewController else { return }
    sourceView.navigationController?.popToRootViewController(animated: true)
  }
}

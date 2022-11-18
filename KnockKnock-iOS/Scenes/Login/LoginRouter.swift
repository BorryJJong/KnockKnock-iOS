//
//  LoginRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginRouterProtocol {
  static func createLoginView() -> UIViewController
  func navigateToProfileSettingView(source: LoginViewProtocol, loginInfo: LoginInfo)
  func navigateToHome()
}

final class LoginRouter: LoginRouterProtocol {

  static func createLoginView() -> UIViewController {
    let view = LoginViewController()
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let worker = LoginWorker(
      kakaoAccountManager: KakaoAccountManager(),
      localDataManager: LocalDataManager()
    )
    let router = LoginRouter()

    view.interactor = interactor
    interactor.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }

  func navigateToProfileSettingView(
    source: LoginViewProtocol,
    loginInfo: LoginInfo
  ) {
    let profileSettingViewController = ProfileSettingRouter.createProfileSettingView(
      loginInfo: loginInfo
    )

    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.pushViewController(
        profileSettingViewController,
        animated: true
      )
    }
  }

  // login 성공 시 홈 화면으로 이동
  func navigateToHome() {
    let main = MainTabBarController()

    guard let window = UIApplication.shared.windows.first else { return }

    window.replaceRootViewController(
      main,
      animated: true,
      completion: nil
    )
  }
}

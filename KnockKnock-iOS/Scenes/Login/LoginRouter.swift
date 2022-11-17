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
    let worker = LoginWorker(kakaoAccountManager: KakaoAccountManager())
    let router = LoginRouter()

    view.interactor = interactor
    view.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.view = view

    return view
  }

  func navigateToProfileSettingView(source: LoginViewProtocol, loginInfo: LoginInfo) {
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

  func navigateToHome() {
    let main = MainTabBarController()
    guard let window = UIApplication.shared.windows.first else { return }

    window.replaceRootViewController(main, animated: true, completion: nil)
  }
}

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
  func popLoginView(source: LoginViewProtocol)

  func navigateToSignUp(source: LoginViewProtocol, loginInfo: LoginInfo)
}

final class LoginRouter: LoginRouterProtocol {

  static func createLoginView() -> UIViewController {
    let view = LoginViewController()
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let worker = LoginWorker(
      kakaoAccountManager: KakaoAccountManager(),
      appleAccountManager: AppleAccountManager(),
      snsLoginAccountManager: SNSLoginAccountManager(),
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

  // login 성공 시 홈 화면으로 rootView 변경
  func navigateToHome() {
    let main = MainTabBarController()

    guard let window = UIApplication.shared.windows.first else { return }

    window.replaceRootViewController(
      main,
      animated: true,
      completion: nil
    )
  }

  // 로그인 뷰 탈출
  func popLoginView(source: LoginViewProtocol) {
    if let sourceView = source as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
    NotificationCenter.default.post(name: .loginCompleted, object: nil)
  }

  func navigateToSignUp(source: LoginViewProtocol, loginInfo: LoginInfo) {
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
}

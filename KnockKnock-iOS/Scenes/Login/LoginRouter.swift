//
//  LoginRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginRouterProtocol {
  var view: LoginViewProtocol? { get set }
  static func createLoginView() -> UIViewController
  func navigateToProfileSettingView(loginInfo: LoginInfo)
  func navigateToHome()
  func popLoginView()

  func navigateToSignUp(loginInfo: LoginInfo)
}

final class LoginRouter: LoginRouterProtocol {

  weak var view: LoginViewProtocol?

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
    router.view = view

    return view
  }

  func navigateToProfileSettingView(
    loginInfo: LoginInfo
  ) {
    let profileSettingViewController = ProfileSettingRouter.createProfileSettingView(
      loginInfo: loginInfo
    )

    if let sourceView = self.view as? UIViewController {
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
  func popLoginView() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
    NotificationCenter.default.post(name: .loginCompleted, object: nil)
  }

  func navigateToSignUp(loginInfo: LoginInfo) {
    let profileSettingViewController = ProfileSettingRouter.createProfileSettingView(
      loginInfo: loginInfo
    )

    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        profileSettingViewController,
        animated: true
      )
    }
  }
}

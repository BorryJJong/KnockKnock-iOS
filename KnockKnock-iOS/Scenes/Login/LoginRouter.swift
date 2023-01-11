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
  func navigateToProfileSettingView(signInInfo: SignInInfo)
  func navigateToHome()
  func popLoginView()
}

final class LoginRouter: LoginRouterProtocol {

  weak var view: LoginViewProtocol?

  static func createLoginView() -> UIViewController {
    let view = LoginViewController()
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let worker = LoginWorker(
      kakaoLoginManager: KakaoLoginManager(),
      appleLoginManager: AppleLoginManager(),
      accountManager: AccountManager(),
      localDataManager: UserDataManager()
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

  /// 회원가입을 위해 프로필 설정 뷰로 이동
  /// - Parameters:
  ///  - signInInfo: 로그인 시 입력받은 소셜로그인 정보(socialtype, token)
  func navigateToProfileSettingView(signInInfo: SignInInfo) {
    let profileSettingViewController = ProfileSettingRouter.createProfileSettingView(signInInfo: signInInfo)

    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.pushViewController(
        profileSettingViewController,
        animated: true
      )
    }
  }

  /// login 성공 시 홈 화면으로 rootView 변경
  func navigateToHome() {
    let main = MainTabBarController()

    guard let window = UIApplication.shared.windows.first else { return }

    window.replaceRootViewController(
      main,
      animated: true,
      completion: nil
    )
  }

  /// 로그인 뷰 탈출
  func popLoginView() {
    if let sourceView = self.view as? UIViewController {
      sourceView.navigationController?.popViewController(animated: true)
    }
    NotificationCenter.default.post(name: .signInCompleted, object: nil)
  }
}

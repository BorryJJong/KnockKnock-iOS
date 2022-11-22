//
//  LoginInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginInteractorProtocol {
  var presenter: LoginPresenterProtocol? { get set }
  var worker: LoginWorkerProtocol? { get set }
  var router: LoginRouterProtocol? { get set }

  func fetchLoginResult(source: LoginViewProtocol, socialType: SocialType)
  func saveTokens(loginResponse: LoginResponse)
  func popLoginView(source: LoginViewProtocol)
}

final class LoginInteractor: LoginInteractorProtocol {

  var presenter: LoginPresenterProtocol?
  var worker: LoginWorkerProtocol?
  var router: LoginRouterProtocol?

  func fetchLoginResult(
    source: LoginViewProtocol,
    socialType: SocialType
  ) {
    self.worker?.fetchLoginResult(
      socialType: socialType,
      completionHandler: { loginResponse, loginInfo in

        // 회원 판별
        // 회원 o -> 토큰 저장 후 홈 화면 진입 / 회원 x -> 프로필 설정화면(회원가입)
        if loginResponse.isExistUser {
          self.saveTokens(loginResponse: loginResponse)
          self.navigateToHome()

        } else {
          self.navigateToProfileSettingView(
            source: source,
            loginInfo: loginInfo
          )
        }
      })
  }

  // 로컬에 서버 토큰 저장
  func saveTokens(loginResponse: LoginResponse) {
    if let authInfo = loginResponse.authInfo{
      self.worker?.saveToken(authInfo: authInfo)
    }
  }

  // MARK: - Routing logic
  
  func navigateToProfileSettingView(
    source: LoginViewProtocol,
    loginInfo: LoginInfo
  ) {
    self.router?.navigateToProfileSettingView(
      source: source,
      loginInfo: loginInfo
    )
  }

  func navigateToHome() {
    self.router?.navigateToHome()
  }

  func popLoginView(source: LoginViewProtocol) {
    self.router?.popLoginView(source: source)
  }
}

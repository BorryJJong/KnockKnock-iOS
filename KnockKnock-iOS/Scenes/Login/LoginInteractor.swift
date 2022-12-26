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

  func fetchLoginResult(socialType: SocialType)
  func saveTokens(loginResponse: LoginResponse)
  func popLoginView()
}

protocol AppleLoginResultDelegate: AnyObject {
  func getLoginResult(loginResponse: LoginResponse, loginInfo: LoginInfo)
}

final class LoginInteractor: LoginInteractorProtocol {

  var presenter: LoginPresenterProtocol?
  var worker: LoginWorkerProtocol?
  var router: LoginRouterProtocol?

  func fetchLoginResult(socialType: SocialType) {

    self.worker?.fetchLoginResult(
      appleLoginResultDelegate: self,
      socialType: socialType,
      completionHandler: { loginResponse, loginInfo in

        self.isExistUser(
          loginResponse: loginResponse,
          loginInfo: loginInfo
        )
      }
    )
  }
  
  /// 회원 판별
  /// isExisted: 기존 회원 여부
  /// 회원 o -> 토큰 저장 후 홈 화면 진입 / 회원 x -> 프로필 설정화면(회원가입)
  func isExistUser(loginResponse: LoginResponse, loginInfo: LoginInfo) {

    if loginResponse.isExistUser {
      self.saveTokens(loginResponse: loginResponse)
      self.popLoginView()

      NotificationCenter.default.post(
        name: .loginCompleted,
        object: nil
      )

    } else {
      self.navigateToProfileSettingView(loginInfo: loginInfo)
    }
  }

  // 로컬(UserDefaults)에 서버 토큰 저장
  func saveTokens(loginResponse: LoginResponse) {

    guard let userInfo = loginResponse.userInfo,
          let authInfo = loginResponse.authInfo else { return }

    self.worker?.saveUserInfo(
      userInfo: userInfo,
      authInfo: authInfo
    )
  }

  // MARK: - Routing logic
  
  func navigateToProfileSettingView(loginInfo: LoginInfo) {
    self.router?.navigateToProfileSettingView(loginInfo: loginInfo)
  }

  func navigateToHome() {
    self.router?.navigateToHome()
  }

  func popLoginView() {
    self.router?.popLoginView()
  }
}

// MARK: - Apple login result delegate

extension LoginInteractor: AppleLoginResultDelegate {
  /// Worker -> Interactor로 로그인 결과 전달
  /// loginReseponse: 서버로 부터 받은 로그인 결과 데이터
  /// loginInfo: 비회원인 경우 회원가입 요청 시 사용할 request body
  func getLoginResult(loginResponse: LoginResponse, loginInfo: LoginInfo) {
    self.isExistUser(loginResponse: loginResponse, loginInfo: loginInfo)
  }
}

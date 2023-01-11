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
  func saveTokens(response: AccountResponse)
  func popLoginView()
}

protocol AppleLoginResultDelegate: AnyObject {
  func getSignInResult(response: AccountResponse, signInInfo: SignInInfo)
}

final class LoginInteractor: LoginInteractorProtocol {

  var presenter: LoginPresenterProtocol?
  var worker: LoginWorkerProtocol?
  var router: LoginRouterProtocol?

  func fetchLoginResult(socialType: SocialType) {

    self.worker?.fetchSignInResult(
      appleLoginResultDelegate: self,
      socialType: socialType,
      completionHandler: { response, signInInfo in

        self.checkExistUser(
          response: response,
          signInInfo: signInInfo
        )
      }
    )
  }
  
  /// - 회원 판별 메소드
  ///   - 회원 O: 토큰 저장 후 홈 화면 진입
  ///   - 회원 X: 발급 된 토큰과 함께 프로필 설정 화면 진입(회원가입)
  /// - Parameters:
  ///   - isExisted: 기존 회원 여부
  func checkExistUser(response: AccountResponse, signInInfo: SignInInfo) {

    if response.isExistUser {
      self.saveTokens(response: response)
      self.popLoginView()

      NotificationCenter.default.post(
        name: .signInCompleted,
        object: nil
      )

    } else {
      self.navigateToProfileSettingView(signInInfo: signInInfo)
    }
  }

  /// 로컬(UserDefaults)에 서버 토큰 저장
  /// - Parameters:
  ///   - response: 회원가입/로그인 api response(userinfo)
  func saveTokens(response: AccountResponse) {
    self.worker?.saveUserInfo(response: response)
  }

  // MARK: - Routing logic
  
  func navigateToProfileSettingView(signInInfo: SignInInfo) {
    self.router?.navigateToProfileSettingView(signInInfo: signInInfo)
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
  /// - Parameters:
  ///   - loginReseponse: 서버로 부터 받은 로그인 결과 데이터
  ///   - loginInfo: 비회원인 경우 회원가입 요청 시 사용할 request body
  func getSignInResult(response: AccountResponse, signInInfo: SignInInfo) {
    self.checkExistUser(response: response, signInInfo: signInInfo)
  }
}

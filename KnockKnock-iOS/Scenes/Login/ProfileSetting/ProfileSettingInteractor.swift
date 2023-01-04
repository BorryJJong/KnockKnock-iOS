//
//  ProfileSettingInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingInteractorProtocol {
  var worker: ProfileSettingWorkerProtocol? { get set }
  var presenter: ProfileSettingPresenterProtocol? { get set }
  var router: ProfileSettingRouterProtocol? { get set }

  var signInInfo: SignInInfo? { get set }

  func requestSignUp(nickname: String, image: String)

  func navigateToMyView()
}

final class ProfileSettingInteractor: ProfileSettingInteractorProtocol {

  // MARK: - Properties

  var worker: ProfileSettingWorkerProtocol?
  var presenter: ProfileSettingPresenterProtocol?
  var router: ProfileSettingRouterProtocol?

  var signInInfo: SignInInfo?

  func navigateToMyView() {
    self.router?.navigateToMyView()
  }

  func requestSignUp(
    nickname: String,
    image: String
  ) {
    if let signInInfo = signInInfo {
      self.worker?.requestRegister(
        signInInfo: signInInfo,
        nickname: nickname,
        image: image,
        completionHandler: { response in
          self.saveUserInfo(response: response)
        }
      )
    }
  }

  func saveUserInfo(response: AccountResponse) {

    guard let userInfo = response.userInfo,
          let authInfo = response.authInfo else { return }

    self.worker?.saveUserInfo(
      userInfo: userInfo,
      authInfo: authInfo
    )
  }
}

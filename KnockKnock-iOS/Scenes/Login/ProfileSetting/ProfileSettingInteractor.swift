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
  func popProfileView()
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

  func popProfileView() {
    NotificationCenter.default.post(
      name: .feedRefreshAfterSigned,
      object: nil
    )

    self.router?.popProfileView()
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
    self.worker?.saveUserInfo(response: response)
  }
}

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

  var loginInfo: LoginInfo? { get set }

  func requestSignUp(nickname: String, image: String)
}

final class ProfileSettingInteractor: ProfileSettingInteractorProtocol {

  // MARK: - Properties

  var worker: ProfileSettingWorkerProtocol?
  var presenter: ProfileSettingPresenterProtocol?
  var router: ProfileSettingRouterProtocol?

  var loginInfo: LoginInfo?

  func requestSignUp(
    nickname: String,
    image: String
  ) {
    if let loginInfo = loginInfo {
      self.worker?.requestSignUp(
        loginInfo: loginInfo,
        nickname: nickname,
        image: image,
        completionHandler: { response in
          // userdefaults token 저장하기
          print(response)
        }
      )
    }
  }
}

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

  func requestSignUp(nickname: String, image: UIImage)
  func fetchUserData()

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
    self.router?.popProfileView()
  }

  func fetchUserData() {
    self.worker?.fetchUserData(completionHandler: { [weak self] data in
      self?.presenter?.presenUserData(userData: data)
    })
  }

  func requestSignUp(
    nickname: String,
    image: UIImage
  ) {
    guard let signInInfo = signInInfo else { return }
    let registerInfo = RegisterInfo(
      socialUuid: signInInfo.socialUuid,
      socialType: signInInfo.socialType,
      nickname: nickname,
      image: image
    )

    self.worker?.requestRegister(
      registerInfo: registerInfo,
      completionHandler: { [weak self] response in
        
        guard let isSuccess = self?.worker?.saveUserInfo(response: response) else { return }

        if isSuccess {
          self?.popProfileView()

        } else {
          self?.router?.showErrorAlertView(message: "회원가입에 실패하였습니다.")
        }
      }
    )
  }
}

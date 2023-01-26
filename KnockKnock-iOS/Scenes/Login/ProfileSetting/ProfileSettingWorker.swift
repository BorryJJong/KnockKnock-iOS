//
//  ProfileSettingWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingWorkerProtocol {
  func requestRegister(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (AccountResponse) -> Void
  )
  func fetchUserData(completionHandler: @escaping (UserDetail) -> Void)
  func saveUserInfo(response: AccountResponse) -> Bool
}

final class ProfileSettingWorker: ProfileSettingWorkerProtocol {
  private let accountManager: AccountManagerProtocol
  private let userDataManager: UserDataManagerProtocol
  private let profileRepository: ProfileRepositoryProtocol

  init(
    accountManager: AccountManagerProtocol,
    userDataManager: UserDataManagerProtocol,
    profileRepository: ProfileRepositoryProtocol
  ) {
    self.accountManager = accountManager
    self.userDataManager = userDataManager
    self.profileRepository = profileRepository
  }

  func fetchUserData(completionHandler: @escaping (UserDetail) -> Void) {
    self.profileRepository.requestUserDeatil(completionHandler: { response in
      completionHandler(response)
    })
  }

  func requestRegister(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (AccountResponse) -> Void
  ) {
    
    self.accountManager.register(
      registerInfo: registerInfo,
      completionHandler: { response in

        guard let authInfo = response.authInfo else { return }

        self.userDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
        self.userDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)
      }
    )
  }

  /// UserDefaults에 회원 정보 저장
  ///
  /// - Returns: 성공 여부(Bool)
  func saveUserInfo(response: AccountResponse) -> Bool {

    guard let authInfo = response.authInfo else { return false }

    if let userInfo = response.userInfo {
      self.userDataManager.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.userDataManager.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.userDataManager.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.userDataManager.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

    return true
  }
}

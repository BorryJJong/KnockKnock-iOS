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
  func requestEditProfile(
    nickname: String?,
    image: UIImage?,
    completionHandler: @escaping (Bool) -> Void
  )

  func fetchUserData(completionHandler: @escaping (UserDetail) -> Void)
  func saveUserInfo(response: AccountResponse) -> Bool
  func saveNickname(nickname: String)
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
      completionHandler(response.toDomain())
    })
  }

  func requestRegister(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (AccountResponse) -> Void
  ) {

    self.accountManager.register(
      registerInfo: registerInfo,
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }

  func requestEditProfile(
    nickname: String?,
    image: UIImage?,
    completionHandler: @escaping (Bool) -> Void
  ) {
    self.profileRepository.requestEditProfile(
      nickname: nickname,
      image: image,
      completionHandler: { isSuccess in
        completionHandler(isSuccess)
      }
    )
  }

  /// UserDefaults에 회원 정보 저장
  ///
  /// - Returns: 성공 여부(Bool)
  func saveUserInfo(response: AccountResponse) -> Bool {
    return self.userDataManager.saveUserInfo(response: response)
  }

  func saveNickname(nickname: String) {
    self.userDataManager.saveNickname(nickname: nickname)
  }
}

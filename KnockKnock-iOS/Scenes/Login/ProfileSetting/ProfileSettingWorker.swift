//
//  ProfileSettingWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

protocol ProfileSettingWorkerProtocol {
  func requestRegister(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (ApiResponse<Account>?) -> Void
  )
  func requestEditProfile(
    nickname: String?,
    image: Data?,
    completionHandler: @escaping (String) -> Void
  )
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func isChangedUserData(
    originNickname: String,
    originImage: Data?,
    inputedNickname: String,
    inputedImage: Data?,
    completionHandler: @escaping (String?, Data?) -> Void
  )
  
  func fetchUserData() async -> ApiResponse<UserDetail>?
  func saveUserInfo(response: Account) -> Bool
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
  
  func fetchUserData() async -> ApiResponse<UserDetail>? {
    return await self.profileRepository.requestUserDetail()
  }
  
  func requestRegister(
    registerInfo: RegisterInfo,
    completionHandler: @escaping (ApiResponse<Account>?) -> Void
  ) {
    
    self.accountManager.register(
      registerInfo: registerInfo,
      completionHandler: { response in
        completionHandler(response)
      }
    )
  }
  
  /// nickname, image 중 하나라도 수정 되었는지 판별
  func isChangedUserData(
    originNickname: String,
    originImage: Data?,
    inputedNickname: String,
    inputedImage: Data?,
    completionHandler: @escaping (String?, Data?) -> Void
  ) {
    
    var newNickname: String?
    var newImage: Data?
    
    newNickname = inputedNickname == originNickname
    ? nil : inputedNickname

    newImage = inputedImage == originImage
    ? nil : inputedImage
    
    completionHandler(newNickname, newImage)
  }
  
  func requestEditProfile(
    nickname: String?,
    image: Data?,
    completionHandler: @escaping (String) -> Void
  ) {
    
    self.profileRepository.requestEditProfile(
      nickname: nickname,
      image: image,
      completionHandler: { response in

        let isSuccess = response?.data ?? false

        if isSuccess {
          self.saveNickname(nickname: nickname)
        }
        
        let message = isSuccess ? "프로필 수정에 성공하였습니다." : "프로필 수정에 실패하였습니다."
        completionHandler(message)
      }
    )
  }
  
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    
    self.profileRepository.checkDuplicateNickname(
      nickname: nickname,
      completionHandler: { isDuplicated in
        completionHandler(isDuplicated)
      }
    )
  }
}

extension ProfileSettingWorker {
  
  /// UserDefaults에 회원 정보 저장
  ///
  /// - Returns: 성공 여부(Bool)
  func saveUserInfo(response: Account) -> Bool {
    return self.userDataManager.saveUserInfo(response: response)
  }
  
  private func saveNickname(nickname: String?) {
    guard let nickname = nickname else { return }
    self.userDataManager.saveNickname(nickname: nickname)
  }
}

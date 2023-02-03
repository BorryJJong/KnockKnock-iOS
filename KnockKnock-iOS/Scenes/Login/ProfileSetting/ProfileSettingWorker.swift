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
    completionHandler: @escaping (Bool, String) -> Void
  )
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (Bool) -> Void
  )
  func isChangedUserData(
    originNickname: String,
    originImage: UIImage?,
    inputedNickname: String,
    inputedImage: UIImage?,
    completionHandler: @escaping (String?, UIImage?) -> Void
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
      Task {
        completionHandler(response.toDomain())
      }
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
  
  /// nickname, image 중 하나라도 수정 되었는지 판별
  func isChangedUserData(
    originNickname: String,
    originImage: UIImage?,
    inputedNickname: String,
    inputedImage: UIImage?,
    completionHandler: @escaping (String?, UIImage?) -> Void
  ) {
    
    var newNickname: String?
    var newImage: UIImage?
    
    newNickname = newNickname == originNickname
    ? nil : newNickname
    
    if let inputedImage = inputedImage {
      newImage = inputedImage.isEqualToImage(image: originImage)
      ? nil : inputedImage.resize(newWidth: 100)
    }
    
    completionHandler(newNickname, newImage)
  }
  
  func requestEditProfile(
    nickname: String?,
    image: UIImage?,
    completionHandler: @escaping (Bool, String) -> Void
  ) {
    
    self.profileRepository.requestEditProfile(
      nickname: nickname,
      image: image,
      completionHandler: { isSuccess in
        
        if isSuccess {
          self.saveNickname(nickname: nickname)
        }
        
        let message = isSuccess ? "프로필 수정에 성공하였습니다." : "프로필 수정에 실패하였습니다."
        completionHandler(isSuccess, message)
      }
    )
  }
  
  func checkDuplicateNickname(
    nickname: String,
    completionHandler: @escaping (Bool) -> Void
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
  func saveUserInfo(response: AccountResponse) -> Bool {
    return self.userDataManager.saveUserInfo(response: response)
  }
  
  private func saveNickname(nickname: String?) {
    guard let nickname = nickname else { return }
    self.userDataManager.saveNickname(nickname: nickname)
  }
}

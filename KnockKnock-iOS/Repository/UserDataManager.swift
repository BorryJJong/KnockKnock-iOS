//
//  tokenManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/16.
//

import Foundation

protocol UserDataManagerProtocol {
  var userDefaultsService: UserDefaultsServiceType { get }

  func checkTokenIsExisted() -> Bool
  func removeAllUserInfo()
}

final class UserDataManager: UserDataManagerProtocol {

  var userDefaultsService: UserDefaultsServiceType = UserDefaultsService()

  /// 로컬에 토큰 존재 여부 판별
  func checkTokenIsExisted() -> Bool {
    if userDefaultsService.value(forkey: .accessToken) != nil {
      return true
    } else {
      return false
    }
  }

  func removeAllUserInfo() {
    self.userDefaultsService.remove(forkey: .accessToken)
    self.userDefaultsService.remove(forkey: .refreshToken)
    self.userDefaultsService.remove(forkey: .nickname)
    self.userDefaultsService.remove(forkey: .profileImage)
  }
}

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
  func saveNickname(nickname: String)
  func saveUserInfo(response: AccountResponse)
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

  /// 회원 가입 및 로그인 시 유저 데이터 저장
  func saveUserInfo(response: AccountResponse){

    guard let authInfo = response.authInfo else { return }

    if let userInfo = response.userInfo {
      self.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

    NotificationCenter.default.post(name: .signInCompleted, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterSigned, object: nil)
  }

  /// 프로필 수정 시 닉네임 저장
  func saveNickname(nickname: String) {
    self.userDefaultsService.set(value: nickname, forkey: .nickname)

    NotificationCenter.default.post(name: .profileUpdated, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterSigned, object: nil)
  }

  /// 회원 탈퇴 및 로그아웃 시 유저 데이터 삭제
  func removeAllUserInfo() {
    self.userDefaultsService.remove(forkey: .accessToken)
    self.userDefaultsService.remove(forkey: .refreshToken)
    self.userDefaultsService.remove(forkey: .nickname)
    self.userDefaultsService.remove(forkey: .profileImage)

    NotificationCenter.default.post(name: .signOutCompleted, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterUnsigned, object: nil)
  }
}

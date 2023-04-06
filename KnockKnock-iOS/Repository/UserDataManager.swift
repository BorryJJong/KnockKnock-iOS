//
//  tokenManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/16.
//

import Foundation

protocol UserDataManagerProtocol {
  var userDefaultsService: UserDefaultsServiceType { get }

  func checkTokenIsValidated() async -> Bool
  func removeAllUserInfo()
  func saveNickname(nickname: String)
  func saveUserInfo(response: Account) -> Bool
}

final class UserDataManager: UserDataManagerProtocol {

  var userDefaultsService: UserDefaultsServiceType = UserDefaultsService()

  /// 로컬에 토큰이 존재하는지, 유효한 토큰인지 검증
  func checkTokenIsValidated() async -> Bool {

    guard self.checkTokenIsExisted() else {
      return false
    }

    do {
      let result = try await KKNetworkManager
        .shared
        .asyncRequest(
          object: ApiResponse<Bool>.self,
          router: .getMyPage
        )

      guard let data = result.value else { return false }

      return data.code == 200

    } catch {

      print(error.localizedDescription)
      return false
    }
  }

  /// 회원 가입 및 로그인 시 유저 데이터 저장
  func saveUserInfo(response: Account) -> Bool {

    guard let authInfo = response.authInfo else { return false }

    if let userInfo = response.userInfo {
      self.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

    self.postSignInEvent()

    return true
  }

  /// 프로필 수정 시 닉네임 저장
  func saveNickname(nickname: String) {
    self.userDefaultsService.set(value: nickname, forkey: .nickname)
    
    self.postEditProfileEvent()
  }

  /// 회원 탈퇴 및 로그아웃 시 유저 데이터 삭제
  func removeAllUserInfo() {
    self.userDefaultsService.remove(forkey: .accessToken)
    self.userDefaultsService.remove(forkey: .refreshToken)
    self.userDefaultsService.remove(forkey: .nickname)
    self.userDefaultsService.remove(forkey: .profileImage)

    self.postSignOutEvent()
  }
}

  // MARK: - Inner Actions

extension UserDataManager {

  /// 로컬에 토큰 존재 여부 판별
  private func checkTokenIsExisted() -> Bool {
    if userDefaultsService.value(forkey: .accessToken) != nil {
      return true

    } else {
      return false

    }
  }

  private func postSignInEvent() {
    NotificationCenter.default.post(name: .signInCompleted, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterSigned, object: nil)
    NotificationCenter.default.post(name: .feedMainRefreshAfterSigned, object: nil)
  }

  private func postSignOutEvent() {
    NotificationCenter.default.post(name: .signOutCompleted, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterUnsigned, object: nil)
    NotificationCenter.default.post(name: .feedMainRefreshAfterUnsigned, object: nil)
  }

  private func postEditProfileEvent() {
    NotificationCenter.default.post(name: .profileUpdated, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterSigned, object: nil)
  }
}

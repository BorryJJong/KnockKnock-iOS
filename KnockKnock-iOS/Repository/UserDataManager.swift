//
//  tokenManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/16.
//

import Foundation

protocol UserDataManagerProtocol {
  var userDefaultsService: UserDefaultsServiceType { get }

  func checkTokenIsValidated(completionHandler: @escaping (Bool) -> Void)
  func removeAllUserInfo()
  func saveNickname(nickname: String)
  func saveUserInfo(response: AccountResponse) -> Bool
}

final class UserDataManager: UserDataManagerProtocol {

  var userDefaultsService: UserDefaultsServiceType = UserDefaultsService()

  /// 로컬에 토큰이 존재하는지, 유효한 토큰인지 검증
  func checkTokenIsValidated(completionHandler: @escaping (Bool) -> Void) {

    guard self.checkTokenIsExisted() else {
      completionHandler(false)
      return
    }

    KKNetworkManager
      .shared
      .request(
        object: ApiResponseDTO<Bool>.self,
        router: .getMyPage,
        success: { response in
          completionHandler(response.code == 200)
        },
        failure: { error in
          print(error)
        }
      )
  }

  /// 회원 가입 및 로그인 시 유저 데이터 저장
  func saveUserInfo(response: AccountResponse) -> Bool {

    guard let authInfo = response.authInfo else { return false }

    if let userInfo = response.userInfo {
      self.userDefaultsService.set(value: userInfo.image, forkey: .profileImage)
      self.userDefaultsService.set(value: userInfo.nickname, forkey: .nickname)
    }

    self.userDefaultsService.set(value: authInfo.accessToken, forkey: .accessToken)
    self.userDefaultsService.set(value: authInfo.refreshToken, forkey: .refreshToken)

    NotificationCenter.default.post(name: .signInCompleted, object: nil)
    NotificationCenter.default.post(name: .feedListRefreshAfterSigned, object: nil)

    return true
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
}

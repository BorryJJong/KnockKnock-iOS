//
//  tokenManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/16.
//

import Foundation

protocol LocalDataManagerProtocol {
  func saveToken(accessToken: String, refreshToken: String, nickname: String?)
  func checkTokenIsExisted() -> Bool
}

final class LocalDataManager: LocalDataManagerProtocol {

  /// 회원가입/로그인 시 토큰 저장
  func saveToken(
    accessToken: String,
    refreshToken: String,
    nickname: String?
  ) {
    UserDefaults.standard.set(accessToken, forKey: "accessToken")
    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")

    if let nickname = nickname {
      UserDefaults.standard.set(nickname, forKey: "nickname")
    }
  }

  /// 로그아웃/회원탈퇴 시 로컬에 있는 토큰 삭제
  /// (현재는 테스트 용 임시 기능)
  func deleteToken() {
    UserDefaults.standard.removeObject(forKey: "accessToken")
    UserDefaults.standard.removeObject(forKey: "refreshToken")
  }

  /// 로컬에 토큰 존재 여부 판별
  func checkTokenIsExisted() -> Bool {
    if UserDefaults.standard.object(forKey: "accessToken") as? String != nil {
      return true
    } else {
      return false
    }
  }
}

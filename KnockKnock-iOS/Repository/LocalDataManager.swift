//
//  tokenManager.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/16.
//

import Foundation

protocol LocalDataManagerProtocol {
  func saveToken(accessToken: String, refreshToken: String, nickname: String?)
}

final class LocalDataManager: LocalDataManagerProtocol {

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

  func deleteToken() {
    UserDefaults.standard.removeObject(forKey: "accessToken")
    UserDefaults.standard.removeObject(forKey: "refreshToken")
  }
}

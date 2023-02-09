//
//  MockUserDataManager.swift
//  KnockKnock-iOSTests
//
//  Created by Daye on 2023/02/08.
//

@testable import KnockKnock_iOS

final class MockUserDataManager: UserDataManagerProtocol {

  var userDefaultsService: KnockKnock_iOS.UserDefaultsServiceType = UserDefaultsService()

  func checkTokenIsExisted() -> Bool {
    return true
  }

  func removeAllUserInfo() {
    // no - op
  }

  func saveUserInfo(response: KnockKnock_iOS.AccountResponse) {
    // no - op
  }

  func saveNickname(nickname: String) {
    // no - op
  }
}

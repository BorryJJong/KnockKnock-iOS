//
//  MyWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import UIKit

protocol MyWorkerProtocol {
  func fetchMenuData(completionHandler: @escaping (MyMenu) -> Void)
  func checkSignInStatus(completionHandler: @escaping(Bool) -> Void)
  func fetchNickname(completionHandler: @escaping(String) -> Void)
  func requestSignOut(completionHandler: @escaping() -> Void)
  func requestWithdraw(completionHandler: @escaping() -> Void)
}

final class MyWorker: MyWorkerProtocol {

  private let localDataManager: UserDataManagerProtocol?
  private let accountManager: AccountManagerProtocol?

  init(
    localDataManager: UserDataManagerProtocol,
    accountManager: AccountManagerProtocol
  ) {
    self.localDataManager = localDataManager
    self.accountManager = accountManager
  }

  private let menuData: MyMenu = {
    let profile = MyItem(title: MyMenuType.profile, type: .plain)
    let withdraw = MyItem(title: MyMenuType.withdraw, type: .plain)
    let push = MyItem(title: MyMenuType.pushNotification, type: .alert)

    let notice = MyItem(title: MyMenuType.notice, type: .plain)
    let version = MyItem(title: MyMenuType.versionInfo, type: .version)

    let service = MyItem(title: MyMenuType.serviceTerms, type: .plain)
    let privacy = MyItem(title: MyMenuType.privacy, type: .plain)
    let location = MyItem(title: MyMenuType.locationService, type: .plain)
    let openSource = MyItem(title: MyMenuType.opensource, type: .plain)

    let myInfoSection = MySection(
      title: MySectionType.myInfo,
      myItems: [profile, withdraw, push]
    )
    let customerSection = MySection(
      title: MySectionType.customer,
      myItems: [notice, version]
    )
    let policySection = MySection(
      title: MySectionType.policy,
      myItems: [service, privacy, location, openSource]
    )

    return [myInfoSection, customerSection, policySection]
  }()

  func fetchMenuData(completionHandler: @escaping (MyMenu) -> Void) {
    completionHandler(self.menuData)
  }

  func fetchNickname(completionHandler: @escaping(String) -> Void) {
    guard let nickname = self.localDataManager?.userDefaultsService.value(forkey: .nickname) else {
      return
    }
      completionHandler(nickname)
  }

  func checkSignInStatus(completionHandler: @escaping(Bool) -> Void) {
    if let isSignedIn = self.localDataManager?.checkTokenIsExisted() {
      completionHandler(isSignedIn)
    }
  }

  func requestSignOut(completionHandler: @escaping() -> Void) {
    self.accountManager?.signOut(completionHandler: { [weak self] success in
      if success {
        self?.localDataManager?.removeAllUserInfo()
        completionHandler()
      }
    })
  }

  func requestWithdraw(completionHandler: @escaping() -> Void) {
    self.accountManager?.withdraw(completionHandler: { [weak self] success in
      if success {
        self?.localDataManager?.removeAllUserInfo()
        completionHandler()
      }
    })
  }
}

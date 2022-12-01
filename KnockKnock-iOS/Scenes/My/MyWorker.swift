//
//  MyWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import UIKit

protocol MyWorkerProtocol {
  func fetchMenuData(completionHandler: @escaping (MyMenu) -> Void)
  func checkLoginStatus(completionHandler: @escaping(Bool) -> Void)
  func fetchNickname(completionHandler: @escaping(String) -> Void)
  func requestLogOut(completionHandler: @escaping() -> Void)
  func requestSignOut(completionHandler: @escaping() -> Void)
}

final class MyWorker: MyWorkerProtocol {

  private let localDataManager: LocalDataManagerProtocol?
  private let accountManager: AccountManagerProtocol?

  init(
    localDataManager: LocalDataManagerProtocol,
    accountManager: AccountManagerProtocol
  ) {
    self.localDataManager = localDataManager
    self.accountManager = accountManager
  }

  private let menuData: MyMenu = {
    let profile = MyItem(title: MyMenuType.profile, type: .plain)
    let signout = MyItem(title: MyMenuType.signOut, type: .plain)
    let push = MyItem(title: MyMenuType.pushNotification, type: .alert)

    let notice = MyItem(title: MyMenuType.notice, type: .plain)
    let version = MyItem(title: MyMenuType.versionInfo, type: .version)

    let service = MyItem(title: MyMenuType.serviceTerms, type: .plain)
    let privacy = MyItem(title: MyMenuType.privacy, type: .plain)
    let location = MyItem(title: MyMenuType.locationService, type: .plain)
    let openSource = MyItem(title: MyMenuType.opensource, type: .plain)

    let myInfoSection = MySection(
      title: MySectionType.myInfo,
      myItems: [profile, signout, push]
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
    if let nickname = self.localDataManager?.fetchNickname() {
      completionHandler(nickname)
    }
  }

  func checkLoginStatus(completionHandler: @escaping(Bool) -> Void) {
    if let isLoggedIn = self.localDataManager?.checkTokenIsExisted() {
      completionHandler(isLoggedIn)
    }
  }

  func requestLogOut(completionHandler: @escaping() -> Void) {
    self.accountManager?.logOut(completionHanlder: { success in
      if success {
        self.localDataManager?.deleteToken()
        completionHandler()
      }
    })
  }

  func requestSignOut(completionHandler: @escaping() -> Void) {
    self.accountManager?.signOut(completionHanlder: { success in
      if success {
        self.localDataManager?.deleteToken()
        self.localDataManager?.deleteNickname()
        completionHandler()
      }
    })
  }
}

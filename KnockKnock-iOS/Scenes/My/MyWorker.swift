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
}

final class MyWorker: MyWorkerProtocol {

  private let localDataManager: LocalDataManager?

  init(localDataManager: LocalDataManager) {
    self.localDataManager = localDataManager
  }

  private let menuData: MyMenu = {
    let profile = MyItem(title: MyMenuType.profile.rawValue, type: .plain)
    let signout = MyItem(title: MyMenuType.signOut.rawValue, type: .plain)
    let push = MyItem(title: MyMenuType.pushNotification.rawValue, type: .alert)

    let notice = MyItem(title: MyMenuType.notice.rawValue, type: .plain)
    let version = MyItem(title: MyMenuType.versionInfo.rawValue, type: .version)

    let service = MyItem(title: MyMenuType.serviceTerms.rawValue, type: .plain)
    let privacy = MyItem(title: MyMenuType.privacy.rawValue, type: .plain)
    let location = MyItem(title: MyMenuType.locationService.rawValue, type: .plain)
    let openSource = MyItem(title: MyMenuType.opensource.rawValue, type: .plain)

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
}

//
//  MyWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import Foundation

protocol MyWorkerProtocol {
  func fetchMenuData(
    isSignedIn: Bool,
    completionHandler: @escaping (MyMenu) -> Void
  )
  func fetchNickname(
    completionHandler: @escaping(String) -> Void
  )
  func requestSignOut()
  func requestWithdraw()
}

final class MyWorker: MyWorkerProtocol {

  private let userDataManager: UserDataManagerProtocol?
  private let accountManager: AccountManagerProtocol?

  init(
    userDataManager: UserDataManagerProtocol,
    accountManager: AccountManagerProtocol
  ) {
    self.userDataManager = userDataManager
    self.accountManager = accountManager
  }

  private let menuData: MyMenu = {
    let profile = MyItem(title: .profile, type: .plain)
    let withdraw = MyItem(title: .withdraw, type: .plain)
    let push = MyItem(title: .pushNotification, type: .alert)

    let notice = MyItem(title: .notice, type: .plain)
    let version = MyItem(title: .versionInfo, type: .version)

    let service = MyItem(title: .serviceTerms, type: .plain)
    let privacy = MyItem(title: .privacy, type: .plain)
    let location = MyItem(title: .locationService, type: .plain)
    let openSource = MyItem(title: .opensource, type: .plain)

    let myInfoSection = MySection(
      title: .myInfo,
      myItems: [profile, withdraw, push]
    )
    let customerSection = MySection(
      title: .customer,
      myItems: [notice, version]
    )
    let policySection = MySection(
      title: .policy,
      myItems: [service, privacy, location, openSource]
    )

    return [myInfoSection, customerSection, policySection]
  }()

  func fetchMenuData(
    isSignedIn: Bool,
    completionHandler: @escaping (MyMenu) -> Void
  ) {
    var menuData = self.menuData

    guard let myInfoIndex = menuData.firstIndex(where: {
      $0.title == MySectionType.myInfo
    }) else { return }

    if !isSignedIn {
      menuData[myInfoIndex].myItems = [
        MyItem(
          title: .pushNotification,
          type: .alert
        )
      ]
    }
    completionHandler(menuData)
  }

  func fetchNickname(
    completionHandler: @escaping(String) -> Void
  ) {
    guard let nickname = self.userDataManager?.userDefaultsService.value(forkey: .nickname) else {
      return
    }
      completionHandler(nickname)
  }

  func requestSignOut() {
    self.accountManager?.signOut(
      completionHandler: { [weak self] success in
      if success {
        self?.userDataManager?.removeAllUserInfo()
      } else {
        // error
      }
    })
  }

  func requestWithdraw() {
    self.accountManager?.withdraw(
      completionHandler: { [weak self] success in
      if success {
        self?.userDataManager?.removeAllUserInfo()
      } else {
        // error
      }
    })
  }
}

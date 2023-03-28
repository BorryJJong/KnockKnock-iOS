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
  func requestSignOut(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
  func requestWithdraw(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  )
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

    let version = MyItem(title: .versionInfo, type: .version)

    let privacy = MyItem(title: .privacy, type: .plain)
    let openSource = MyItem(title: .opensource, type: .plain)

    let myInfoSection = MySection(
      title: .myInfo,
      myItems: [profile, withdraw, push]
    )
    let customerSection = MySection(
      title: .customer,
      myItems: [version]
    )
    let policySection = MySection(
      title: .policy,
      myItems: [privacy, openSource]
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

  func requestSignOut(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    self.accountManager?.signOut(
      completionHandler: { [weak self] response in
        if let isSuccess = response?.data {
          if isSuccess {
            self?.userDataManager?.removeAllUserInfo()
          }
        }
        completionHandler(response)
      }
    )
  }

  func requestWithdraw(
    completionHandler: @escaping (ApiResponse<Bool>?) -> Void
  ) {
    self.accountManager?.withdraw(
      completionHandler: { [weak self] response in
        if let isSuccess = response?.data {
          if isSuccess {
            self?.userDataManager?.removeAllUserInfo()
          }
        }
        completionHandler(response)
      }
    )
  }
}

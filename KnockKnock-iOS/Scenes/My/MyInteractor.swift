//
//  MyInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import Foundation

protocol MyInteractorProtocol {
  var router: MyRouterProtocol? { get set }
  var worker: MyWorkerProtocol? { get set }
  var presenter: MyPresenter? { get set }

  func fetchMenuData()
  func fetchNickname() 
  func requestSignOut()
  func requestWithdraw()

  func navigateToLoginView()
  func navigateToNoticeView()
  func navigateToProfileSettingView()
}

final class MyInteractor: MyInteractorProtocol {

  // MARK: - Properties

  var router: MyRouterProtocol?
  var worker: MyWorkerProtocol?
  var presenter: MyPresenter?

  // MARK: - Initailize

  init() {
    self.setNotification()
  }

  // Busniess Logic

  func fetchMenuData() {
    self.worker?.fetchMenuData(
      completionHandler: { [weak self] menu in
        self?.presenter?.presentMenuData(myMenu: menu)
      }
    )
    self.setNotification()
  }

  func fetchNickname() {
    self.worker?.fetchNickname(
      completionHandler: { [weak self] nickname in
        self?.presenter?.presentNickname(nickname: nickname)
      }
    )
  }

  func requestSignOut() {
    self.worker?.requestSignOut()
  }

  func requestWithdraw() {
    self.worker?.requestWithdraw()
  }

  // Routing

  func navigateToLoginView() {
    self.router?.navigateToLoginView()
  }

  func navigateToNoticeView() {
    self.router?.navigateToNoticeView()
  }

  func navigateToProfileSettingView() {
    self.router?.navigateToProfileSettingView()
  }

  // Notification Center

  func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .signInCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.presentLoginStatus(isSignedIn: true)
    }

    NotificationCenter.default.addObserver(
      forName: .signOutCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.presentLoginStatus(isSignedIn: false)
    }

    NotificationCenter.default.addObserver(
      forName: .profileUpdated,
      object: nil,
      queue: nil
    ) { _ in
      self.fetchNickname()
    }

    NotificationCenter.default.addObserver(
      forName: .pushSettingUpdated,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.presentPushSetting()
    }
  }
}

//
//  MyInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import UIKit

protocol MyInteractorProtocol {
  var router: MyRouterProtocol? { get set }
  var worker: MyWorkerProtocol? { get set }
  var presenter: MyPresenter? { get set }

  func fetchMenuData()
  func checkLoginStatus()
  func requestLogOut()
  func requestSignOut()

  func navigateToLoginView(source: MyViewProtocol)
  func navigateToNoticeView(source: MyViewProtocol)
  func navigateToProfileSettingView(source: MyViewProtocol)
}

final class MyInteractor: MyInteractorProtocol {

  var router: MyRouterProtocol?
  var worker: MyWorkerProtocol?
  var presenter: MyPresenter?

  // Busniess Logic

  func fetchMenuData() {
    self.worker?.fetchMenuData(completionHandler: { menu in
      self.presenter?.presentMenuData(myMenu: menu)
    })
    self.checkLoginStatus()
    self.setNotification()
  }

  func checkLoginStatus() {
    self.worker?.checkLoginStatus(completionHandler: { isLoggedIn in
      if isLoggedIn { // 로그인 상태라면 nickname 불러오기
        self.worker?.fetchNickname(completionHandler: { nickname in
          self.presenter?.presentNickname(nickname: nickname)
        })
      }
      self.presenter?.presentLoginStatus(isLoggedIn: isLoggedIn)
    })
  }

  func requestLogOut() {
    self.worker?.requestLogOut(completionHandler: {
      NotificationCenter.default.post(name: .logoutCompleted, object: nil)
    })
  }

  func requestSignOut() {
    self.worker?.requestSignOut(completionHandler: {
      NotificationCenter.default.post(name: .logoutCompleted, object: nil)
    })
  }

  // Routing

  func navigateToLoginView(source: MyViewProtocol) {
    self.router?.navigateToLoginView(source: source)
  }

  func navigateToNoticeView(source: MyViewProtocol) {
    self.router?.navigateToNoticeView(source: source)
  }

  func navigateToProfileSettingView(source: MyViewProtocol) {
    self.router?.navigateToProfileSettingView(source: source)
  }

  // Notification Center

  func setNotification() {
    NotificationCenter.default.addObserver(
      forName: .loginCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.presentLoginStatus(isLoggedIn: true)
    }

    NotificationCenter.default.addObserver(
      forName: .logoutCompleted,
      object: nil,
      queue: nil
    ) { _ in
      self.presenter?.presentLoginStatus(isLoggedIn: false)
    }
  }
}

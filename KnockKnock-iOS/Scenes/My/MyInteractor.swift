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
  func fetchNickname() 
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
    self.worker?.fetchMenuData(completionHandler: { [weak self] menu in
      self?.presenter?.presentMenuData(myMenu: menu)
    })
    self.checkLoginStatus()
    self.setNotification()
  }

  func checkLoginStatus() {
    self.worker?.checkLoginStatus(completionHandler: { [weak self] isLoggedIn in
      self?.presenter?.presentLoginStatus(isLoggedIn: isLoggedIn)
    })
  }

  func fetchNickname() {
    self.worker?.fetchNickname(completionHandler: { [weak self] nickname in
      self?.presenter?.presentNickname(nickname: nickname)
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

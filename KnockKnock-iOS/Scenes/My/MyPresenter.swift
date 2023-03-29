//
//  MyPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import Foundation

protocol MyPresenterProtocol {
  var view: MyViewProtocol? { get set }

  func presentMenuData(myMenu: MyMenu)
  func presentLoginStatus(isSignedIn: Bool)
  func presentVersionInfo(version: String)
  func presentPushSetting()
  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class MyPresenter: MyPresenterProtocol {

  weak var view: MyViewProtocol?

  func presentMenuData(myMenu: MyMenu) {
    self.view?.fetchMenuData(menuData: myMenu)
  }

  func presentLoginStatus(isSignedIn: Bool) {
    self.view?.checkLoginStatus(isSignedIn: isSignedIn)
  }

  func presentVersionInfo(version: String) {
    self.view?.fetchVersionInfo(version: version)
  }

  func presentNickname(nickname: String) {
    self.view?.fetchNickname(nickname: nickname)
  }

  func presentPushSetting() {
    self.view?.setPushSetting()
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}

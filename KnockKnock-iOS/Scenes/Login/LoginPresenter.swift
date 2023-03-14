//
//  LoginPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

protocol LoginPresenterProtocol {
  var view: LoginViewProtocol? { get set }

  func presentAlert(
    message: String,
    isCancelActive: Bool,
    confirmAction: (() -> Void)?
  )
}

final class LoginPresenter: LoginPresenterProtocol {
  weak var view: LoginViewProtocol?

  func presentAlert(
    message: String,
    isCancelActive: Bool,
    confirmAction: (() -> Void)?
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}

//
//  ProfileSettingPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import Foundation

protocol ProfileSettingPresenterProtocol {
  var view: ProfileSettingViewProtocol? { get set }

  func presentUserData(userData: UserDetail)
  
  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

final class ProfileSettingPresenter: ProfileSettingPresenterProtocol {
  weak var view: ProfileSettingViewProtocol?

  func presentUserData(userData: UserDetail) {
    self.view?.fetchUserData(userData: userData)
  }

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  ) {
    self.view?.showAlertView(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}

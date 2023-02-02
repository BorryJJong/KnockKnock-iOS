//
//  ProfileSettingPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/03.
//

import UIKit

protocol ProfileSettingPresenterProtocol {
  var view: ProfileSettingViewProtocol? { get set }

  func presentUserData(userData: UserDetail)
}

final class ProfileSettingPresenter: ProfileSettingPresenterProtocol {
  weak var view: ProfileSettingViewProtocol?

  func presentUserData(userData: UserDetail) {
    self.view?.fetchUserData(userData: userData)
  }
}

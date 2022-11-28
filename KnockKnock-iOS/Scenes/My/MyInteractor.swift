//
//  MyInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/28.
//

import UIKit

protocol MyInteractorProtocol {
  var router: MyRouterProtocol? { get set }

  func navigateToLoginView(source: MyViewProtocol)
  func navigateToNoticeView(source: MyViewProtocol)
  func navigateToProfileSettingView(source: MyViewProtocol)
}

final class MyInteractor: MyInteractorProtocol {

  var router: MyRouterProtocol?

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
}

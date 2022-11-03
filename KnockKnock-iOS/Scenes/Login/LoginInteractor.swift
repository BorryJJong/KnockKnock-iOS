//
//  LoginInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginInteractorProtocol {
  var presenter: LoginPresenterProtocol? { get set }
  var worker: LoginWorkerProtocol? { get set }

  func fetchLoginResult(socialType: SocialType)
}

final class LoginInteractor: LoginInteractorProtocol {

  var presenter: LoginPresenterProtocol?
  var worker: LoginWorkerProtocol?

  func fetchLoginResult(
    socialType: SocialType
  ) {
    self.worker?.fetchLoginResult(
      socialType: socialType,
      completionHandler: { response, loginInfo in
        self.presenter?.presentLoginResult(loginResult: response, loginInfo: loginInfo)
    })
  }

  // token save function needed.
}

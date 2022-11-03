//
//  LoginWorker.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginWorkerProtocol {
  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  )
}

final class LoginWorker: LoginWorkerProtocol {
  private let repository: LoginRepositoryProtocol

  init(repository: LoginRepositoryProtocol) {
    self.repository = repository
  }

  func fetchLoginResult(
    socialType: SocialType,
    completionHandler: @escaping (LoginResponse, LoginInfo) -> Void
  ) {
    self.repository.requestToken(
      socialType: socialType,
      completionHandler: { response, loginInfo in
      completionHandler(response, loginInfo)
    })
  }
}

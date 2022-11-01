//
//  LoginRouter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import UIKit

protocol LoginRouterProtocol {
  static func createLoginView() -> UIViewController
}

final class LoginRouter: LoginRouterProtocol {
  static func createLoginView() -> UIViewController {
    let view = LoginViewController()
//    let intractor = LoginInteractor()
//    let presenter = LoginPresenter()
//    let worker = LoginWorker()
    let router = LoginRouter()

    return view
  }

}


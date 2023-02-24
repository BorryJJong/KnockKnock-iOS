//
//  LoginPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/01.
//

import Foundation

protocol LoginPresenterProtocol {
  var view: LoginViewProtocol? { get set }
}

final class LoginPresenter: LoginPresenterProtocol {
  weak var view: LoginViewProtocol?
}

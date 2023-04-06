//
//  PolicyProtoocl.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/05.
//

import UIKit

protocol PolicyViewProtocol: AnyObject {
  var interactor: PolicyInteractorProtocol? { get set }

  func fetchPolicyUrl(policyType: MyMenuType)

  func showAlertView(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol PolicyInteractorProtocol {
  var router: PolicyRouterProtocol? { get set }
  var presenter: PolicyPresenterProtocol? { get set }

  func setPolicyUrl()

  // MARK: - Routing

  func popToMyView()
}

protocol PolicyPresenterProtocol {
  var view: PolicyViewProtocol? { get set }

  func presentPolicyUrl(policyType: MyMenuType)

  func presentAlert(
    message: String,
    isCancelActive: Bool?,
    confirmAction: (() -> Void)?
  )
}

protocol PolicyRouterProtocol {
  var view: PolicyViewProtocol? { get set }
  
  static func createPolicyView(policyType: MyMenuType) -> UIViewController
  
  func popToMyView()
}

//
//  PolicyInteractor.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/05.
//

import Foundation

final class PolicyInteractor: PolicyInteractorProtocol {
  
  // MARK: - Properties

  var presenter: PolicyPresenterProtocol?
  var router: PolicyRouterProtocol?

  var policyType: MyMenuType? {
    didSet {
      self.setPolicyUrl()
    }
  }

  func setPolicyUrl() {
    LoadingIndicator.showLoading()
    
    guard let policyType = policyType else {
      self.showAlertView(
        message: "로드에 실패하였습니다.",
        confirmAction: self.popToMyView
      )
      return
    }

    self.presenter?.presentPolicyUrl(policyType: policyType)
  }

  func showAlertView(
    message: String,
    confirmAction: (() -> Void)?
  ) {
    self.router?.showAlertView(
      message: message,
      confirmAction: confirmAction
    )
  }

  func popToMyView() {
    self.router?.popToMyView()
  }
}

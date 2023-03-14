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
      self.presentAlert(
        message: "로드에 실패하였습니다.",
        confirmAction: self.popToMyView
      )
      return
    }

    self.presenter?.presentPolicyUrl(policyType: policyType)
  }

  func popToMyView() {
    self.router?.popToMyView()
  }

  private func presentAlert(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    self.presenter?.presentAlert(
      message: message,
      isCancelActive: isCancelActive,
      confirmAction: confirmAction
    )
  }
}

//
//  PolicyPresenter.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2023/03/05.
//

import Foundation

final class PolicyPresenter: PolicyPresenterProtocol {

  // MARK: - Properties

  weak var view: PolicyViewProtocol?

  func presentPolicyUrl(policyType: MyMenuType) {
    self.view?.fetchPolicyUrl(policyType: policyType)
  }
}

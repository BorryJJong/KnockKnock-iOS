//
//  PolicyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

import KKDSKit

final class PolicyViewController: BaseViewController<PolicyView> {

  // MARK: - Properties

  var interactor: PolicyInteractorProtocol?

  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConfigure()
  }
  
  // MARK: - Configure
  
  override func setupConfigure() {
    let backButton = UIBarButtonItem(
      image: KKDS.Image.ic_back_24_bk,
      style: .done,
      target: self,
      action: #selector(self.backButtonDidTap(_:))
    )

    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.leftBarButtonItem = backButton
  }
  
  // MARK: - Button Actions
  
  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.interactor?.popToMyView()
  }
}

extension PolicyViewController: PolicyViewProtocol {
  func fetchPolicyUrl(policyType: MyMenuType) {

    guard let urlString = policyType.url,
          let url = URL(string: urlString) else {

      self.interactor?.showAlertView(
        message: "페이지 로드 실패",
        confirmAction: self.interactor?.popToMyView
      )
      return

    }

    DispatchQueue.main.async {
      self.containerView.setWebViewUrl(url: url)
      self.navigationItem.title = policyType.rawValue
      LoadingIndicator.hideLoading()
    }
  }
}

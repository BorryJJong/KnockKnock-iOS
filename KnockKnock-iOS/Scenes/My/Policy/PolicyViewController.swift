//
//  PolicyViewController.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

import KKDSKit
import WebKit

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

    self.containerView.webView.navigationDelegate = self

    self.navigationController?.navigationBar.setDefaultAppearance()
    self.navigationItem.leftBarButtonItem = backButton
  }
  
  // MARK: - Button Actions
  
  @objc private func backButtonDidTap(_ sender: UIButton) {
    self.interactor?.popToMyView()
  }
}

// MARK: - Policy View Protocol

extension PolicyViewController: PolicyViewProtocol, AlertProtocol {
  func fetchPolicyUrl(policyType: MyMenuType) {

    guard let urlString = policyType.url,
          let url = URL(string: urlString) else {

      DispatchQueue.main.async {
        self.showAlertView(
          message: AlertMessage.pageLoadFailed.rawValue,
          confirmAction: self.interactor?.popToMyView
        )
      }
      return

    }

    DispatchQueue.main.async {
      self.containerView.setWebViewUrl(url: url)
      self.navigationItem.title = policyType.rawValue
//      LoadingIndicator.hideLoading()
    }
  }

  /// Alert 팝업 창
  func showAlertView(
    message: String,
    isCancelActive: Bool? = false,
    confirmAction: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      self.showAlert(
        message: message,
        isCancelActive: isCancelActive,
        confirmAction: confirmAction
      )
    }
  }
}

// MARK: - Policy View Protocol

extension PolicyViewController: WKNavigationDelegate {

  func webView(
    _ webView: WKWebView,
    didFinish navigation: WKNavigation!
  ) {
    LoadingIndicator.hideLoading()
  }

  func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    LoadingIndicator.hideLoading()
    self.showAlertView(message: AlertMessage.pageLoadFailed.rawValue)
  }
}

//
//  NoticeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/11/02.
//

import UIKit

import WebKit
import SnapKit
import KKDSKit
import Then

final class PolicyView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelTopMargin = 20.f

    static let dateLabelTopMargin = 5.f
    static let dateLabelLeadingMargin = 20.f

    static let separatorLineViewLeadingMargin = 20.f
    static let separatorLineViewTopMargin = 20.f
    static let separatorLineViewHeight = 1.f
  }

  // MARK: - UIs

  private let webView = WKWebView()

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure

  func setWebViewUrl(url: URL) {
    self.webView.load(URLRequest(url: url))
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.webView].addSubViews(self)

    self.webView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide)
    }
  }
}

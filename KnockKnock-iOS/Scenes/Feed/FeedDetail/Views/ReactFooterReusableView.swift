//
//  ReactFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/28.
//

import UIKit

import Then

class ReactFooterReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let seperateLineViewTrailingMargin = -20.f
    static let seperateLineViewHeight = 1.f
  }

  // MARK: - UIs

  private let seperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.seperateLineView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.seperateLineView.topAnchor.constraint(equalTo: self.topAnchor),
      self.seperateLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.seperateLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.seperateLineViewTrailingMargin),
      self.seperateLineView.heightAnchor.constraint(equalToConstant: Metric.seperateLineViewHeight)
    ])
  }
}

//
//  HeaderCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/18.
//

import UIKit

import KKDSKit

class HeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  enum Metric {
    static let exitButtonTrailingMargin = -10.f
  }

  // MARK: - UIs

  let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "댓글"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }

  let exitButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(KKDS.Image.ic_close_24_bk, for: .normal)
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

  func setupConstraints() {
    [self.titleLabel, self.exitButton].addSubViews(self)

    NSLayoutConstraint.activate([
      self.exitButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.exitButtonTrailingMargin),
      self.exitButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),

      self.titleLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
      self.titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
    ])
  }
}

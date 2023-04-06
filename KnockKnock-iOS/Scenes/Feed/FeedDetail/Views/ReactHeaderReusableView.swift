//
//  ReactHeaderReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/28.
//

import UIKit

import Then

final class ReactHeaderReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let headerLabelTopMargin = 20.f
    static let headerLabelLeadingMargin = 20.f
  }

  // MARK: - UIs

  private let headerLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(count: Int, section: FeedDetailSection) {
    if section == FeedDetailSection.like {
      self.headerLabel.text = "좋아요(\(count))"
    } else if section == FeedDetailSection.comment {
      self.headerLabel.text = "댓글(\(count))"
    }
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.headerLabel].addSubViews(self)

    NSLayoutConstraint.activate([
      self.headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Metric.headerLabelTopMargin),
      self.headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}

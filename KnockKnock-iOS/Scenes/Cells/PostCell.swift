//
//  postCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import Then
import KKDSKit

final class PostCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let contentLabel = BasePaddingLabel(padding: UIEdgeInsets(
    top: 5,
    left: 5,
    bottom: 5,
    right: 5
  )).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.backgroundColor = KKDS.Color.gray20
    $0.textColor = KKDS.Color.gray70
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
  }

  func bind(text: String) {
    self.contentLabel.text = text
  }

  override func setupConstraints() {
    [self.contentLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
  }
}

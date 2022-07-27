//
//  postCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import Then

final class PostImageCell: BaseCollectionViewCell {

  // MARK: - UIs

  let contentLabel = BasePaddingLabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.backgroundColor = .gray20
    $0.textColor = .gray70
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }

  func bind(text: String) {
    contentLabel.text = text
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

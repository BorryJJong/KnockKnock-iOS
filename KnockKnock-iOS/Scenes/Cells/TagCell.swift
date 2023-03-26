//
//  TagCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

import KKDSKit

class TagCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let tagLabel = BasePaddingLabel(padding: UIEdgeInsets(
    top: 10,
    left: 20,
    bottom: 10,
    right: 20
  )).then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .center
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 17
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = KKDS.Color.green50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = KKDS.Color.green40.cgColor
  }

  // MARK: - Bind

  func bind(tag: ChallengeTitle) {
    self.tagLabel.text = tag.title
    self.setLabel(isSelected: tag.isSelected)
  }

  private func setLabel(isSelected: Bool) {
    switch isSelected {
    case true:
      self.tagLabel.backgroundColor = KKDS.Color.green50
      self.tagLabel.textColor = .white
      self.tagLabel.font = .systemFont(ofSize: 12, weight: .bold)
      self.tagLabel.sizeToFit()

    case false:
      self.tagLabel.backgroundColor = .white
      self.tagLabel.textColor = KKDS.Color.green50
      self.tagLabel.font = .systemFont(ofSize: 12, weight: .medium)
      self.tagLabel.sizeToFit()
    }
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.tagLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.tagLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.tagLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.tagLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
    ])
  }
}

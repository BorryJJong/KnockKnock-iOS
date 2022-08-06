//
//  TagCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

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
    $0.layer.cornerRadius = 20
    $0.textColor = .green50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.green40?.cgColor
  }

  // MARK: - Bind

  func bind(tag: ChallengeTitle) {
    self.tagLabel.text = tag.title
    self.setLabel(isSelected: tag.isSelected)
  }

  private func setLabel(isSelected: Bool) {
    switch isSelected {
    case true:
      self.tagLabel.backgroundColor = .green50
      self.tagLabel.textColor = .white
      self.tagLabel.font = .systemFont(ofSize: 14, weight: .bold)
      self.tagLabel.sizeToFit()

    case false:
      self.tagLabel.backgroundColor = .white
      self.tagLabel.textColor = .green50
      self.tagLabel.font = .systemFont(ofSize: 14, weight: .medium)
      self.tagLabel.sizeToFit()
    }
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.tagLabel].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.tagLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.tagLabel.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.tagLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.tagLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

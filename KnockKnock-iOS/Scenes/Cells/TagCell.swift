//
//  TagCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

class TagCell: BaseCollectionViewCell {

  // MARK: - UIs

  let tagLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .center
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 10
    $0.textColor = .green50
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.green40?.cgColor

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

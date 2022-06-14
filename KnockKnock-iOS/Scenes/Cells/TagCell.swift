//
//  TagCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

class TagCell: BaseCollectionViewCell {

  // MARK: - UIs

  let tagButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
    $0.backgroundColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    $0.setTitleColor(.green50, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.green40?.cgColor
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.tagButton].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.tagButton.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.tagButton.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.tagButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.tagButton.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

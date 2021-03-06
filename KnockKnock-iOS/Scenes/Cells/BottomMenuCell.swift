//
//  bottomMenuCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

final class BottomMenuCell: BaseTableViewCell {

  // MARK: - UIs

  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .black
  }

  private let checkImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  func setData(labelText: String) {
    self.contentsLabel.text = labelText
  }

  override func setupConstraints() {
    [self.contentsLabel, self.checkImageView].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.contentsLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

      self.checkImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      self.checkImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
    ])
  }

}

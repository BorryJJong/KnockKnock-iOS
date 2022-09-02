//
//  bottomMenuCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

import Then
import KKDSKit

final class BottomMenuCell: BaseTableViewCell {

  // MARK: - UIs

  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .black
  }

  private let checkImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_select_20
  }

  func setData(labelText: String) {
    self.contentsLabel.text = labelText
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    if selected {
      self.contentsLabel.textColor = .green40
      self.contentsLabel.font = .systemFont(ofSize: 15, weight: .bold)
      self.checkImageView.isHidden = false
    } else {
      self.contentsLabel.textColor = .black
      self.contentsLabel.font = .systemFont(ofSize: 15, weight: .medium)
      self.checkImageView.isHidden = true
    }
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

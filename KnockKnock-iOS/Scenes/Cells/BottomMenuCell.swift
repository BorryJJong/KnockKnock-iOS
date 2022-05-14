//
//  bottomMenuCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/11.
//

import UIKit

final class BottomMenuCell: BaseTableViewCell {

  // MARK: - Constants

  private enum Metric {
  }

  // MARK: - UIs

  let menuLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .black
    $0.text = "삭제"
  }

  let checkImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(systemName: "check")
  }

  override func setupConstraints() {
    [self.menuLabel, self.checkImageView].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.menuLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.menuLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.menuLabel.heightAnchor.constraint(equalToConstant: 50),

      self.checkImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.checkImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.checkImageView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

}

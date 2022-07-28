//
//  LikeCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import Then
import KKDSKit

class LikeCell: BaseCollectionViewCell {

// MARK: - UIs

  private let profileImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_person_24
//    $0.backgroundColor = .cyan
    $0.contentMode = .scaleToFill
//    $0.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
//    $0.frame.size.width = 100
//    $0.frame.size.height = 100
  }

  private let likeImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_like_circle_16
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.profileImageView, self.likeImageView].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//      self.profileImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//      self.profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.profileImageView.heightAnchor.constraint(equalToConstant: 45),
      self.profileImageView.widthAnchor.constraint(equalToConstant: 45),

      self.likeImageView.trailingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor),
      self.likeImageView.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor),
            self.likeImageView.heightAnchor.constraint(equalToConstant: 16),
            self.likeImageView.widthAnchor.constraint(equalToConstant: 16)
    ])
  }
}

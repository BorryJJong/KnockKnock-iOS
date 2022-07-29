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

    $0.contentMode = .scaleToFill
  }

  private let likeImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_like_circle_16
  }

  private let nextImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_next_24_bk
    $0.isHidden = true
  }

  // MARK: - Bind

  func bind(isLast: Bool) {
    if isLast {
    self.nextImageView.isHidden = false
    self.profileImageView.isHidden = true
    self.likeImageView.isHidden = true
    } else {
      self.nextImageView.isHidden = true
      self.profileImageView.isHidden = false
      self.likeImageView.isHidden = false
    }
  }

  // MARK: - Constraints

  override func setupConstraints() {
    [self.profileImageView, self.nextImageView, self.likeImageView].addSubViews(self.contentView)

    NSLayoutConstraint.activate([
      self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//      self.profileImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//      self.profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.profileImageView.heightAnchor.constraint(equalToConstant: 45),
      self.profileImageView.widthAnchor.constraint(equalToConstant: 45),

      self.nextImageView.leadingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor),
      self.nextImageView.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor),

      self.likeImageView.trailingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor),
      self.likeImageView.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor),
            self.likeImageView.heightAnchor.constraint(equalToConstant: 16),
            self.likeImageView.widthAnchor.constraint(equalToConstant: 16)
    ])
  }
}

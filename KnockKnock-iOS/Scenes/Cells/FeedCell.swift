//
//  FeedCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit

class FeedCell: BaseCollectionViewCell {

  // MARK: - UIs

  let thumbnailImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }

  let severalSymbolImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.thumbnailImageView].addSubViews(self.contentView)
    NSLayoutConstraint.activate([
      self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.thumbnailImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

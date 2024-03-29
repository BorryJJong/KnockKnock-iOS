//
//  FeedCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/06/13.
//

import UIKit
import KKDSKit

class FeedCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let severalSymbolImageViewBottomMargin = -12.f
    static let severalSymbolImageViewTrailingMargin = -12.f
  }

  // MARK: - UIs

  let thumbnailImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = KKDS.Color.gray20
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }

  let severalSymbolImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_more_img_20_wh
    $0.isHidden = true
  }

  // MARK: - Bind

  func bind(post: FeedMain.Post) {
    self.severalSymbolImageView.isHidden = !post.isImageMore
    self.thumbnailImageView.setImageFromStringUrl(
      stringUrl: post.thumbnailUrl,
      defaultImage: KKDS.Image.ic_no_data_60
    )
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.thumbnailImageView, self.severalSymbolImageView].addSubViews(self.contentView)
    NSLayoutConstraint.activate([
      self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
      self.thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
      self.thumbnailImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
      self.thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),

      self.severalSymbolImageView.bottomAnchor.constraint(equalTo: self.thumbnailImageView.bottomAnchor, constant: Metric.severalSymbolImageViewBottomMargin),
      self.severalSymbolImageView.trailingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: Metric.severalSymbolImageViewTrailingMargin)
    ])
  }
}

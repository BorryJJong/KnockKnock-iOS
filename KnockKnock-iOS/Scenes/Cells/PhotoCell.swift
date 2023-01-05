//
//  PhotoCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import Then

final class PhotoCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let thumbnailImageViewCornerRadius = 5.f

    static let thumbnailImageViewTopMargin = 10.f
    static let thumbnailImageViewRightMargin = -10.f

    static let deleteButtonWidth = 20.f
    static let deleteButtonHeight = 20.f
  }

  // MARK: - UI

  let thumbnailImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.clipsToBounds = true
    $0.layer.cornerRadius = Metric.thumbnailImageViewCornerRadius
    $0.contentMode = .scaleAspectFill
  }
  
  let deleteButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName: "ic_input_cancel"), for: .normal)
  }

  // MARK: - Bind

  func bind(data: UIImage) {
    self.thumbnailImageView.image = data
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.thumbnailImageView, self.deleteButton].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Metric.thumbnailImageViewTopMargin),
      self.thumbnailImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: Metric.thumbnailImageViewRightMargin),
      self.thumbnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.thumbnailImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),

      self.deleteButton.centerXAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor),
      self.deleteButton.centerYAnchor.constraint(equalTo: self.thumbnailImageView.topAnchor),
      self.deleteButton.widthAnchor.constraint(equalToConstant: Metric.deleteButtonWidth),
      self.deleteButton.heightAnchor.constraint(equalToConstant: Metric.deleteButtonWidth)
    ])
  }

}

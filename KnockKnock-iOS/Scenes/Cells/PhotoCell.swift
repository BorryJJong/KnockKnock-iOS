//
//  PhotoCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/03/21.
//

import UIKit

import Then

final class PhotoCell: BaseCollectionViewCell {

  // MARK: - UI

  let thumnailImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }
  
  let deleteButton = UIButton().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(#imageLiteral(resourceName:"ic_input_cancel"), for: .normal)
  }

  // MARK: - Bind

  func bind(data: UIImage) {
    self.thumnailImageView.image = data
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.thumnailImageView, self.deleteButton].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.thumnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
      self.thumnailImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
      self.thumnailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.thumnailImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),

      self.deleteButton.centerXAnchor.constraint(equalTo: self.thumnailImageView.trailingAnchor),
      self.deleteButton.centerYAnchor.constraint(equalTo: self.thumnailImageView.topAnchor),
      self.deleteButton.widthAnchor.constraint(equalToConstant: 20),
      self.deleteButton.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

}

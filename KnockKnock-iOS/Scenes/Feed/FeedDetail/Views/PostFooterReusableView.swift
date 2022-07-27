//
//  PostFooterReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/27.
//

import UIKit

import KKDSKit

class PostFooterReusableView: UICollectionReusableView {

  // MARK: - UIs

  private let shopInfoView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray10?.cgColor
  }

  private let markImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_location_20
  }

  private let shopNameLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "아로마티카"
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textColor = .gray80
  }

  private let shopAddressLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "서울특별시 강남구 신사동 613-15번지"
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .gray60
  }

  private let seperateLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray10
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Constraints

  private func setupConstraints() {
    [self.shopInfoView].addSubViews(self)
    [self.markImageView, self.shopNameLabel, self.shopAddressLabel, self.seperateLineView].addSubViews(self)

    NSLayoutConstraint.activate([
    self.shopInfoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
    self.shopInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
    self.shopInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
    self.shopInfoView.bottomAnchor.constraint(equalTo: self.seperateLineView.topAnchor, constant: -30),

    self.markImageView.topAnchor.constraint(equalTo: self.shopInfoView.topAnchor, constant: 15),
    self.markImageView.leadingAnchor.constraint(equalTo: self.shopInfoView.leadingAnchor, constant: 20),

    self.shopNameLabel.leadingAnchor.constraint(equalTo: self.markImageView.trailingAnchor, constant: 10),
    self.shopNameLabel.centerYAnchor.constraint(equalTo: self.markImageView.centerYAnchor),

    self.shopAddressLabel.leadingAnchor.constraint(equalTo: self.shopInfoView.leadingAnchor, constant: 20),
    self.shopAddressLabel.topAnchor.constraint(equalTo: self.markImageView.bottomAnchor, constant: 5),
    self.shopAddressLabel.bottomAnchor.constraint(equalTo: self.shopInfoView.bottomAnchor, constant: -15),

    self.seperateLineView.heightAnchor.constraint(equalToConstant: 10),
    self.seperateLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
    self.seperateLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    self.seperateLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }

}

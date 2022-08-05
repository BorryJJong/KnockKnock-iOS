//
//  EventCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/08/05.
//

import UIKit

import Then
import SnapKit
import KKDSKit

class EventCell: BaseCollectionViewCell {

  // MARK: - UIs

  private let thumbnailImageView = UIImageView().then {
    $0.backgroundColor = .gray20
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let gradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let periodLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .white
    $0.text = "2021.06.25 - 2021.10.31"
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = .white
    $0.text = "[스타벅스] 지구의날 온라인 MD 출시"
  }

  private let newEventLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .green50
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "NEW"
  }

  override func setupConstraints() {
    [self.thumbnailImageView, self.gradientImageView, self.periodLabel, self.titleLabel, self.newEventLabel].addSubViews(self.contentView)

    self.thumbnailImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.gradientImageView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(self.thumbnailImageView)
      $0.height.equalTo(100)
    }

    self.titleLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.contentView).offset(-15)
      $0.leading.equalTo(self.contentView).offset(15)
    }

    self.periodLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.titleLabel.snp.top).offset(-5)
      $0.leading.equalTo(self.titleLabel.snp.leading)
    }

    self.newEventLabel.snp.makeConstraints {
      $0.top.leading.equalTo(self.contentView).offset(10)
      $0.width.equalTo(40)
      $0.height.equalTo(20)
    }
  }
}

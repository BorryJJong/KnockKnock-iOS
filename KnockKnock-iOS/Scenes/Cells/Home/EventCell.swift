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

final class EventCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let gradientImageViewHeight = 100.f

    static let titleLabelBottomMargin = -15.f
    static let titleLabelLeadingMargin = 15.f

    static let periodLabelBottomMargin = -5.f

    static let newEventLabelTopMargin = 10.f
    static let newEventLabelWidth = 40.f
    static let newEventLabelHeight = 20.f
  }

  // MARK: - UIs

  private let thumbnailImageView = UIImageView().then {
    $0.backgroundColor = KKDS.Color.gray20
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let coverView = UIView().then {
    $0.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
    $0.isHidden = true
  }

  private let gradientImageView = UIImageView().then {
    $0.image = KKDS.Image.ic_bg_gradient_bottom_bk
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let periodLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .white
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = .white
  }

  private let newEventLabel = UILabel().then {
    $0.backgroundColor = KKDS.Color.green50
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "NEW"
  }

  // MARK: - Bind

  func isClosedEvent(isClosed: Bool) {
    if isClosed {
      self.coverView.isHidden = false
    } else {
      self.coverView.isHidden = true
    }
  }

  func bind(event: Event) {
    self.thumbnailImageView.setImageFromStringUrl(
      stringUrl: event.image,
      defaultImage: KKDS.Image.ic_no_data_60
    )
    self.periodLabel.text = event.eventPeriod
    self.titleLabel.text = event.title
    self.newEventLabel.isHidden = !event.isNewBadge
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.thumbnailImageView, self.gradientImageView, self.coverView, self.periodLabel, self.titleLabel, self.newEventLabel].addSubViews(self.contentView)

    self.thumbnailImageView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.coverView.snp.makeConstraints {
      $0.edges.equalTo(self.contentView)
    }

    self.gradientImageView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(self.thumbnailImageView)
      $0.height.equalTo(Metric.gradientImageViewHeight)
    }

    self.titleLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.contentView).offset(Metric.titleLabelBottomMargin)
      $0.leading.equalTo(self.contentView).offset(Metric.titleLabelLeadingMargin)
    }

    self.periodLabel.snp.makeConstraints {
      $0.bottom.equalTo(self.titleLabel.snp.top).offset(Metric.periodLabelBottomMargin)
      $0.leading.equalTo(self.titleLabel.snp.leading)
    }

    self.newEventLabel.snp.makeConstraints {
      $0.top.leading.equalTo(self.contentView).offset(Metric.newEventLabelTopMargin)
      $0.width.equalTo(Metric.newEventLabelWidth)
      $0.height.equalTo(Metric.newEventLabelHeight)
    }
  }
}

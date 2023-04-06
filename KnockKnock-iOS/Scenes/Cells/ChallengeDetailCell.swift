//
//  ChallengeDetailCell.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import SnapKit
import KKDSKit
import Then

final class ChallengeDetailCell: BaseCollectionViewCell {

  // MARK: - Constants

  private enum Metric {
    static let titleLabelTopMargin = 40.f
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTrailingMargin = -20.f
    static let titleLabelHeight = 20.f

    static let exampleImageViewHeight = 200.f
    static let exampleImageViewLeadingMargin = 20.f
    static let exampleImageViewTrailingMargin = -20.f
    static let exampleImageViewTopMargin = 15.f

    static let contentsLabelTopMargin = 15.f
    static let contentsLabelLeadingMargin = 20.f
    static let contentsLabelTrailingMargin = -20.f
    static let contentsLabelBottomMargin = 0.f
  }

  // MARK: - UIs

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = KKDS.Color.green50
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textAlignment = .natural
    $0.numberOfLines = 0
    $0.lineBreakStrategy = .hangulWordPriority
  }

  private let exampleImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
    $0.contentMode = .scaleToFill
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }

  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .natural
    $0.numberOfLines = 0
    $0.sizeToFit()
  }

  // MARK: - Bind

  func bind(challengeContent: ChallengeDetail.SubContents, isLast: Bool) {
    self.titleLabel.text = challengeContent.title

    self.exampleImageView.setImageFromStringUrl(
      stringUrl: challengeContent.image,
      defaultImage: KKDS.Image.ic_no_data_60
    )

    self.contentsLabel.setLineHeight(
      content: challengeContent.content,
      font: .systemFont(ofSize: 14, weight: .regular)
    )
    if isLast {
      self.contentsLabel.snp.updateConstraints {
        $0.bottom.equalToSuperview().offset(-70)
      }
    }
  }

  // MARK: - Configure

  override func setupConstraints() {
    [self.titleLabel, self.exampleImageView, self.contentsLabel].addSubViews(self.contentView)

    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.titleLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.titleLabelLeadingMargin)
    }

    self.exampleImageView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.exampleImageViewTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.exampleImageViewLeadingMargin)
      $0.height.equalTo(Metric.exampleImageViewHeight)
    }

    self.contentsLabel.snp.makeConstraints {
      $0.top.equalTo(self.exampleImageView.snp.bottom).offset(Metric.contentsLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.contentsLabelLeadingMargin)
      $0.bottom.equalToSuperview().offset(Metric.contentsLabelBottomMargin)
    }
  }
}

//
//  ChallengeDetailHeaderCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/21.
//

import UIKit

import Then
import KKDSKit
import SnapKit

final class ChallengeDetailHeaderCollectionReusableView: UICollectionReusableView {

  // MARK: - Constants

  private enum Metric {
    static let participantViewTopMargin = -45.f
    static let participantViewTrailingMargin = -55.f
    static let participantViewHeight = 60.f

    static let participantImageStackViewTopMargin = 25.f
    static let participantImageStackViewLeadingMargin = 20.f

    static let participantLabelViewTopMargin = 15.f
    static let participantLabelViewLeadingMargin = 5.f

    static let participantSeperatorViewHeight = 1.f
    static let participantSeperatorViewLeadingMargin = 20.f
    static let participantSeperatorViewTrailingMargin = -20.f
    static let participantSeperatorViewTopMargin = 15.f

    static let titleLabelTopMargin = 15.f
    static let titleLabelLeadingMargin = 20.f
    static let titleLabelTrailingMargin = -20.f

    static let summaryLabelTopMargin = 15.f
    static let summaryLabelLeadingMargin = 20.f
    static let summaryLabelTrailingMargin = -20.f

    static let summarySeperatorViewHeight = 1.f
    static let summarySeperatorViewLeadingMargin = 20.f
    static let summarySeperatorViewTrailingMargin = -20.f
    static let summarySeperatorViewTopMargin = 40.f

    static let wayHeaderLabelLeadingMargin = 20.f
    static let wayHeaderLabelTopMargin = 20.f

    static let wayLabelTopMargin = 10.f
    static let wayLabelLeadingMargin = 20.f
    static let wayLabelTrailingMargin = -20.f
    static let wayLabelHeight = 130.f

    static let wayStackViewLeadingMargin = 20.f
    static let wayStackViewTopMargin = 10.f
  }

  // MARK: - UIs

  private let topGradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_bg_gradient_top_bk
  }

  private let mainImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let participantView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }

  private let participantImageStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .horizontal
    $0.distribution = .equalCentering
    $0.alignment = .center
    $0.spacing = -7
  }

  private let participantLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "첫 번째 참여자가 되어보세요!"
    $0.textColor = .green50
    $0.font = .systemFont(ofSize: 13, weight: .regular)
  }

  private let participantSeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = KKDS.Color.gray20
  }

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }

  private let summaryLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.textAlignment = .natural
  }

  private let summarySeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = KKDS.Color.gray20
  }

  private let wayHeaderLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "실천방법"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KKDS.Color.green50
  }

  private let waysStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .leading
    $0.spacing = 5
    $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.backgroundColor = KKDS.Color.gray20
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 10
  }

  // MARK: - Initailize

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Bind

  func bind(challengeDetail: ChallengeDetail) {
    self.waysStackView.subviews.forEach {
      $0.removeFromSuperview()
    }
    self.mainImageView.setImageFromStringUrl(
      stringUrl: challengeDetail.contentImage,
      defaultImage: KKDS.Image.ic_no_data_60
    )
    
    self.summaryLabel.setLineHeight(
      content: challengeDetail.subTitle,
      font: .systemFont(ofSize: 14, weight: .regular)
    )
    self.setParticipantsImageStackView(participants: challengeDetail.participants)
    self.setParticipantLabel(count: challengeDetail.participants.count)
    self.titleLabel.text = challengeDetail.title
    self.setWayStackView(ways: challengeDetail.content.rule)
  }

  // MARK: - Configure

  private func setParticipantsImageStackView(participants: [ChallengeDetail.Participant]) {
    var images: [String?] = []

    Task {
      participants.forEach {
        images.append($0.image)
      }
      
      self.participantImageStackView.removeAllSubViews()
      
      await self.participantImageStackView.addParticipantImageViews(images: images)
    }
  }

  private func setParticipantLabel(count: Int) {
    if count == 0 {
      self.participantLabel.text = "첫 번째 참여자가 되어보세요!"
    } else {
      self.participantLabel.text = "\(count)명 참여중"
    }
  }
  
  private func setWayStackView(ways: [String]) {
    let wayLabelFont = UIFont.systemFont(ofSize: 12, weight: .regular)

    for way in ways {

      let waysLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.lineBreakStrategy = .hangulWordPriority
      }

      waysLabel.setBulletPoint(string: way, font: wayLabelFont)

      self.waysStackView.addArrangedSubview(waysLabel)
    }
  }

  func setupConstraints() {
    [self.participantImageStackView, self.participantLabel].addSubViews(self.participantView)
    [self.mainImageView, self.topGradientImageView, self.participantView, self.participantSeperatorView].addSubViews(self)
    [self.titleLabel, self.summaryLabel, self.summarySeperatorView, self.wayHeaderLabel, self.waysStackView].addSubViews(self)

    self.mainImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.height.equalTo(self.snp.width)
    }

    self.topGradientImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }

    self.participantView.snp.makeConstraints {
      $0.top.equalTo(self.mainImageView.snp.bottom).offset(Metric.participantViewTopMargin)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview().offset(Metric.participantViewTrailingMargin)
      $0.height.equalTo(Metric.participantViewHeight)
    }

    self.participantImageStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.participantImageStackViewTopMargin)
      $0.leading.equalToSuperview().offset(Metric.participantImageStackViewLeadingMargin)
    }

    self.participantLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.participantImageStackView)
      $0.leading.equalTo(self.participantImageStackView.snp.trailing).offset(Metric.participantLabelViewLeadingMargin)
    }

    self.participantSeperatorView.snp.makeConstraints {
      $0.height.equalTo(Metric.participantSeperatorViewHeight)
      $0.leading.trailing.equalToSuperview().inset(Metric.participantSeperatorViewLeadingMargin)
      $0.top.equalTo(self.participantView.snp.bottom).offset(Metric.participantSeperatorViewTopMargin)
    }

    self.titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.participantSeperatorView.snp.bottom).offset(Metric.titleLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.titleLabelLeadingMargin)
    }

    self.summaryLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.summaryLabelTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.summaryLabelLeadingMargin)
    }

    self.summarySeperatorView.snp.makeConstraints {
      $0.height.equalTo(Metric.summarySeperatorViewHeight)
      $0.leading.trailing.equalToSuperview().offset(Metric.summarySeperatorViewLeadingMargin)
      $0.top.equalTo(self.summaryLabel.snp.bottom).offset(Metric.summarySeperatorViewTopMargin)
    }

    self.wayHeaderLabel.snp.makeConstraints {
      $0.top.equalTo(self.summarySeperatorView.snp.bottom).offset(Metric.wayHeaderLabelTopMargin)
      $0.leading.equalToSuperview().inset(Metric.wayHeaderLabelLeadingMargin)
    }

    self.waysStackView.snp.makeConstraints {
      $0.top.equalTo(self.wayHeaderLabel.snp.bottom).offset(Metric.wayStackViewTopMargin)
      $0.leading.trailing.equalToSuperview().inset(Metric.wayStackViewLeadingMargin)
      $0.bottom.equalToSuperview()
    }
  }
}

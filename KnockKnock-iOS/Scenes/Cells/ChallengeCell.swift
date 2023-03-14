//
//  ChallengeCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

import KKDSKit
import Then

final class ChallengeCell: BaseCollectionViewCell {
  
  // MARK: - Constants
  
  private enum Metric {
    static let challengeHeight = 245.f

    static let newChallengeLabelTopMargin = 11.f
    static let newChallengeLabelLeadingMargin = 10.f
    static let newChallengeLabelWidth = 40.f
    static let newChallengeLabelHeight = 20.f

    static let hotChallengeLabelTopMargin = 11.f
    static let hotChallengeLabelLeadingMargin = 5.f
    static let hotChallengeLabelWidth = 40.f
    static let hotChallengeLabelHeight = 20.f

    static let participantViewTopMargin = -15.f
    static let participantViewTrailingMargin = -77.f
    static let participantViewHeight = 40.f

    static let participantImageStackViewTopMargin = 15.f

    static let participantLabelViewTopMargin = 15.f
    static let participantLabelViewLeadingMargin = 5.f

    static let seperatorLineViewHeight = 1.f
    static let seperatorLineViewTopMargin = 10.f

    static let titleLabelTopMargin = 10.f

    static let contentsLabelTopMargin = 5.f
    static let contentsLabelBottomMargin = -40.f
  }

  // MARK: - UI
  
  private let challengeImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  private let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .gray80
    $0.font = .systemFont(ofSize: 13)
    $0.numberOfLines = 2
    $0.textAlignment = .left
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
    $0.font = .systemFont(ofSize: 13)
  }

  private let seperatorLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  private let newChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .green50
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "NEW"
  }

  private let hotChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor(red: 236/255, green: 124/255, blue: 108/255, alpha: 1)
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "HOT"
  }

  private let badgeStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .equalSpacing
    $0.spacing = 5
  }
  
  // MARK: - Bind
  
  func bind(data: Challenge.Data?) {
    guard let data = data else { return }
    
    self.titleLabel.text = data.title
    self.contentsLabel.text = data.subTitle
    self.challengeImageView.setImageFromStringUrl(
      stringUrl: data.mainImage,
      defaultImage: KKDS.Image.ic_no_data_60
    )

    self.setBadges(isHot: data.isHotBadge, isNew: data.isNewBadge)
    self.setParticipantsImageStackView(participants: data.participants)
    self.setParticipantLabel(count: data.participantCount)
  }

  private func setParticipantsImageStackView(participants: [Challenge.Participant]) {
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

  private func setBadges(
    isHot: Bool,
    isNew: Bool
  ) {
    if isNew {
      self.badgeStackView.addArrangedSubview(self.newChallengeLabel)
    }
    if isHot {
      self.badgeStackView.addArrangedSubview(self.hotChallengeLabel)
    }
  }

  // MARK: - Configure
  
  override func setupConstraints() {
    [self.participantLabel, self.participantImageStackView].addSubViews(self.participantView)
    [self.challengeImageView, self.participantView, self.seperatorLineView, self.titleLabel, self.contentsLabel,
     self.badgeStackView].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.challengeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.challengeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.challengeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.challengeImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.75),

      self.badgeStackView.topAnchor.constraint(equalTo: self.challengeImageView.topAnchor, constant: Metric.newChallengeLabelTopMargin),
      self.badgeStackView.leadingAnchor.constraint(equalTo: self.challengeImageView.leadingAnchor, constant: Metric.newChallengeLabelLeadingMargin),
      self.badgeStackView.heightAnchor.constraint(equalToConstant: Metric.newChallengeLabelHeight),

      self.newChallengeLabel.widthAnchor.constraint(equalToConstant: Metric.newChallengeLabelWidth),
      self.newChallengeLabel.heightAnchor.constraint(equalToConstant: Metric.newChallengeLabelHeight),

      self.hotChallengeLabel.widthAnchor.constraint(equalToConstant: Metric.hotChallengeLabelWidth),
      self.hotChallengeLabel.heightAnchor.constraint(equalToConstant: Metric.hotChallengeLabelHeight),

      self.participantView.topAnchor.constraint(equalTo: self.challengeImageView.bottomAnchor, constant: Metric.participantViewTopMargin),
      self.participantView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.participantView.trailingAnchor.constraint(equalTo: self.challengeImageView.trailingAnchor, constant: Metric.participantViewTrailingMargin),
      self.participantView.bottomAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantViewHeight),

      self.participantImageStackView.topAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantImageStackViewTopMargin),
      self.participantImageStackView.leadingAnchor.constraint(equalTo: self.participantView.leadingAnchor),

      self.participantLabel.centerYAnchor.constraint(equalTo: self.participantImageStackView.centerYAnchor),
      self.participantLabel.leadingAnchor.constraint(equalTo: self.participantImageStackView.trailingAnchor, constant: Metric.participantLabelViewLeadingMargin),

      self.seperatorLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorLineViewHeight),
      self.seperatorLineView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
      self.seperatorLineView.topAnchor.constraint(equalTo: self.participantView.bottomAnchor, constant: Metric.seperatorLineViewTopMargin),

      self.titleLabel.topAnchor.constraint(equalTo: self.seperatorLineView.bottomAnchor, constant: Metric.titleLabelTopMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      
      self.contentsLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Metric.contentsLabelTopMargin),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.contentsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Metric.contentsLabelBottomMargin)
    ])
  }
}

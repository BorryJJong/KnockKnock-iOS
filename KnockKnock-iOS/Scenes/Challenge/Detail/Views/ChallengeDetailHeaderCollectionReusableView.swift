//
//  ChallengeDetailHeaderCollectionReusableView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/07/21.
//

import UIKit

import Then
import KKDSKit

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
  }

  // MARK: - UIs

  private let topGradientImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = KKDS.Image.ic_bg_gradient_top_bk
  }

  private let mainImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
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
    $0.backgroundColor = .gray20
  }

  private let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.text = "#GOGO 챌린지"
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
    $0.backgroundColor = .gray20
  }

  private let wayHeaderLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "실천방법"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = .green50
  }

  private let waysStackView = UIStackView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .vertical
    $0.distribution = .fill
    $0.alignment = .leading
    $0.spacing = 10
    $0.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.backgroundColor = .gray20
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
//    self.mainImageView.image = challengeDetail.ch
//      .flatMap { URL(string: $0) }
//      .flatMap { try? Data(contentsOf: $0) }
//      .flatMap { UIImage(data: $0) }
//    ?? UIImage(named: "challenge")

//    self.summaryLabel.setLineHeight(fontSize: 14, content: challengeDetail.summary)
    self.setParticipantsImageStackView(participants: challengeDetail.participants)
//    self.titleLabel.text = challengeDetail.title
//    self.setWayStackView(ways: challengeDetail.practice)
  }

  // MARK: - Configure

  private func setParticipantsImageStackView(participants: [Participant]) {
    var images: [String?] = []

    participants.forEach {
      images.append($0.image)
    }
    self.participantImageStackView.removeAllSubViews()
    self.participantImageStackView.addParticipantImageViews(images: images)
    self.setParticipantLabel(count: participants.count)
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
    let bulletImage = KKDS.Image.ic_bullet_3_gr

    for way in ways {
      let attributedString = NSMutableAttributedString(string: "")

      let imageAttachment = NSTextAttachment()
      imageAttachment.image = bulletImage
      imageAttachment.bounds = CGRect(
        x: 0,
        y: (wayLabelFont.capHeight - bulletImage.size.height).rounded() / 2,
        width: bulletImage.size.width,
        height: bulletImage.size.height
      )

      attributedString.append(NSAttributedString(attachment: imageAttachment))
      attributedString.append(NSAttributedString(string: "  \(way)"))

      let waysLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = wayLabelFont
        $0.attributedText = attributedString
        $0.numberOfLines = 0
        $0.textAlignment = .left
      }
      self.waysStackView.addArrangedSubview(waysLabel)
    }
  }

  func setupConstraints() {
    [self.participantImageStackView, self.participantLabel].addSubViews(self.participantView)
    [self.mainImageView, self.topGradientImageView, self.participantView, self.participantSeperatorView, self.titleLabel, self.summaryLabel, self.summarySeperatorView, self.wayHeaderLabel, self.waysStackView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.topGradientImageView.topAnchor.constraint(equalTo: self.topAnchor),
      self.topGradientImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.topGradientImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
      self.mainImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
      self.mainImageView.heightAnchor.constraint(equalTo: self.widthAnchor),

      self.participantView.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: Metric.participantViewTopMargin),
      self.participantView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.participantView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participantViewTrailingMargin),
      self.participantView.heightAnchor.constraint(equalToConstant: Metric.participantViewHeight),

      self.participantImageStackView.topAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantImageStackViewTopMargin),
      self.participantImageStackView.leadingAnchor.constraint(equalTo: self.participantView.leadingAnchor, constant: Metric.participantImageStackViewLeadingMargin),

      self.participantLabel.centerYAnchor.constraint(equalTo: self.participantImageStackView.centerYAnchor),
      self.participantLabel.leadingAnchor.constraint(equalTo: self.participantImageStackView.trailingAnchor, constant: Metric.participantLabelViewLeadingMargin),

      self.participantSeperatorView.heightAnchor.constraint(equalToConstant: Metric.participantSeperatorViewHeight),
      self.participantSeperatorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.participantSeperatorViewLeadingMargin),
      self.participantSeperatorView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participantSeperatorViewTrailingMargin),
      self.participantSeperatorView.topAnchor.constraint(equalTo: self.participantView.bottomAnchor, constant: Metric.participantSeperatorViewTopMargin),

      self.titleLabel.topAnchor.constraint(equalTo: self.participantSeperatorView.bottomAnchor, constant: Metric.titleLabelTopMargin),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.titleLabelLeadingMargin),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.titleLabelTrailingMargin),

      self.summaryLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Metric.summaryLabelTopMargin),
      self.summaryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.summaryLabelLeadingMargin),
      self.summaryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.summaryLabelTrailingMargin),

      self.summarySeperatorView.heightAnchor.constraint(equalToConstant: Metric.summarySeperatorViewHeight),
      self.summarySeperatorView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.summarySeperatorViewLeadingMargin),
      self.summarySeperatorView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.summarySeperatorViewTrailingMargin),
      self.summarySeperatorView.topAnchor.constraint(equalTo: self.summaryLabel.bottomAnchor, constant: Metric.summarySeperatorViewTopMargin),

      self.wayHeaderLabel.topAnchor.constraint(equalTo: self.summarySeperatorView.bottomAnchor, constant: Metric.wayHeaderLabelTopMargin),
      self.wayHeaderLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.wayHeaderLabelLeadingMargin),

      self.waysStackView.topAnchor.constraint(equalTo: self.wayHeaderLabel.bottomAnchor, constant: Metric.wayLabelTopMargin),
      self.waysStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Metric.wayLabelLeadingMargin),
      self.waysStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.wayLabelTrailingMargin),
      self.waysStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}

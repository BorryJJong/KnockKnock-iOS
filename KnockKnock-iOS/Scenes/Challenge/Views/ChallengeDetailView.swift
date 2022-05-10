//
//  ChallengeDetailView.swift
//  KnockKnock-iOS
//
//  Created by Daye on 2022/05/10.
//

import UIKit

import Then

class ChallengeDetailView: UIView {

  // MARK: - Constants

  private enum Metric {
    static let challengeHeight = 245.f

    static let participantViewTopMargin = -15.f
    static let participantViewTrailingMargin = -55.f
    static let participantViewHeight = 45.f

    static let participantImageViewLeadingMargin = 20.f
    static let participantImageViewTopMargin = 20.f

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
  }

  // MARK: - UIs

  let mainImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "challenge")
  }

  let participantView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }

  let participantImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    $0.image = UIImage(named: "ic_person_24")
  }

  let participantLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "첫 번째 참여자가 되어보세요!"
    $0.textColor = .green50
    $0.font = .systemFont(ofSize: 13)
  }

  let participantSeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.text = "#GOGO 챌린지"
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }

  let summaryLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.text = "제로웨이스트 운동 (Zero-waste) 는 말 그대로 쓰레기(Waste) 배출량이 0(zero)인, 다시 말하자면 '쓰레기 없는 생활'을 추구하는 운동입니다. 기존의 환경보호 운동과 차이점이라 하면 제로웨이스트는 일상생활 속에서 발생하는 쓰레기(플라스틱, 일회용 용기 등)를 최소화하는 데 초점을 맞춘 라이프스타일의 관점에서 자주 쓰는 용어입니다."
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }

  let summarySeperatorView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  // MARK: - Initialize

  init() {
    super.init(frame: .zero)
    self.setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupConstraints() {
    [self.participantImageView, self.participantLabel].addSubViews(self.participantView)
    [self.mainImageView, self.participantView, self.participantSeperatorView, self.titleLabel, self.summaryLabel, self.summarySeperatorView].addSubViews(self)

    NSLayoutConstraint.activate([
      self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
      self.mainImageView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
      self.mainImageView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),

      self.participantView.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: Metric.participantViewTopMargin),
      self.participantView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
      self.participantView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: Metric.participantViewTrailingMargin),
      self.participantView.heightAnchor.constraint(equalToConstant: Metric.participantViewHeight),

      self.participantImageView.topAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantImageViewTopMargin),
      self.participantImageView.leadingAnchor.constraint(equalTo: self.participantView.leadingAnchor, constant: Metric.participantImageViewLeadingMargin),

      self.participantLabel.centerYAnchor.constraint(equalTo: self.participantImageView.centerYAnchor),
      self.participantLabel.leadingAnchor.constraint(equalTo: self.participantImageView.trailingAnchor, constant: Metric.participantLabelViewLeadingMargin),

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
    ])
  }
}

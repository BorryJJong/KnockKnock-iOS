//
//  ChallengeCell.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/03/06.
//

import UIKit

final class ChallengeCell: BaseCollectionViewCell {
  
  // MARK: - Constants
  
  private enum Metric {
    static let challengeHeight = 245.f

    static let participantViewTopMargin = -15.f
    static let participantViewTrailingMargin = -77.f
    static let participantViewHeight = 40.f

    static let participantImageViewTopMargin = 15.f

    static let participantLabelViewTopMargin = 15.f
    static let participantLabelViewLeadingMargin = 5.f

    static let seperatorLineViewHeight = 1.f
  }
 
  // MARK: - UI
  
  let challengeImageView = UIImageView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 5
    $0.image = UIImage(named: "challenge")
  }
  let titleLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .black
    $0.text = "#GOGO 챌린지"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  let contentsLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .gray80
    $0.font = .systemFont(ofSize: 13)
    $0.text = "쓰레기를 줄이자는 의미의 제로웨이스트 운동이 활발해 지고있다. 제로웨이스트에 대해 좀 더 알아보자!"
    $0.numberOfLines = 0
    $0.textAlignment = .left
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

  let seperatorLineView = UIView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .gray20
  }

  let newChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .green50
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "NEW"
  }

  let hotChallengeLabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor(red: 236/255, green: 124/255, blue: 108/255, alpha: 1)
    $0.textAlignment = .center
    $0.layer.cornerRadius = 3
    $0.clipsToBounds = true
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 10, weight: .heavy)
    $0.text = "HOT"
  }
  
  // MARK: - Bind
  
  func bind(data: Challenge) {
    self.titleLabel.text = data.title
    self.contentsLabel.text = data.contents
  }
  
  // MARK: - Configure
  
  override func setupConstraints() {
    [self.participantLabel, self.participantImageView].addSubViews(self.participantView)
    [self.challengeImageView, self.participantView, self.seperatorLineView, self.titleLabel, self.contentsLabel, self.newChallengeLabel, self.hotChallengeLabel].addSubViews(self.contentView)
    
    NSLayoutConstraint.activate([
      self.challengeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.challengeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.challengeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.challengeImageView.heightAnchor.constraint(equalToConstant: Metric.challengeHeight),

      self.newChallengeLabel.topAnchor.constraint(equalTo: self.challengeImageView.topAnchor, constant: 11),
      self.newChallengeLabel.leadingAnchor.constraint(equalTo: self.challengeImageView.leadingAnchor, constant: 10),
      self.newChallengeLabel.widthAnchor.constraint(equalToConstant: 40),
      self.newChallengeLabel.heightAnchor.constraint(equalToConstant: 20),

      self.hotChallengeLabel.topAnchor.constraint(equalTo: self.challengeImageView.topAnchor, constant: 11),
      self.hotChallengeLabel.leadingAnchor.constraint(equalTo: self.newChallengeLabel.trailingAnchor, constant: 5),
      self.hotChallengeLabel.widthAnchor.constraint(equalToConstant: 40),
      self.hotChallengeLabel.heightAnchor.constraint(equalToConstant: 20),

      self.participantView.topAnchor.constraint(equalTo: self.challengeImageView.bottomAnchor, constant: Metric.participantViewTopMargin),
      self.participantView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.participantView.trailingAnchor.constraint(equalTo: self.challengeImageView.trailingAnchor, constant: Metric.participantViewTrailingMargin),
      self.participantView.heightAnchor.constraint(equalToConstant: Metric.participantViewHeight),

      self.participantImageView.topAnchor.constraint(equalTo: self.participantView.topAnchor, constant: Metric.participantImageViewTopMargin),
      self.participantImageView.leadingAnchor.constraint(equalTo: self.participantView.leadingAnchor),

      self.participantLabel.centerYAnchor.constraint(equalTo: self.participantImageView.centerYAnchor),
      self.participantLabel.leadingAnchor.constraint(equalTo: self.participantImageView.trailingAnchor, constant: Metric.participantLabelViewLeadingMargin),

      self.seperatorLineView.heightAnchor.constraint(equalToConstant: Metric.seperatorLineViewHeight),
      self.seperatorLineView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
      self.seperatorLineView.topAnchor.constraint(equalTo: self.participantView.bottomAnchor, constant: 10),

      self.titleLabel.topAnchor.constraint(equalTo: self.seperatorLineView.bottomAnchor, constant: 10),
      self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      
      self.contentsLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
      self.contentsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      self.contentsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    ])
  }
}
